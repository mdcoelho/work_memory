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
      final taskId = await database.createTask(
        title: 'Prepare supplier notes',
        bucket: TaskBucket.today,
        projectId: projectId,
      );

      await database.addTimeEntry(
        taskId: taskId,
        minutes: parseTimeInput('15m')!,
        rawInput: '15m',
      );
      await database.addTimeEntry(
        taskId: taskId,
        minutes: parseTimeInput('1h')!,
        rawInput: '1h',
      );

      final detail = await database.taskDetail(taskId);
      expect(detail?.task.totalLoggedMinutes, 75);
      expect(detail?.timeEntries, hasLength(2));

      final rows = await database.reportRows(
        projectId: projectId,
        grouping: ReportGrouping.custom,
        start: DateTime.now().subtract(const Duration(days: 1)),
        end: DateTime.now().add(const Duration(days: 1)),
      );

      expect(rows.fold<int>(0, (total, row) => total + row.minutes), 75);
    } finally {
      await database.close();
      await directory.delete(recursive: true);
    }
  });
}
