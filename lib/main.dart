import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/data/local_database.dart';
import 'src/state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = LocalDatabase();
  await database.open();
  final appState = AppState(database);
  await appState.initialize();

  runApp(WorkMemoryApp(appState: appState));
}
