import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models.dart';
import '../state/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.appState, super.key});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 860;
    final content = appState.section == AppSection.reports
        ? _ReportPane(appState: appState)
        : _TaskWorkspace(appState: appState, compact: compact);

    return Scaffold(
      drawer: compact
          ? Drawer(child: _Sidebar(appState: appState, closeOnSelect: true))
          : null,
      appBar: compact
          ? AppBar(title: Text(_workspaceTitle(appState)), centerTitle: false)
          : null,
      body: Row(
        children: <Widget>[
          if (!compact)
            SizedBox(width: 260, child: _Sidebar(appState: appState)),
          if (!compact) const VerticalDivider(width: 1),
          Expanded(child: content),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.appState, this.closeOnSelect = false});

  final AppState appState;
  final bool closeOnSelect;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Work Memory',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: <Widget>[
                _SectionTile(
                  icon: Icons.inbox_outlined,
                  label: 'Inbox',
                  selected: _isSectionSelected(appState, AppSection.inbox),
                  onTap: () => _selectSection(context, AppSection.inbox),
                ),
                _SectionTile(
                  icon: Icons.today_outlined,
                  label: 'Today',
                  selected: _isSectionSelected(appState, AppSection.today),
                  onTap: () => _selectSection(context, AppSection.today),
                ),
                _SectionTile(
                  icon: Icons.calendar_month_outlined,
                  label: 'Upcoming',
                  selected: _isSectionSelected(appState, AppSection.upcoming),
                  onTap: () => _selectSection(context, AppSection.upcoming),
                ),
                _SectionTile(
                  icon: Icons.inventory_2_outlined,
                  label: 'Anytime',
                  selected: _isSectionSelected(appState, AppSection.anytime),
                  onTap: () => _selectSection(context, AppSection.anytime),
                ),
                _SectionTile(
                  icon: Icons.archive_outlined,
                  label: 'Someday',
                  selected: _isSectionSelected(appState, AppSection.someday),
                  onTap: () => _selectSection(context, AppSection.someday),
                ),
                _SectionTile(
                  icon: Icons.done_all_outlined,
                  label: 'Logbook',
                  selected: _isSectionSelected(appState, AppSection.completed),
                  onTap: () => _selectSection(context, AppSection.completed),
                ),
                _SectionTile(
                  icon: Icons.bar_chart_outlined,
                  label: 'Reports',
                  selected: _isSectionSelected(appState, AppSection.reports),
                  onTap: () => _selectSection(context, AppSection.reports),
                ),
                const SizedBox(height: 18),
                _ListHeader(
                  label: 'Projects',
                  onAdd: () => _showNameDialog(
                    context: context,
                    title: 'New project',
                    onCreate: appState.createProject,
                  ),
                ),
                if (appState.projects.isEmpty)
                  const _SidebarEmpty(label: 'No projects'),
                for (final project in appState.projects)
                  _SectionTile(
                    icon: Icons.folder_outlined,
                    label: project.name,
                    selected:
                        appState.section == AppSection.projects &&
                        appState.selectedProjectId == project.id,
                    onTap: () => _selectProject(context, project.id),
                  ),
                const SizedBox(height: 12),
                _ListHeader(
                  label: 'Areas',
                  onAdd: () => _showNameDialog(
                    context: context,
                    title: 'New area',
                    onCreate: appState.createArea,
                  ),
                ),
                if (appState.areas.isEmpty)
                  const _SidebarEmpty(label: 'No areas'),
                for (final area in appState.areas)
                  _SectionTile(
                    icon: Icons.grid_view_outlined,
                    label: area.name,
                    selected:
                        appState.section == AppSection.areas &&
                        appState.selectedAreaId == area.id,
                    onTap: () => _selectArea(context, area.id),
                  ),
              ],
            ),
          ),
          if (appState.error != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                appState.error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _isSectionSelected(AppState appState, AppSection section) {
    return appState.section == section &&
        appState.selectedProjectId == null &&
        appState.selectedAreaId == null;
  }

  Future<void> _selectSection(BuildContext context, AppSection section) async {
    if (closeOnSelect) Navigator.of(context).pop();
    await appState.selectSection(section);
  }

  Future<void> _selectProject(BuildContext context, int id) async {
    if (closeOnSelect) Navigator.of(context).pop();
    await appState.selectProject(id);
  }

  Future<void> _selectArea(BuildContext context, int id) async {
    if (closeOnSelect) Navigator.of(context).pop();
    await appState.selectArea(id);
  }
}

class _TaskWorkspace extends StatelessWidget {
  const _TaskWorkspace({required this.appState, required this.compact});

  final AppState appState;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Column(
        children: <Widget>[
          Expanded(child: _TaskListPane(appState: appState)),
          const Divider(height: 1),
          SizedBox(height: 390, child: _TaskDetailPane(appState: appState)),
        ],
      );
    }

    return Row(
      children: <Widget>[
        SizedBox(width: 410, child: _TaskListPane(appState: appState)),
        const VerticalDivider(width: 1),
        Expanded(child: _TaskDetailPane(appState: appState)),
      ],
    );
  }
}

class _TaskListPane extends StatefulWidget {
  const _TaskListPane({required this.appState});

  final AppState appState;

  @override
  State<_TaskListPane> createState() => _TaskListPaneState();
}

class _TaskListPaneState extends State<_TaskListPane> {
  final _newTaskController = TextEditingController();
  final _newTaskFocus = FocusNode();

  @override
  void dispose() {
    _newTaskController.dispose();
    _newTaskFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = widget.appState;
    final canAddTask =
        appState.section != AppSection.upcoming &&
        appState.section != AppSection.completed &&
        appState.section != AppSection.reports;

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.keyN, meta: true):
            _newTaskFocus.requestFocus,
        const SingleActivator(LogicalKeyboardKey.keyN, control: true):
            _newTaskFocus.requestFocus,
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _workspaceTitle(appState),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 10),
                if (canAddTask)
                  TextField(
                    controller: _newTaskController,
                    focusNode: _newTaskFocus,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.add_rounded),
                      hintText: 'New task',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _createTask(),
                  ),
              ],
            ),
          ),
          if (appState.loading) const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: appState.tasks.isEmpty
                ? _EmptyState(
                    icon: Icons.check_circle_outline,
                    title: 'No tasks here',
                    message: canAddTask
                        ? 'Add a task and keep moving.'
                        : 'This list is built from task dates or completed tasks.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 18),
                    itemCount: appState.tasks.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final task = appState.tasks[index];
                      return _TaskRow(
                        task: task,
                        selected: appState.selectedTaskId == task.id,
                        project: appState.projectById(task.projectId),
                        area: appState.areaById(task.areaId),
                        onTap: () => appState.selectTask(task.id),
                        onCompleted: (completed) =>
                            appState.setTaskCompleted(task, completed),
                        onAddTime: () => _addTimeForTask(task),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _createTask() async {
    final title = _newTaskController.text;
    _newTaskController.clear();
    await widget.appState.createTask(title);
    _newTaskFocus.requestFocus();
  }

  Future<void> _addTimeForTask(TaskItem task) async {
    await widget.appState.selectTask(task.id);
    if (!mounted) return;
    await _showTimeLogDialog(context, widget.appState);
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.task,
    required this.selected,
    required this.onTap,
    required this.onCompleted,
    required this.onAddTime,
    this.project,
    this.area,
  });

  final TaskItem task;
  final bool selected;
  final Project? project;
  final Area? area;
  final VoidCallback onTap;
  final ValueChanged<bool> onCompleted;
  final VoidCallback onAddTime;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final metadata = <String>[
      if (task.dueDate != null) formatShortDate(task.dueDate!),
      if (project != null) project!.name,
      if (area != null) area!.name,
      if (task.tags.isNotEmpty) task.tags.join(', '),
    ];

    return Material(
      color: selected ? colorScheme.primaryContainer : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                value: task.completed,
                onChanged: (value) => onCompleted(value ?? false),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      task.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        decoration: task.completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    if (metadata.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          metadata.join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                formatDuration(task.totalLoggedMinutes),
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                tooltip: 'Log time',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.add_rounded),
                onPressed: onAddTime,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskDetailPane extends StatefulWidget {
  const _TaskDetailPane({required this.appState});

  final AppState appState;

  @override
  State<_TaskDetailPane> createState() => _TaskDetailPaneState();
}

class _TaskDetailPaneState extends State<_TaskDetailPane> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagsController = TextEditingController();
  final _checklistController = TextEditingController();

  int? _taskId;
  TaskBucket _bucket = TaskBucket.inbox;
  DateTime? _dueDate;
  int? _projectId;
  int? _areaId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _syncFromDetail();
  }

  @override
  void didUpdateWidget(covariant _TaskDetailPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextId = widget.appState.selectedTask?.task.id;
    if (nextId != _taskId) {
      _syncFromDetail();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    _checklistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.appState.selectedTask;
    if (detail == null) {
      return const _EmptyState(
        icon: Icons.task_alt_outlined,
        title: 'Select a task',
        message: 'Task details will appear here.',
      );
    }

    final task = detail.task;
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      children: <Widget>[
        Row(
          children: <Widget>[
            Checkbox(
              value: task.completed,
              onChanged: (value) =>
                  widget.appState.setTaskCompleted(task, value ?? false),
            ),
            Expanded(
              child: TextField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Task title',
                ),
                onSubmitted: (_) => _saveTask(task),
              ),
            ),
            FilledButton.icon(
              onPressed: _saving ? null : () => _saveTask(task),
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: const Text('Save'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            SizedBox(
              width: 180,
              child: DropdownButtonFormField<TaskBucket>(
                key: ValueKey<String>('bucket-$_taskId'),
                initialValue: _bucket,
                decoration: const InputDecoration(
                  labelText: 'List',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: TaskBucket.values
                    .map(
                      (bucket) => DropdownMenuItem<TaskBucket>(
                        value: bucket,
                        child: Text(bucketLabel(bucket)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _bucket = value);
                },
              ),
            ),
            SizedBox(
              width: 220,
              child: DropdownButtonFormField<int?>(
                key: ValueKey<String>('project-$_taskId'),
                initialValue: _projectId,
                decoration: const InputDecoration(
                  labelText: 'Project',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: <DropdownMenuItem<int?>>[
                  const DropdownMenuItem<int?>(child: Text('No project')),
                  for (final project in widget.appState.projects)
                    DropdownMenuItem<int?>(
                      value: project.id,
                      child: Text(project.name),
                    ),
                ],
                onChanged: (value) => setState(() => _projectId = value),
              ),
            ),
            SizedBox(
              width: 220,
              child: DropdownButtonFormField<int?>(
                key: ValueKey<String>('area-$_taskId'),
                initialValue: _areaId,
                decoration: const InputDecoration(
                  labelText: 'Area',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: <DropdownMenuItem<int?>>[
                  const DropdownMenuItem<int?>(child: Text('No area')),
                  for (final area in widget.appState.areas)
                    DropdownMenuItem<int?>(
                      value: area.id,
                      child: Text(area.name),
                    ),
                ],
                onChanged: (value) => setState(() => _areaId = value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: <Widget>[
            OutlinedButton.icon(
              onPressed: _pickDueDate,
              icon: const Icon(Icons.event_outlined),
              label: Text(
                _dueDate == null ? 'No due date' : formatDate(_dueDate!),
              ),
            ),
            if (_dueDate != null) ...<Widget>[
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => setState(() => _dueDate = null),
                child: const Text('Clear date'),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _notesController,
          minLines: 4,
          maxLines: 8,
          decoration: const InputDecoration(
            labelText: 'Notes',
            alignLabelWithHint: true,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _tagsController,
          decoration: const InputDecoration(
            labelText: 'Tags',
            hintText: 'comma separated',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onSubmitted: (_) => _saveTask(task),
        ),
        const SizedBox(height: 24),
        Text('Checklist', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final item in detail.checklist)
          CheckboxListTile(
            value: item.completed,
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              item.title,
              style: TextStyle(
                decoration: item.completed ? TextDecoration.lineThrough : null,
              ),
            ),
            onChanged: (value) =>
                widget.appState.setChecklistCompleted(item.id, value ?? false),
          ),
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _checklistController,
                decoration: const InputDecoration(
                  hintText: 'Add checklist item',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onSubmitted: (_) => _addChecklistItem(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              tooltip: 'Add checklist item',
              onPressed: _addChecklistItem,
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Time',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text(
              formatDuration(task.totalLoggedMinutes),
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 10),
            IconButton.filled(
              tooltip: 'Log time',
              onPressed: () => _showTimeLogDialog(context, widget.appState),
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (detail.timeEntries.isEmpty)
          Text(
            'No time logged.',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          )
        else
          for (final entry in detail.timeEntries)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: const Icon(Icons.schedule_outlined),
              title: Text(formatDuration(entry.minutes)),
              subtitle: Text(
                '${formatDate(entry.loggedAt)} ${formatTime(entry.loggedAt)}',
              ),
              trailing: Text(entry.rawInput),
            ),
      ],
    );
  }

  void _syncFromDetail() {
    final detail = widget.appState.selectedTask;
    _taskId = detail?.task.id;
    if (detail == null) return;

    final task = detail.task;
    _titleController.text = task.title;
    _notesController.text = task.notes;
    _tagsController.text = task.tags.join(', ');
    _bucket = task.bucket;
    _dueDate = task.dueDate;
    _projectId = task.projectId;
    _areaId = task.areaId;
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final initialDate = _dueDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 20),
    );
    if (!mounted || picked == null) return;
    setState(() => _dueDate = picked);
  }

  Future<void> _saveTask(TaskItem task) async {
    final cleanTitle = _titleController.text.trim();
    if (cleanTitle.isEmpty) return;

    setState(() => _saving = true);
    await widget.appState.updateSelectedTask(
      task.copyWith(
        title: cleanTitle,
        notes: _notesController.text.trim(),
        dueDate: _dueDate,
        tags: _splitTags(_tagsController.text),
        projectId: _projectId,
        areaId: _areaId,
        bucket: _bucket,
      ),
    );
    if (!mounted) return;
    setState(() => _saving = false);
  }

  Future<void> _addChecklistItem() async {
    final title = _checklistController.text.trim();
    if (title.isEmpty) return;

    _checklistController.clear();
    await widget.appState.addChecklistItem(title);
  }
}

class _ReportPane extends StatefulWidget {
  const _ReportPane({required this.appState});

  final AppState appState;

  @override
  State<_ReportPane> createState() => _ReportPaneState();
}

class _ReportPaneState extends State<_ReportPane> {
  DateTime? _start;
  DateTime? _end;

  @override
  Widget build(BuildContext context) {
    final appState = widget.appState;
    final projects = appState.projects;
    final selectedProject = _selectedReportProject(appState);
    final totalMinutes = appState.reportRows.fold<int>(
      0,
      (total, row) => total + row.minutes,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 22, 28, 32),
      children: <Widget>[
        const Text(
          'Reports',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 18),
        if (projects.isEmpty)
          _EmptyState(
            icon: Icons.folder_off_outlined,
            title: 'No projects',
            message: 'Create a project before logging project time.',
            action: FilledButton.icon(
              onPressed: () => _showNameDialog(
                context: context,
                title: 'New project',
                onCreate: appState.createProject,
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text('New project'),
            ),
          )
        else ...<Widget>[
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 260,
                child: DropdownButtonFormField<int>(
                  key: ValueKey<String>(
                    'report-project-${selectedProject?.id}',
                  ),
                  initialValue: selectedProject?.id,
                  decoration: const InputDecoration(
                    labelText: 'Project',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: projects
                      .map(
                        (project) => DropdownMenuItem<int>(
                          value: project.id,
                          child: Text(project.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    appState.setReportProject(value);
                  },
                ),
              ),
              SegmentedButton<ReportGrouping>(
                segments: const <ButtonSegment<ReportGrouping>>[
                  ButtonSegment<ReportGrouping>(
                    value: ReportGrouping.day,
                    label: Text('Day'),
                  ),
                  ButtonSegment<ReportGrouping>(
                    value: ReportGrouping.week,
                    label: Text('Week'),
                  ),
                  ButtonSegment<ReportGrouping>(
                    value: ReportGrouping.month,
                    label: Text('Month'),
                  ),
                  ButtonSegment<ReportGrouping>(
                    value: ReportGrouping.custom,
                    label: Text('Range'),
                  ),
                ],
                selected: <ReportGrouping>{appState.reportGrouping},
                onSelectionChanged: (selection) =>
                    _setGrouping(selection.single),
              ),
            ],
          ),
          if (appState.reportGrouping == ReportGrouping.custom) ...<Widget>[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                OutlinedButton.icon(
                  onPressed: () => _pickDate(isStart: true),
                  icon: const Icon(Icons.event_outlined),
                  label: Text(
                    _start == null ? 'Start date' : formatDate(_start!),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _pickDate(isStart: false),
                  icon: const Icon(Icons.event_outlined),
                  label: Text(_end == null ? 'End date' : formatDate(_end!)),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          Text(
            selectedProject == null ? 'Project time' : selectedProject.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(
            'Total: ${formatDuration(totalMinutes)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          if (appState.reportRows.isEmpty)
            const _EmptyState(
              icon: Icons.bar_chart_outlined,
              title: 'No time logged',
              message: 'Logged task time will appear here.',
            )
          else
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: <Widget>[
                  for (final row in appState.reportRows)
                    ListTile(
                      title: Text(row.label),
                      trailing: Text(
                        formatDuration(row.minutes),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ],
    );
  }

  Project? _selectedReportProject(AppState appState) {
    if (appState.projects.isEmpty) return null;
    return appState.projectById(appState.selectedProjectId) ??
        appState.projects.first;
  }

  Future<void> _setGrouping(ReportGrouping grouping) async {
    await widget.appState.setReportGrouping(grouping);
    if (grouping == ReportGrouping.custom) {
      await _refreshCustomReport();
    }
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _start ?? now : _end ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 20),
    );
    if (!mounted || picked == null) return;

    setState(() {
      if (isStart) {
        _start = picked;
      } else {
        _end = picked;
      }
    });
    await _refreshCustomReport();
  }

  Future<void> _refreshCustomReport() async {
    await widget.appState.refreshReport(start: _start, end: _end);
    if (!mounted) return;
    setState(() {});
  }
}

class _SectionTile extends StatelessWidget {
  const _SectionTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      selected: selected,
      selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      leading: Icon(icon, size: 20),
      title: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      onTap: onTap,
    );
  }
}

class _ListHeader extends StatelessWidget {
  const _ListHeader({required this.label, required this.onAdd});

  final String label;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Add $label',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.add_rounded),
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}

class _SidebarEmpty extends StatelessWidget {
  const _SidebarEmpty({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(44, 2, 12, 8),
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 34, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            if (action != null) ...<Widget>[
              const SizedBox(height: 14),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class _TimeLogDialog extends StatefulWidget {
  const _TimeLogDialog();

  @override
  State<_TimeLogDialog> createState() => _TimeLogDialogState();
}

class _TimeLogDialogState extends State<_TimeLogDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log time'),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Time',
                hintText: '15m, 30m, 1h, 2h, 1w',
                errorText: _error,
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: <Widget>[
                for (final value in const <String>[
                  '15m',
                  '30m',
                  '1h',
                  '2h',
                  '1w',
                ])
                  ActionChip(
                    label: Text(value),
                    onPressed: () {
                      _controller.text = value;
                      _submit();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '1w is stored as 40h.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Add')),
      ],
    );
  }

  void _submit() {
    final value = _controller.text.trim();
    if (parseTimeInput(value) == null) {
      setState(() => _error = 'Use 15m, 30m, 1h, 2h, or 1w.');
      return;
    }
    Navigator.of(context).pop(value);
  }
}

Future<void> _showTimeLogDialog(BuildContext context, AppState appState) async {
  final input = await showDialog<String>(
    context: context,
    builder: (_) => const _TimeLogDialog(),
  );
  if (input == null) return;

  final error = await appState.addTimeEntry(input);
  if (!context.mounted || error == null) return;

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
}

Future<void> _showNameDialog({
  required BuildContext context,
  required String title,
  required Future<void> Function(String name) onCreate,
}) async {
  final controller = TextEditingController();
  final name = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Create'),
          ),
        ],
      );
    },
  );
  controller.dispose();

  if (name == null || name.trim().isEmpty) return;
  await onCreate(name);
}

String _workspaceTitle(AppState appState) {
  if (appState.selectedProjectId != null) {
    return appState.projectById(appState.selectedProjectId)?.name ?? 'Project';
  }

  if (appState.selectedAreaId != null) {
    return appState.areaById(appState.selectedAreaId)?.name ?? 'Area';
  }

  return sectionLabel(appState.section);
}

List<String> _splitTags(String value) {
  return value
      .split(',')
      .map((tag) => tag.trim())
      .where((tag) => tag.isNotEmpty)
      .toList();
}
