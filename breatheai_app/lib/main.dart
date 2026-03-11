import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/history_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BreatheAIApp());
}

class BreatheAIApp extends StatelessWidget {
  const BreatheAIApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      title: "BreatheAI",

      debugShowCheckedModeBanner: false,

      // ===============================
      // APP THEME
      // ===============================

      theme: ThemeData(

        useMaterial3: true,

        brightness: Brightness.dark,

        scaffoldBackgroundColor: const Color(0xFF0A0F1C),

        colorScheme: const ColorScheme.dark(
          primary: Colors.cyan,
          secondary: Colors.tealAccent,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111827),
          centerTitle: true,
          elevation: 0,
        ),

        cardTheme: const CardThemeData(
          color: Color(0xFF1F2937),
          elevation: 4,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(

          style: ElevatedButton.styleFrom(

            backgroundColor: Colors.cyan,
            foregroundColor: Colors.black,

            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 14,
            ),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),

      // ===============================
      // START SCREEN
      // ===============================

      home: const HomeScreen(),

      // ===============================
      // NAMED ROUTES
      // ===============================

      routes: {

        "/history": (context) => const HistoryScreen(),

      },
    );
  }
}