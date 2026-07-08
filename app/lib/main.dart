import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final store = MemoryStore();
  await store.open();

  await windowManager.ensureInitialized();
  await windowManager.setPreventClose(true);

  const windowOptions = WindowOptions(
    size: Size(760, 520),
    center: true,
    minimumSize: Size(620, 420),
    title: 'Work Memory',
    titleBarStyle: TitleBarStyle.hidden,
    alwaysOnTop: true,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(WorkMemoryApp(store: store));
}

class WorkMemoryApp extends StatelessWidget {
  const WorkMemoryApp({required this.store, super.key});

  final MemoryStore store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Work Memory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      home: PaletteScreen(store: store),
    );
  }
}

class PaletteScreen extends StatefulWidget {
  const PaletteScreen({required this.store, super.key});

  final MemoryStore store;

  @override
  State<PaletteScreen> createState() => _PaletteScreenState();
}

class _PaletteScreenState extends State<PaletteScreen> with WindowListener {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();

  List<MemoryEntry> _entries = <MemoryEntry>[];
  bool _loading = true;
  bool _saving = false;
  String? _error;
  String _modeLabel = 'Today';
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _inputFocusNode.onKeyEvent = _handleInputKey;
    _controller.addListener(_onInputChanged);
    _loadToday();
    _registerGlobalShortcut();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _controller.dispose();
    _inputFocusNode.dispose();
    hotKeyManager.unregisterAll();
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Future<void> onWindowClose() async {
    await _hidePalette();
  }

  Future<void> _registerGlobalShortcut() async {
    await hotKeyManager.unregisterAll();

    final hotKey = HotKey(
      key: PhysicalKeyboardKey.space,
      modifiers: const <HotKeyModifier>[HotKeyModifier.control],
      scope: HotKeyScope.system,
    );

    await hotKeyManager.register(
      hotKey,
      keyDownHandler: (_) => _showPalette(),
    );
  }

  Future<void> _showPalette() async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setAlwaysOnTop(true);
    await _loadToday();
    _controller.clear();
    _inputFocusNode.requestFocus();
  }

  Future<void> _hidePalette() async {
    await windowManager.hide();
  }

  void _onInputChanged() {
    final text = _controller.text.trim();

    _searchDebounce?.cancel();

    if (text.startsWith('/')) {
      final query = text.substring(1).trim();
      _searchDebounce = Timer(
        const Duration(milliseconds: 120),
        () => _search(query),
      );
      return;
    }

    if (text.toLowerCase() == 'today') {
      _searchDebounce = Timer(
        const Duration(milliseconds: 120),
        _loadToday,
      );
    }
  }

  Future<void> _loadToday() async {
    setState(() {
      _loading = true;
      _error = null;
      _modeLabel = 'Today';
    });

    try {
      final entries = await widget.store.today();
      if (!mounted) return;
      setState(() {
        _entries = entries;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load today. $error';
        _loading = false;
      });
    }
  }

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      await _loadToday();
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _modeLabel = 'Search: $query';
    });

    try {
      final entries = await widget.store.search(query);
      if (!mounted) return;
      setState(() {
        _entries = entries;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = 'Search failed. $error';
        _loading = false;
      });
    }
  }

  Future<void> _submit() async {
    final rawText = _controller.text.trim();
    if (rawText.isEmpty || _saving) return;

    if (rawText == '/' || rawText.startsWith('/')) {
      return;
    }

    if (rawText.toLowerCase() == 'today') {
      await _loadToday();
      _controller.clear();
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await widget.store.insert(rawText);
      _controller.clear();
      await _loadToday();
      await _hidePalette();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not save. Your text is still here. $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _hidePalette();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  KeyEventResult _handleInputKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _hidePalette();
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter &&
        !HardwareKeyboard.instance.isShiftPressed) {
      _submit();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: _handleKey,
      child: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.enter): () {
            unawaited(_submit());
          },
          const SingleActivator(LogicalKeyboardKey.escape): () {
            unawaited(_hidePalette());
          },
        },
        child: Scaffold(
          backgroundColor: const Color(0xFF111827),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _Header(modeLabel: _modeLabel),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _controller,
                    focusNode: _inputFocusNode,
                    autofocus: true,
                    minLines: 3,
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                    style: const TextStyle(fontSize: 18, height: 1.35),
                    decoration: InputDecoration(
                      hintText:
                          'What should not be lost?  / search   today',
                      filled: true,
                      fillColor: const Color(0xFF1F2937),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _HelpText(saving: _saving),
                  if (_error != null) ...<Widget>[
                    const SizedBox(height: 10),
                    Text(
                      _error!,
                      style: const TextStyle(color: Color(0xFFFCA5A5)),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Expanded(
                    child: _MemoryList(
                      loading: _loading,
                      entries: _entries,
                      emptyLabel: _modeLabel.startsWith('Search')
                          ? 'No matching memories.'
                          : 'No memories captured today.',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.modeLabel});

  final String modeLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Text(
          'Work Memory',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
        const Spacer(),
        Text(
          modeLabel,
          style: const TextStyle(
            color: Color(0xFFD1D5DB),
            fontSize: 14,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _HelpText extends StatelessWidget {
  const _HelpText({required this.saving});

  final bool saving;

  @override
  Widget build(BuildContext context) {
    final text = saving
        ? 'Saving...'
        : 'Enter saves  |  Shift+Enter newline  |  / searches  |  today shows today  |  Esc closes';

    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF9CA3AF),
        fontSize: 13,
      ),
    );
  }
}

class _MemoryList extends StatelessWidget {
  const _MemoryList({
    required this.loading,
    required this.entries,
    required this.emptyLabel,
  });

  final bool loading;
  final List<MemoryEntry> entries;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (entries.isEmpty) {
      return Center(
        child: Text(
          emptyLabel,
          style: const TextStyle(color: Color(0xFF9CA3AF)),
        ),
      );
    }

    return ListView.separated(
      itemCount: entries.length,
      separatorBuilder: (_, __) => const Divider(
        color: Color(0xFF374151),
        height: 1,
      ),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 58,
                child: Text(
                  entry.timeLabel,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SelectableText(
                  entry.content,
                  style: const TextStyle(fontSize: 16, height: 1.35),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MemoryEntry {
  const MemoryEntry({
    required this.id,
    required this.content,
    required this.createdAt,
  });

  final int id;
  final String content;
  final DateTime createdAt;

  String get timeLabel {
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  factory MemoryEntry.fromRow(Map<String, Object?> row) {
    return MemoryEntry(
      id: row['id']! as int,
      content: row['content']! as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        row['created_at']! as int,
      ),
    );
  }
}

class MemoryStore {
  static const _dbName = 'work_memory.sqlite';

  MemoryStore({String? databasePath}) : _databasePath = databasePath;

  final String? _databasePath;
  late final Database _db;

  Future<void> open() async {
    final dbPath = _databasePath ?? await _defaultDatabasePath();

    _db = await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE memories (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              content TEXT NOT NULL,
              created_at INTEGER NOT NULL
            )
          ''');
          await db.execute(
            'CREATE INDEX memories_created_at_idx ON memories(created_at)',
          );
          await db.execute(
            'CREATE INDEX memories_content_idx ON memories(content)',
          );
        },
      ),
    );
  }

  Future<String> _defaultDatabasePath() async {
    final supportDir = await getApplicationSupportDirectory();
    await supportDir.create(recursive: true);
    return path.join(supportDir.path, _dbName);
  }

  Future<void> insert(String content) async {
    await _db.insert('memories', <String, Object?>{
      'content': content,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<MemoryEntry>> today() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final rows = await _db.query(
      'memories',
      where: 'created_at >= ?',
      whereArgs: <Object?>[start.millisecondsSinceEpoch],
      orderBy: 'created_at DESC',
      limit: 100,
    );

    return rows.map(MemoryEntry.fromRow).toList();
  }

  Future<List<MemoryEntry>> search(String query) async {
    final rows = await _db.query(
      'memories',
      where: 'content LIKE ? COLLATE NOCASE',
      whereArgs: <Object?>['%$query%'],
      orderBy: 'created_at DESC',
      limit: 100,
    );

    return rows.map(MemoryEntry.fromRow).toList();
  }

  Future<void> close() => _db.close();
}
