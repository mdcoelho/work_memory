import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as mobile;
import 'package:sqflite_common/sqlite_api.dart' as sqlite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;

import '../models.dart';

class LocalDatabase {
  LocalDatabase({this.databasePath});

  final String? databasePath;
  late final sqlite.Database _db;

  Future<void> open() async {
    final factory = _databaseFactory();
    final path = databasePath ?? await _defaultDatabasePath();

    _db = await factory.openDatabase(
      path,
      options: sqlite.OpenDatabaseOptions(
        version: 2,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE areas (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL
            )
          ''');

          await db.execute('''
            CREATE TABLE projects (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              area_id INTEGER
            )
          ''');

          await db.execute('''
            CREATE TABLE tasks (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              notes TEXT NOT NULL DEFAULT '',
              created_at INTEGER NOT NULL,
              due_date INTEGER,
              tags TEXT NOT NULL DEFAULT '',
              project_id INTEGER,
              area_id INTEGER,
              completed INTEGER NOT NULL DEFAULT 0,
              completed_at INTEGER,
              bucket TEXT NOT NULL
            )
          ''');

          await db.execute('''
            CREATE TABLE checklist_items (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              task_id INTEGER NOT NULL,
              title TEXT NOT NULL,
              completed INTEGER NOT NULL DEFAULT 0,
              position INTEGER NOT NULL DEFAULT 0
            )
          ''');

          await db.execute('''
            CREATE TABLE time_entries (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              task_id INTEGER NOT NULL,
              minutes INTEGER NOT NULL,
              raw_input TEXT NOT NULL,
              logged_at INTEGER NOT NULL,
              note TEXT NOT NULL DEFAULT ''
            )
          ''');

          await db.execute('''
            CREATE TABLE settings (
              key TEXT PRIMARY KEY,
              value TEXT NOT NULL
            )
          ''');

          await db.execute(
            'CREATE INDEX tasks_bucket_idx ON tasks(bucket, completed)',
          );
          await db.execute(
            'CREATE INDEX time_entries_task_idx ON time_entries(task_id)',
          );
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute(
              "ALTER TABLE time_entries ADD COLUMN note TEXT NOT NULL DEFAULT ''",
            );
            await db.execute('''
              CREATE TABLE IF NOT EXISTS settings (
                key TEXT PRIMARY KEY,
                value TEXT NOT NULL
              )
            ''');
          }
        },
      ),
    );
  }

  Future<void> close() => _db.close();

  Future<int> createTask({
    required String title,
    required TaskBucket bucket,
    int? projectId,
    int? areaId,
  }) {
    return _db.insert('tasks', <String, Object?>{
      'title': title,
      'notes': '',
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'tags': '',
      'project_id': projectId,
      'area_id': areaId,
      'completed': 0,
      'bucket': bucket.name,
    });
  }

  Future<void> updateTask(TaskItem task) {
    return _db.update(
      'tasks',
      _taskToRow(task),
      where: 'id = ?',
      whereArgs: <Object?>[task.id],
    );
  }

  Future<void> setTaskCompleted(TaskItem task, bool completed) {
    return _db.update(
      'tasks',
      <String, Object?>{
        'completed': completed ? 1 : 0,
        'completed_at': completed
            ? DateTime.now().millisecondsSinceEpoch
            : null,
      },
      where: 'id = ?',
      whereArgs: <Object?>[task.id],
    );
  }

  Future<List<TaskItem>> tasksForSection(
    AppSection section, {
    int? projectId,
    int? areaId,
  }) async {
    final rows = await _db.rawQuery(
      _tasksQuery(
        where: _whereForSection(section, projectId: projectId, areaId: areaId),
      ),
    );
    return rows.map(_taskFromRow).toList();
  }

  Future<TaskDetail?> taskDetail(int taskId) async {
    final taskRows = await _db.rawQuery(
      _tasksQuery(where: 'tasks.id = $taskId'),
    );
    if (taskRows.isEmpty) return null;

    final checklistRows = await _db.query(
      'checklist_items',
      where: 'task_id = ?',
      whereArgs: <Object?>[taskId],
      orderBy: 'position ASC, id ASC',
    );

    final timeRows = await _db.query(
      'time_entries',
      where: 'task_id = ?',
      whereArgs: <Object?>[taskId],
      orderBy: 'logged_at DESC',
    );

    return TaskDetail(
      task: _taskFromRow(taskRows.single),
      checklist: checklistRows.map(_checklistFromRow).toList(),
      timeEntries: timeRows.map(_timeEntryFromRow).toList(),
    );
  }

  Future<int> createProject(String name, {int? areaId}) {
    return _db.insert('projects', <String, Object?>{
      'name': name,
      'area_id': areaId,
    });
  }

  Future<int> createArea(String name) {
    return _db.insert('areas', <String, Object?>{'name': name});
  }

  Future<List<Project>> projects() async {
    final rows = await _db.query('projects', orderBy: 'name COLLATE NOCASE');
    return rows.map(_projectFromRow).toList();
  }

  Future<List<Area>> areas() async {
    final rows = await _db.query('areas', orderBy: 'name COLLATE NOCASE');
    return rows.map(_areaFromRow).toList();
  }

  Future<int> addChecklistItem(int taskId, String title) async {
    final count =
        mobile.Sqflite.firstIntValue(
          await _db.rawQuery(
            'SELECT COUNT(*) FROM checklist_items WHERE task_id = ?',
            <Object?>[taskId],
          ),
        ) ??
        0;

    return _db.insert('checklist_items', <String, Object?>{
      'task_id': taskId,
      'title': title,
      'completed': 0,
      'position': count,
    });
  }

  Future<void> setChecklistCompleted(int id, bool completed) {
    return _db.update(
      'checklist_items',
      <String, Object?>{'completed': completed ? 1 : 0},
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );
  }

  Future<void> addTimeEntry({
    required int taskId,
    required int minutes,
    required String rawInput,
    DateTime? loggedAt,
    String note = '',
  }) {
    return _db.insert('time_entries', <String, Object?>{
      'task_id': taskId,
      'minutes': minutes,
      'raw_input': rawInput,
      'logged_at': (loggedAt ?? DateTime.now()).millisecondsSinceEpoch,
      'note': note,
    });
  }

  Future<void> updateTimeEntry(TimeEntry entry) {
    return _db.update(
      'time_entries',
      <String, Object?>{
        'minutes': entry.minutes,
        'raw_input': entry.rawInput,
        'logged_at': entry.loggedAt.millisecondsSinceEpoch,
        'note': entry.note,
      },
      where: 'id = ?',
      whereArgs: <Object?>[entry.id],
    );
  }

  Future<void> deleteTimeEntry(int id) {
    return _db.delete(
      'time_entries',
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );
  }

  Future<QuickEntryShortcut> quickEntryShortcut() async {
    final rows = await _db.query(
      'settings',
      columns: <String>['value'],
      where: 'key = ?',
      whereArgs: <Object?>['quick_entry_shortcut'],
      limit: 1,
    );
    if (rows.isEmpty) return QuickEntryShortcut.defaultShortcut;

    return QuickEntryShortcut.parse(rows.single['value']! as String) ??
        QuickEntryShortcut.defaultShortcut;
  }

  Future<void> setQuickEntryShortcut(QuickEntryShortcut shortcut) {
    return _db.insert('settings', <String, Object?>{
      'key': 'quick_entry_shortcut',
      'value': shortcut.serialize(),
    }, conflictAlgorithm: sqlite.ConflictAlgorithm.replace);
  }

  Future<List<ReportRow>> reportRows({
    required int projectId,
    required ReportGrouping grouping,
    DateTime? start,
    DateTime? end,
  }) async {
    final range = _rangeFor(grouping, start: start, end: end);
    final rows = await _db.rawQuery(
      '''
      SELECT time_entries.minutes, time_entries.logged_at
      FROM time_entries
      INNER JOIN tasks ON tasks.id = time_entries.task_id
      WHERE tasks.project_id = ?
      AND time_entries.logged_at >= ?
      AND time_entries.logged_at < ?
      ORDER BY time_entries.logged_at ASC
      ''',
      <Object?>[
        projectId,
        range.start.millisecondsSinceEpoch,
        range.end.millisecondsSinceEpoch,
      ],
    );

    final grouped = <String, int>{};
    for (final row in rows) {
      final loggedAt = DateTime.fromMillisecondsSinceEpoch(
        row['logged_at']! as int,
      );
      final label = grouping == ReportGrouping.custom
          ? _customRangeLabel(range)
          : _groupLabel(loggedAt, grouping);
      grouped[label] = (grouped[label] ?? 0) + (row['minutes']! as int);
    }

    return grouped.entries
        .map((entry) => ReportRow(label: entry.key, minutes: entry.value))
        .toList();
  }

  sqlite.DatabaseFactory _databaseFactory() {
    if (Platform.isAndroid || Platform.isIOS) {
      return mobile.databaseFactory;
    }

    ffi.sqfliteFfiInit();
    return ffi.databaseFactoryFfi;
  }

  Future<String> _defaultDatabasePath() async {
    final directory = await getApplicationSupportDirectory();
    await directory.create(recursive: true);
    return p.join(directory.path, 'work_memory.sqlite');
  }

  String _tasksQuery({required String where}) {
    return '''
      SELECT tasks.*,
      COALESCE(SUM(time_entries.minutes), 0) AS total_logged_minutes
      FROM tasks
      LEFT JOIN time_entries ON time_entries.task_id = tasks.id
      WHERE $where
      GROUP BY tasks.id
      ORDER BY
        CASE WHEN tasks.due_date IS NULL THEN 1 ELSE 0 END ASC,
        tasks.due_date ASC,
        tasks.created_at DESC
    ''';
  }

  String _whereForSection(AppSection section, {int? projectId, int? areaId}) {
    final today = DateTime.now();
    final startToday = DateTime(today.year, today.month, today.day);
    final endToday = startToday.add(const Duration(days: 1));

    if (projectId != null) {
      return 'tasks.completed = 0 AND tasks.project_id = $projectId';
    }

    if (areaId != null) {
      return 'tasks.completed = 0 AND tasks.area_id = $areaId';
    }

    switch (section) {
      case AppSection.inbox:
        return "tasks.completed = 0 AND tasks.bucket = 'inbox'";
      case AppSection.today:
        return "tasks.completed = 0 AND (tasks.bucket = 'today' OR "
            '(tasks.due_date >= ${startToday.millisecondsSinceEpoch} '
            'AND tasks.due_date < ${endToday.millisecondsSinceEpoch}))';
      case AppSection.upcoming:
        return 'tasks.completed = 0 AND tasks.due_date >= '
            '${endToday.millisecondsSinceEpoch}';
      case AppSection.anytime:
        return "tasks.completed = 0 AND tasks.bucket = 'anytime'";
      case AppSection.someday:
        return "tasks.completed = 0 AND tasks.bucket = 'someday'";
      case AppSection.projects:
      case AppSection.areas:
        return 'tasks.completed = 0';
      case AppSection.completed:
        return 'tasks.completed = 1';
      case AppSection.reports:
        return 'tasks.completed = 0';
    }
  }

  _DateRange _rangeFor(
    ReportGrouping grouping, {
    DateTime? start,
    DateTime? end,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (grouping) {
      case ReportGrouping.day:
      case ReportGrouping.week:
      case ReportGrouping.month:
        return _DateRange(DateTime(1970), DateTime(now.year + 20));
      case ReportGrouping.custom:
        final customStart = start ?? today;
        final customEnd = (end ?? today).add(const Duration(days: 1));
        return _DateRange(
          DateTime(customStart.year, customStart.month, customStart.day),
          DateTime(customEnd.year, customEnd.month, customEnd.day),
        );
    }
  }

  String _customRangeLabel(_DateRange range) {
    final inclusiveEnd = range.end.subtract(const Duration(days: 1));
    return '${formatDate(range.start)} - ${formatDate(inclusiveEnd)}';
  }

  String _groupLabel(DateTime date, ReportGrouping grouping) {
    switch (grouping) {
      case ReportGrouping.day:
      case ReportGrouping.custom:
        return formatDate(date);
      case ReportGrouping.week:
        final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return '${formatShortDate(startOfWeek)} - ${formatShortDate(endOfWeek)}';
      case ReportGrouping.month:
        return '${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }

  TaskItem _taskFromRow(Map<String, Object?> row) {
    return TaskItem(
      id: row['id']! as int,
      title: row['title']! as String,
      notes: row['notes']! as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at']! as int),
      dueDate: row['due_date'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(row['due_date']! as int),
      tags: (row['tags']! as String)
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList(),
      projectId: row['project_id'] as int?,
      areaId: row['area_id'] as int?,
      completed: (row['completed']! as int) == 1,
      completedAt: row['completed_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(row['completed_at']! as int),
      bucket: TaskBucket.values.byName(row['bucket']! as String),
      totalLoggedMinutes: row['total_logged_minutes'] as int? ?? 0,
    );
  }

  Map<String, Object?> _taskToRow(TaskItem task) {
    return <String, Object?>{
      'title': task.title,
      'notes': task.notes,
      'created_at': task.createdAt.millisecondsSinceEpoch,
      'due_date': task.dueDate?.millisecondsSinceEpoch,
      'tags': task.tags.join(','),
      'project_id': task.projectId,
      'area_id': task.areaId,
      'completed': task.completed ? 1 : 0,
      'completed_at': task.completedAt?.millisecondsSinceEpoch,
      'bucket': task.bucket.name,
    };
  }

  ChecklistItem _checklistFromRow(Map<String, Object?> row) {
    return ChecklistItem(
      id: row['id']! as int,
      taskId: row['task_id']! as int,
      title: row['title']! as String,
      completed: (row['completed']! as int) == 1,
      position: row['position']! as int,
    );
  }

  TimeEntry _timeEntryFromRow(Map<String, Object?> row) {
    return TimeEntry(
      id: row['id']! as int,
      taskId: row['task_id']! as int,
      minutes: row['minutes']! as int,
      rawInput: row['raw_input']! as String,
      loggedAt: DateTime.fromMillisecondsSinceEpoch(row['logged_at']! as int),
      note: row['note']! as String,
    );
  }

  Project _projectFromRow(Map<String, Object?> row) {
    return Project(
      id: row['id']! as int,
      name: row['name']! as String,
      areaId: row['area_id'] as int?,
    );
  }

  Area _areaFromRow(Map<String, Object?> row) {
    return Area(id: row['id']! as int, name: row['name']! as String);
  }
}

class _DateRange {
  const _DateRange(this.start, this.end);

  final DateTime start;
  final DateTime end;
}
