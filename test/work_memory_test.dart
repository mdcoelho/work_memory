import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:work_memory/src/data/local_database.dart';
import 'package:work_memory/src/models.dart';

void main() {
  group('manual time input', () {
    test('parses minutes, hours, and work weeks', () {
      expect(parseTimeInput('15m'), 15);
      expect(parseTimeInput('30m'), 30);
      expect(parseTimeInput('1h'), 60);
      expect(parseTimeInput('2h'), 120);
      expect(parseTimeInput('1w'), 2400);
    });

    test('rejects invalid values', () {
      expect(parseTimeInput(''), isNull);
      expect(parseTimeInput('0m'), isNull);
      expect(parseTimeInput('15'), isNull);
      expect(parseTimeInput('1d'), isNull);
    });
  });

  group('quick entry shortcut', () {
    test('serializes and parses shortcut settings', () {
      const shortcut = QuickEntryShortcut(
        key: 'space',
        meta: true,
        shift: true,
      );

      expect(shortcut.serialize(), 'meta+shift+space');
      expect(
        QuickEntryShortcut.parse(shortcut.serialize())?.label(),
        '⇧⌘Space',
      );
      expect(QuickEntryShortcut.parse('space'), isNull);
    });
  });

  test('stores tasks and aggregates project time locally', () async {
    final directory = await Directory.systemTemp.createTemp(
      'work_memory_test_',
    );
    final database = LocalDatabase(
      databasePath: p.join(directory.path, 'test.sqlite'),
    );

    await database.open();

    try {
      final projectId = await database.createProject('Launch');
      await database.updateProject(Project(id: projectId, name: 'Launch Plan'));
      expect((await database.projects()).single.name, 'Launch Plan');

      final taskId = await database.createTask(
        title: 'Prepare supplier notes',
        bucket: TaskBucket.today,
        projectId: projectId,
      );

      await database.addTimeEntry(
        taskId: taskId,
        minutes: parseTimeInput('15m')!,
        rawInput: '15m',
        loggedAt: DateTime(2026, 7, 8, 9),
        note: 'Supplier call',
      );
      await database.addTimeEntry(
        taskId: taskId,
        minutes: parseTimeInput('1h')!,
        rawInput: '1h',
        loggedAt: DateTime(2026, 7, 8, 10),
      );

      final detail = await database.taskDetail(taskId);
      expect(detail?.task.totalLoggedMinutes, 75);
      expect(detail?.timeEntries, hasLength(2));
      expect(detail?.timeEntries.last.note, 'Supplier call');

      final rows = await database.reportRows(
        projectId: projectId,
        grouping: ReportGrouping.custom,
        start: DateTime.now().subtract(const Duration(days: 1)),
        end: DateTime.now().add(const Duration(days: 1)),
      );

      expect(rows.fold<int>(0, (total, row) => total + row.minutes), 75);

      await database.updateTimeEntry(
        TimeEntry(
          id: detail!.timeEntries.first.id,
          taskId: taskId,
          minutes: parseTimeInput('2h')!,
          rawInput: '2h',
          loggedAt: DateTime(2026, 7, 8, 10),
          note: 'Updated',
        ),
      );

      final updated = await database.taskDetail(taskId);
      expect(updated?.task.totalLoggedMinutes, 135);
      expect(updated?.timeEntries.first.note, 'Updated');

      await database.deleteTimeEntry(updated!.timeEntries.first.id);

      final deleted = await database.taskDetail(taskId);
      expect(deleted?.task.totalLoggedMinutes, 15);

      const shortcut = QuickEntryShortcut(key: 'n', control: true);
      await database.setQuickEntryShortcut(shortcut);
      expect((await database.quickEntryShortcut()).serialize(), 'control+n');
    } finally {
      await database.close();
      await directory.delete(recursive: true);
    }
  });
}
