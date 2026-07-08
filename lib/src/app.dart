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
              seedColor: const Color(0xFF315D72),
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFF7F5F0),
            useMaterial3: true,
            visualDensity: VisualDensity.compact,
            splashFactory: InkSparkle.splashFactory,
            dividerTheme: const DividerThemeData(
              color: Color(0xFFE4E0D8),
              space: 1,
              thickness: 1,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFF7F5F0),
              foregroundColor: Color(0xFF22201C),
              elevation: 0,
              scrolledUnderElevation: 0,
            ),
            cardTheme: CardThemeData(
              color: Colors.white.withValues(alpha: 0.78),
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Color(0xFFE6E1D8)),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.62),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(color: Color(0xFFE0DBD1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(color: Color(0xFFE0DBD1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: const BorderSide(
                  color: Color(0xFF315D72),
                  width: 1.4,
                ),
              ),
            ),
            textTheme: const TextTheme(
              headlineMedium: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
                height: 1.12,
              ),
              titleLarge: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
              ),
              titleMedium: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
              ),
              bodyMedium: TextStyle(fontSize: 14, height: 1.32),
              bodySmall: TextStyle(fontSize: 12, height: 1.25),
            ),
          ),
          home: HomeScreen(appState: appState),
        );
      },
    );
  }
}
