import 'package:flutter/foundation.dart';

import '../data/local_database.dart';
import '../models.dart';

class AppState extends ChangeNotifier {
  AppState(this._database);

  final LocalDatabase _database;

  AppSection section = AppSection.inbox;
  int? selectedProjectId;
  int? selectedAreaId;
  int? selectedTaskId;
  int? selectedReportProjectId;

  List<Project> projects = <Project>[];
  List<Area> areas = <Area>[];
  List<TaskItem> tasks = <TaskItem>[];
  TaskDetail? selectedTask;
  List<ReportRow> reportRows = <ReportRow>[];
  ReportGrouping reportGrouping = ReportGrouping.week;
  QuickEntryShortcut quickEntryShortcut = QuickEntryShortcut.defaultShortcut;

  bool loading = false;
  String? error;

  Future<void> initialize() async {
    quickEntryShortcut = await _database.quickEntryShortcut();
    await refreshAll();
  }

  Future<void> refreshAll({bool showLoading = true}) async {
    error = null;
    if (showLoading) {
      loading = true;
      notifyListeners();
    }

    try {
      projects = await _database.projects();
      areas = await _database.areas();
      tasks = await _database.tasksForSection(
        section,
        projectId: selectedProjectId,
        areaId: selectedAreaId,
      );
      await _refreshSelectedTask();
      await refreshReport();
    } catch (exception) {
      error = exception.toString();
    } finally {
      if (showLoading) {
        loading = false;
      }
      notifyListeners();
    }
  }

  Future<void> selectSection(AppSection nextSection) async {
    section = nextSection;
    selectedProjectId = null;
    selectedAreaId = null;
    selectedTaskId = null;
    selectedTask = null;
    await refreshAll();
  }

  Future<void> selectProject(int id) async {
    section = AppSection.projects;
    selectedProjectId = id;
    selectedAreaId = null;
    selectedTaskId = null;
    selectedTask = null;
    await refreshAll();
  }

  Future<void> selectArea(int id) async {
    section = AppSection.areas;
    selectedAreaId = id;
    selectedProjectId = null;
    selectedTaskId = null;
    selectedTask = null;
    await refreshAll();
  }

  Future<void> selectTask(int id) async {
    selectedTaskId = id;
    await _refreshSelectedTask();
    notifyListeners();
  }

  Future<void> createTask(String title) async {
    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty) return;

    final id = await _database.createTask(
      title: cleanTitle,
      bucket: _bucketForCurrentSection(),
      projectId: selectedProjectId,
      areaId: selectedAreaId,
    );
    selectedTaskId = id;
    await refreshAll();
  }

  Future<void> createInboxTask(String title) async {
    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty) return;

    final id = await _database.createTask(
      title: cleanTitle,
      bucket: TaskBucket.inbox,
    );

    if (section == AppSection.inbox &&
        selectedProjectId == null &&
        selectedAreaId == null) {
      selectedTaskId = id;
    }
    await refreshAll(showLoading: false);
  }

  Future<void> createProject(String name) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) return;

    final id = await _database.createProject(cleanName);
    await selectProject(id);
  }

  Future<void> updateProjectName(Project project, String name) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty || cleanName == project.name) return;

    await _database.updateProject(
      Project(id: project.id, name: cleanName, areaId: project.areaId),
    );
    await refreshAll(showLoading: false);
  }

  Future<void> createArea(String name) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) return;

    final id = await _database.createArea(cleanName);
    await selectArea(id);
  }

  Future<void> updateSelectedTask(TaskItem task) async {
    await _database.updateTask(task);
    await refreshAll();
  }

  Future<void> setTaskCompleted(TaskItem task, bool completed) async {
    await _database.setTaskCompleted(task, completed);
    selectedTaskId = completed ? null : task.id;
    await refreshAll();
  }

  Future<void> addChecklistItem(String title) async {
    final taskId = selectedTaskId;
    if (taskId == null || title.trim().isEmpty) return;

    await _database.addChecklistItem(taskId, title.trim());
    await refreshAll();
  }

  Future<void> setChecklistCompleted(int id, bool completed) async {
    await _database.setChecklistCompleted(id, completed);
    await refreshAll();
  }

  Future<String?> addTimeEntry(String input) async {
    return addTimeEntryWithDetails(durationInput: input);
  }

  Future<String?> addTimeEntryWithDetails({
    required String durationInput,
    DateTime? loggedAt,
    String note = '',
  }) async {
    final taskId = selectedTaskId;
    if (taskId == null) return 'Select a task first.';

    final minutes = parseTimeInput(durationInput);
    if (minutes == null) {
      return 'Use formats like 15m, 30m, 1h, 2h, 1w.';
    }

    await _database.addTimeEntry(
      taskId: taskId,
      minutes: minutes,
      rawInput: durationInput.trim(),
      loggedAt: loggedAt,
      note: note.trim(),
    );
    await refreshAll(showLoading: false);
    return null;
  }

  Future<String?> updateTimeEntry({
    required TimeEntry entry,
    required String durationInput,
    required DateTime loggedAt,
    required String note,
  }) async {
    final minutes = parseTimeInput(durationInput);
    if (minutes == null) {
      return 'Use formats like 15m, 30m, 1h, 2h, 1w.';
    }

    await _database.updateTimeEntry(
      TimeEntry(
        id: entry.id,
        taskId: entry.taskId,
        minutes: minutes,
        rawInput: durationInput.trim(),
        loggedAt: loggedAt,
        note: note.trim(),
      ),
    );
    await refreshAll(showLoading: false);
    return null;
  }

  Future<void> deleteTimeEntry(int id) async {
    await _database.deleteTimeEntry(id);
    await refreshAll(showLoading: false);
  }

  Future<void> updateQuickEntryShortcut(QuickEntryShortcut shortcut) async {
    quickEntryShortcut = shortcut;
    await _database.setQuickEntryShortcut(shortcut);
    notifyListeners();
  }

  Future<void> setReportGrouping(ReportGrouping grouping) async {
    reportGrouping = grouping;
    await refreshReport();
    notifyListeners();
  }

  Future<void> setReportProject(int projectId) async {
    selectedReportProjectId = projectId;
    await refreshReport();
    notifyListeners();
  }

  Future<void> refreshReport({DateTime? start, DateTime? end}) async {
    if (projects.isEmpty) {
      reportRows = <ReportRow>[];
      return;
    }

    final projectId = selectedReportProjectId ?? projects.first.id;
    reportRows = await _database.reportRows(
      projectId: projectId,
      grouping: reportGrouping,
      start: start,
      end: end,
    );
  }

  Project? projectById(int? id) {
    if (id == null) return null;
    for (final project in projects) {
      if (project.id == id) return project;
    }
    return null;
  }

  Area? areaById(int? id) {
    if (id == null) return null;
    for (final area in areas) {
      if (area.id == id) return area;
    }
    return null;
  }

  Future<void> _refreshSelectedTask() async {
    if (selectedTaskId == null) {
      selectedTask = tasks.isEmpty
          ? null
          : await _database.taskDetail(tasks.first.id);
      selectedTaskId = selectedTask?.task.id;
      return;
    }

    final selectedTaskIsVisible = tasks.any(
      (task) => task.id == selectedTaskId,
    );
    if (!selectedTaskIsVisible) {
      selectedTask = tasks.isEmpty
          ? null
          : await _database.taskDetail(tasks.first.id);
      selectedTaskId = selectedTask?.task.id;
      return;
    }

    selectedTask = await _database.taskDetail(selectedTaskId!);
  }

  TaskBucket _bucketForCurrentSection() {
    switch (section) {
      case AppSection.today:
        return TaskBucket.today;
      case AppSection.anytime:
      case AppSection.projects:
      case AppSection.areas:
      case AppSection.upcoming:
      case AppSection.completed:
      case AppSection.reports:
        return TaskBucket.anytime;
      case AppSection.someday:
        return TaskBucket.someday;
      case AppSection.inbox:
        return TaskBucket.inbox;
    }
  }
}
