import 'package:flutter/material.dart';

import 'state/app_state.dart';
import 'ui/home_screen.dart';

class WorkMemoryApp extends StatelessWidget {
  const WorkMemoryApp({required this.appState, super.key});

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Work Memory',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF44636F),
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFF7F6F2),
            useMaterial3: true,
            visualDensity: VisualDensity.compact,
          ),
          home: HomeScreen(appState: appState),
        );
      },
    );
  }
}
