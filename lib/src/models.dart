enum TaskBucket { inbox, today, anytime, someday }

enum AppSection {
  inbox,
  today,
  upcoming,
  anytime,
  someday,
  projects,
  areas,
  completed,
  reports,
}

enum ReportGrouping { day, week, month, custom }

class QuickEntryShortcut {
  const QuickEntryShortcut({
    required this.key,
    this.meta = false,
    this.control = false,
    this.alt = false,
    this.shift = false,
  });

  static const defaultShortcut = QuickEntryShortcut(
    key: 'space',
    control: true,
  );

  final String key;
  final bool meta;
  final bool control;
  final bool alt;
  final bool shift;

  bool get hasModifier => meta || control || alt || shift;

  String serialize() {
    final parts = <String>[
      if (meta) 'meta',
      if (control) 'control',
      if (alt) 'alt',
      if (shift) 'shift',
      key,
    ];
    return parts.join('+');
  }

  String label() {
    final parts = <String>[
      if (control) '⌃',
      if (alt) '⌥',
      if (shift) '⇧',
      if (meta) '⌘',
      _keyLabel(key),
    ];
    return parts.join('');
  }

  Map<String, Object> toPlatformArguments() {
    return <String, Object>{
      'key': key,
      'meta': meta,
      'control': control,
      'alt': alt,
      'shift': shift,
    };
  }

  static QuickEntryShortcut? parse(String value) {
    final parts = value
        .split('+')
        .map((part) => part.trim().toLowerCase())
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return null;

    final key = parts.last;
    final modifiers = parts.take(parts.length - 1).toSet();
    final shortcut = QuickEntryShortcut(
      key: key,
      meta: modifiers.contains('meta') || modifiers.contains('command'),
      control: modifiers.contains('control') || modifiers.contains('ctrl'),
      alt: modifiers.contains('alt') || modifiers.contains('option'),
      shift: modifiers.contains('shift'),
    );

    return shortcut.hasModifier ? shortcut : null;
  }

  static String _keyLabel(String key) {
    switch (key) {
      case 'space':
        return 'Space';
      case 'enter':
        return 'Enter';
      case 'tab':
        return 'Tab';
      case 'escape':
        return 'Esc';
      case 'backspace':
        return 'Delete';
      default:
        if (key.length == 1) return key.toUpperCase();
        return key;
    }
  }
}

class Area {
  const Area({required this.id, required this.name});

  final int id;
  final String name;
}

class Project {
  const Project({required this.id, required this.name, this.areaId});

  final int id;
  final String name;
  final int? areaId;
}

class TaskItem {
  const TaskItem({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.completed,
    required this.bucket,
    this.notes = '',
    this.dueDate,
    this.tags = const <String>[],
    this.projectId,
    this.areaId,
    this.completedAt,
    this.totalLoggedMinutes = 0,
  });

  final int id;
  final String title;
  final String notes;
  final DateTime createdAt;
  final DateTime? dueDate;
  final List<String> tags;
  final int? projectId;
  final int? areaId;
  final bool completed;
  final DateTime? completedAt;
  final TaskBucket bucket;
  final int totalLoggedMinutes;

  TaskItem copyWith({
    int? id,
    String? title,
    String? notes,
    DateTime? createdAt,
    Object? dueDate = _unchanged,
    List<String>? tags,
    Object? projectId = _unchanged,
    Object? areaId = _unchanged,
    bool? completed,
    Object? completedAt = _unchanged,
    TaskBucket? bucket,
    int? totalLoggedMinutes,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate == _unchanged ? this.dueDate : dueDate as DateTime?,
      tags: tags ?? this.tags,
      projectId: projectId == _unchanged ? this.projectId : projectId as int?,
      areaId: areaId == _unchanged ? this.areaId : areaId as int?,
      completed: completed ?? this.completed,
      completedAt: completedAt == _unchanged
          ? this.completedAt
          : completedAt as DateTime?,
      bucket: bucket ?? this.bucket,
      totalLoggedMinutes: totalLoggedMinutes ?? this.totalLoggedMinutes,
    );
  }
}

class ChecklistItem {
  const ChecklistItem({
    required this.id,
    required this.taskId,
    required this.title,
    required this.completed,
    required this.position,
  });

  final int id;
  final int taskId;
  final String title;
  final bool completed;
  final int position;
}

class TimeEntry {
  const TimeEntry({
    required this.id,
    required this.taskId,
    required this.minutes,
    required this.rawInput,
    required this.loggedAt,
    this.note = '',
  });

  final int id;
  final int taskId;
  final int minutes;
  final String rawInput;
  final DateTime loggedAt;
  final String note;
}

class TaskDetail {
  const TaskDetail({
    required this.task,
    required this.checklist,
    required this.timeEntries,
  });

  final TaskItem task;
  final List<ChecklistItem> checklist;
  final List<TimeEntry> timeEntries;
}

class ReportRow {
  const ReportRow({required this.label, required this.minutes});

  final String label;
  final int minutes;
}

const Object _unchanged = Object();

String bucketLabel(TaskBucket bucket) {
  switch (bucket) {
    case TaskBucket.inbox:
      return 'Inbox';
    case TaskBucket.today:
      return 'Today';
    case TaskBucket.anytime:
      return 'Anytime';
    case TaskBucket.someday:
      return 'Someday';
  }
}

String sectionLabel(AppSection section) {
  switch (section) {
    case AppSection.inbox:
      return 'Inbox';
    case AppSection.today:
      return 'Today';
    case AppSection.upcoming:
      return 'Upcoming';
    case AppSection.anytime:
      return 'Anytime';
    case AppSection.someday:
      return 'Someday';
    case AppSection.projects:
      return 'Projects';
    case AppSection.areas:
      return 'Areas';
    case AppSection.completed:
      return 'Logbook';
    case AppSection.reports:
      return 'Reports';
  }
}

String formatDuration(int minutes) {
  if (minutes <= 0) return '0m';

  final hours = minutes ~/ 60;
  final remainingMinutes = minutes % 60;

  if (hours == 0) {
    return '${remainingMinutes}m';
  }

  if (remainingMinutes == 0) {
    return '${hours}h';
  }

  return '${hours}h ${remainingMinutes}m';
}

int? parseTimeInput(String input) {
  final trimmed = input.trim().toLowerCase();
  final match = RegExp(r'^(\d+)\s*([mhw])$').firstMatch(trimmed);
  if (match == null) return null;

  final amount = int.tryParse(match.group(1)!);
  if (amount == null || amount <= 0) return null;

  switch (match.group(2)) {
    case 'm':
      return amount;
    case 'h':
      return amount * 60;
    case 'w':
      return amount * 40 * 60;
  }

  return null;
}

String formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

String formatShortDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month';
}

String formatTime(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
