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

  List<Project> projects = <Project>[];
  List<Area> areas = <Area>[];
  List<TaskItem> tasks = <TaskItem>[];
  TaskDetail? selectedTask;
  List<ReportRow> reportRows = <ReportRow>[];
  ReportGrouping reportGrouping = ReportGrouping.week;

  bool loading = false;
  String? error;

  Future<void> initialize() async {
    await refreshAll();
  }

  Future<void> refreshAll() async {
    loading = true;
    error = null;
    notifyListeners();

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
      loading = false;
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

  Future<void> createProject(String name) async {
    final cleanName = name.trim();
    if (cleanName.isEmpty) return;

    final id = await _database.createProject(cleanName);
    await selectProject(id);
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
    final taskId = selectedTaskId;
    if (taskId == null) return 'Select a task first.';

    final minutes = parseTimeInput(input);
    if (minutes == null) {
      return 'Use formats like 15m, 30m, 1h, 2h, 1w.';
    }

    await _database.addTimeEntry(
      taskId: taskId,
      minutes: minutes,
      rawInput: input.trim(),
    );
    await refreshAll();
    return null;
  }

  Future<void> setReportGrouping(ReportGrouping grouping) async {
    reportGrouping = grouping;
    await refreshReport();
    notifyListeners();
  }

  Future<void> setReportProject(int projectId) async {
    selectedProjectId = projectId;
    await refreshReport();
    notifyListeners();
  }

  Future<void> refreshReport({DateTime? start, DateTime? end}) async {
    if (projects.isEmpty) {
      reportRows = <ReportRow>[];
      return;
    }

    final projectId = selectedProjectId ?? projects.first.id;
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
