import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models.dart';
import '../platform/quick_entry_service.dart';
import '../state/app_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.appState, super.key});

  final AppState appState;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _quickEntryService = QuickEntryService();
  String? _registeredQuickEntryShortcut;
  bool _quickEntryDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _quickEntryService.onQuickEntry = _openQuickEntry;
    widget.appState.addListener(_syncQuickEntryShortcut);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _syncQuickEntryShortcut(),
    );
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.appState == widget.appState) return;

    oldWidget.appState.removeListener(_syncQuickEntryShortcut);
    widget.appState.addListener(_syncQuickEntryShortcut);
    _registeredQuickEntryShortcut = null;
    _syncQuickEntryShortcut();
  }

  @override
  void dispose() {
    widget.appState.removeListener(_syncQuickEntryShortcut);
    _quickEntryService.onQuickEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = widget.appState;
    final compact = MediaQuery.sizeOf(context).width < 860;
    final content = appState.section == AppSection.reports
        ? _ReportPane(appState: appState)
        : _TaskWorkspace(appState: appState, compact: compact);

    return Scaffold(
      drawer: compact
          ? Drawer(
              child: _Sidebar(
                appState: appState,
                closeOnSelect: true,
                onEditQuickEntryShortcut: _editQuickEntryShortcut,
              ),
            )
          : null,
      appBar: compact
          ? AppBar(title: Text(_workspaceTitle(appState)), centerTitle: false)
          : null,
      body: Row(
        children: <Widget>[
          if (!compact)
            SizedBox(
              width: 260,
              child: _Sidebar(
                appState: appState,
                onEditQuickEntryShortcut: _editQuickEntryShortcut,
              ),
            ),
          if (!compact) const VerticalDivider(width: 1),
          Expanded(child: content),
        ],
      ),
    );
  }

  void _syncQuickEntryShortcut() {
    final shortcut = widget.appState.quickEntryShortcut;
    final serialized = shortcut.serialize();
    if (_registeredQuickEntryShortcut == serialized) return;

    _registeredQuickEntryShortcut = serialized;
    _quickEntryService.register(shortcut);
  }

  Future<void> _openQuickEntry() async {
    if (!mounted || _quickEntryDialogOpen) return;

    _quickEntryDialogOpen = true;
    try {
      await _showQuickEntryDialog(context, widget.appState);
    } finally {
      _quickEntryDialogOpen = false;
    }
  }

  Future<void> _editQuickEntryShortcut() async {
    final shortcut = await showDialog<QuickEntryShortcut>(
      context: context,
      builder: (_) => _ShortcutRecorderDialog(
        initialShortcut: widget.appState.quickEntryShortcut,
      ),
    );
    if (shortcut == null) return;

    await widget.appState.updateQuickEntryShortcut(shortcut);
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.appState,
    required this.onEditQuickEntryShortcut,
    this.closeOnSelect = false,
  });

  final AppState appState;
  final VoidCallback onEditQuickEntryShortcut;
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
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: _QuickEntryShortcutTile(
              shortcut: appState.quickEntryShortcut,
              onTap: onEditQuickEntryShortcut,
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
  final _paneFocus = FocusNode();

  @override
  void dispose() {
    _newTaskController.dispose();
    _newTaskFocus.dispose();
    _paneFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = widget.appState;
    final canAddTask =
        appState.section != AppSection.upcoming &&
        appState.section != AppSection.completed &&
        appState.section != AppSection.reports;

    return Focus(
      focusNode: _paneFocus,
      autofocus: true,
      child: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.keyN, meta: true):
              _newTaskFocus.requestFocus,
          const SingleActivator(LogicalKeyboardKey.keyN, control: true):
              _newTaskFocus.requestFocus,
          const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
              _selectAdjacentTask(1),
          const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
              _selectAdjacentTask(-1),
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
                          onTap: () => _selectTask(task.id),
                          onCompleted: (completed) =>
                              appState.setTaskCompleted(task, completed),
                          onAddTime: () => _addTimeForTask(task),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTask(int id) async {
    _paneFocus.requestFocus();
    await widget.appState.selectTask(id);
  }

  Future<void> _selectAdjacentTask(int direction) async {
    if (_newTaskFocus.hasFocus || widget.appState.tasks.isEmpty) return;

    final tasks = widget.appState.tasks;
    final currentIndex = tasks.indexWhere(
      (task) => task.id == widget.appState.selectedTaskId,
    );
    final nextIndex = currentIndex < 0
        ? 0
        : (currentIndex + direction).clamp(0, tasks.length - 1);
    await widget.appState.selectTask(tasks[nextIndex].id);
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
                entry.note.isEmpty
                    ? '${formatDate(entry.loggedAt)} ${formatTime(entry.loggedAt)}'
                    : '${formatDate(entry.loggedAt)} ${formatTime(entry.loggedAt)} · ${entry.note}',
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => _editTimeEntry(entry),
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
    try {
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
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _addChecklistItem() async {
    final title = _checklistController.text.trim();
    if (title.isEmpty) return;

    _checklistController.clear();
    await widget.appState.addChecklistItem(title);
  }

  Future<void> _editTimeEntry(TimeEntry entry) async {
    await _showEditTimeEntryDialog(context, widget.appState, entry);
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
    return appState.projectById(appState.selectedReportProjectId) ??
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

class _QuickEntryShortcutTile extends StatelessWidget {
  const _QuickEntryShortcutTile({required this.shortcut, required this.onTap});

  final QuickEntryShortcut shortcut;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      leading: const Icon(Icons.keyboard_outlined, size: 20),
      title: const Text('Quick Entry'),
      trailing: Text(
        shortcut.label(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
        ),
      ),
      onTap: onTap,
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

class _QuickEntryDialog extends StatefulWidget {
  const _QuickEntryDialog({required this.appState});

  final AppState appState;

  @override
  State<_QuickEntryDialog> createState() => _QuickEntryDialogState();
}

class _QuickEntryDialogState extends State<_QuickEntryDialog> {
  final _controller = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Quick Entry'),
      content: SizedBox(
        width: 420,
        child: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            hintText: 'New task',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _submit(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final title = _controller.text.trim();
    if (title.isEmpty || _saving) return;

    setState(() => _saving = true);
    await widget.appState.createInboxTask(title);
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}

class _ShortcutRecorderDialog extends StatefulWidget {
  const _ShortcutRecorderDialog({required this.initialShortcut});

  final QuickEntryShortcut initialShortcut;

  @override
  State<_ShortcutRecorderDialog> createState() =>
      _ShortcutRecorderDialogState();
}

class _ShortcutRecorderDialogState extends State<_ShortcutRecorderDialog> {
  final _focusNode = FocusNode();
  late QuickEntryShortcut _shortcut;
  String? _error;

  @override
  void initState() {
    super.initState();
    _shortcut = widget.initialShortcut;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Quick Entry Shortcut'),
      content: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _recordShortcut,
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                _shortcut.label(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (_error != null) ...<Widget>[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_shortcut),
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _recordShortcut(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    if (_isModifierKey(event.logicalKey)) return;

    final key = _shortcutKeyName(event.logicalKey);
    if (key == null) {
      setState(() => _error = 'Unsupported key.');
      return;
    }

    final pressed = HardwareKeyboard.instance.logicalKeysPressed;
    final shortcut = QuickEntryShortcut(
      key: key,
      meta:
          pressed.contains(LogicalKeyboardKey.metaLeft) ||
          pressed.contains(LogicalKeyboardKey.metaRight),
      control:
          pressed.contains(LogicalKeyboardKey.controlLeft) ||
          pressed.contains(LogicalKeyboardKey.controlRight),
      alt:
          pressed.contains(LogicalKeyboardKey.altLeft) ||
          pressed.contains(LogicalKeyboardKey.altRight),
      shift:
          pressed.contains(LogicalKeyboardKey.shiftLeft) ||
          pressed.contains(LogicalKeyboardKey.shiftRight),
    );

    if (!shortcut.hasModifier) {
      setState(() => _error = 'Use at least one modifier.');
      return;
    }

    setState(() {
      _shortcut = shortcut;
      _error = null;
    });
  }
}

class _TimeEntryDialogResult {
  const _TimeEntryDialogResult({
    required this.durationInput,
    required this.loggedAt,
    required this.note,
    this.delete = false,
  });

  final String durationInput;
  final DateTime loggedAt;
  final String note;
  final bool delete;
}

class _TimeEntryDialog extends StatefulWidget {
  const _TimeEntryDialog({this.entry});

  final TimeEntry? entry;

  @override
  State<_TimeEntryDialog> createState() => _TimeEntryDialogState();
}

class _TimeEntryDialogState extends State<_TimeEntryDialog> {
  final _durationController = TextEditingController();
  final _noteController = TextEditingController();
  late DateTime _loggedAt;
  String? _error;

  bool get _editing => widget.entry != null;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _durationController.text = entry?.rawInput ?? '';
    _noteController.text = entry?.note ?? '';
    _loggedAt = entry?.loggedAt ?? DateTime.now();
  }

  @override
  void dispose() {
    _durationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_editing ? 'Edit time' : 'Log time'),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _durationController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Duration',
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
                      _durationController.text = value;
                      _durationController.selection = TextSelection.collapsed(
                        offset: value.length,
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.event_outlined),
              label: Text(formatDate(_loggedAt)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Note',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
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
        if (_editing)
          TextButton(
            onPressed: _delete,
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(_editing ? 'Save' : 'Add'),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _loggedAt,
      firstDate: DateTime(_loggedAt.year - 10),
      lastDate: DateTime(_loggedAt.year + 20),
    );
    if (!mounted || picked == null) return;

    setState(() {
      _loggedAt = DateTime(
        picked.year,
        picked.month,
        picked.day,
        _loggedAt.hour,
        _loggedAt.minute,
        _loggedAt.second,
        _loggedAt.millisecond,
      );
    });
  }

  void _submit() {
    final value = _durationController.text.trim();
    if (parseTimeInput(value) == null) {
      setState(() => _error = 'Use 15m, 30m, 1h, 2h, or 1w.');
      return;
    }

    Navigator.of(context).pop(
      _TimeEntryDialogResult(
        durationInput: value,
        loggedAt: _loggedAt,
        note: _noteController.text,
      ),
    );
  }

  void _delete() {
    Navigator.of(context).pop(
      _TimeEntryDialogResult(
        durationInput: widget.entry!.rawInput,
        loggedAt: widget.entry!.loggedAt,
        note: widget.entry!.note,
        delete: true,
      ),
    );
  }
}

Future<void> _showTimeLogDialog(BuildContext context, AppState appState) async {
  final result = await showDialog<_TimeEntryDialogResult>(
    context: context,
    builder: (_) => const _TimeEntryDialog(),
  );
  if (result == null) return;

  final error = await appState.addTimeEntryWithDetails(
    durationInput: result.durationInput,
    loggedAt: result.loggedAt,
    note: result.note,
  );
  if (!context.mounted || error == null) return;

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
}

Future<void> _showEditTimeEntryDialog(
  BuildContext context,
  AppState appState,
  TimeEntry entry,
) async {
  final result = await showDialog<_TimeEntryDialogResult>(
    context: context,
    builder: (_) => _TimeEntryDialog(entry: entry),
  );
  if (result == null) return;

  if (result.delete) {
    await appState.deleteTimeEntry(entry.id);
    return;
  }

  final error = await appState.updateTimeEntry(
    entry: entry,
    durationInput: result.durationInput,
    loggedAt: result.loggedAt,
    note: result.note,
  );
  if (!context.mounted || error == null) return;

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
}

Future<void> _showQuickEntryDialog(
  BuildContext context,
  AppState appState,
) async {
  await showDialog<void>(
    context: context,
    builder: (_) => _QuickEntryDialog(appState: appState),
  );
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

bool _isModifierKey(LogicalKeyboardKey key) {
  return key == LogicalKeyboardKey.metaLeft ||
      key == LogicalKeyboardKey.metaRight ||
      key == LogicalKeyboardKey.controlLeft ||
      key == LogicalKeyboardKey.controlRight ||
      key == LogicalKeyboardKey.altLeft ||
      key == LogicalKeyboardKey.altRight ||
      key == LogicalKeyboardKey.shiftLeft ||
      key == LogicalKeyboardKey.shiftRight;
}

String? _shortcutKeyName(LogicalKeyboardKey key) {
  if (key == LogicalKeyboardKey.space) return 'space';
  if (key == LogicalKeyboardKey.enter) return 'enter';
  if (key == LogicalKeyboardKey.tab) return 'tab';
  if (key == LogicalKeyboardKey.escape) return 'escape';
  if (key == LogicalKeyboardKey.backspace) return 'backspace';

  final label = key.keyLabel.toLowerCase();
  if (RegExp(r'^[a-z0-9]$').hasMatch(label)) return label;
  return null;
}

String _workspaceTitle(AppState appState) {
  if (appState.section == AppSection.reports) {
    return sectionLabel(appState.section);
  }

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
