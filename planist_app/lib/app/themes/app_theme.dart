import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.black, // Tüm sayfalarda siyah arka plan
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.black, // AppBar arka planı siyah
          iconTheme:
              IconThemeData(color: Colors.white), // AppBar ikonları beyaz
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.white, // Butonlar için beyaz renk
        ),
        cardTheme: const CardTheme(
          color: Colors.black, // Kartlar için siyah arka plan
        ),
        dialogBackgroundColor: Colors.black, // Dialoglar için siyah arka plan
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.black, // Tüm sayfalarda siyah arka plan
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.black, // AppBar arka planı siyah
          iconTheme:
              IconThemeData(color: Colors.white), // AppBar ikonları beyaz
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.white, // Butonlar için beyaz renk
        ),
        cardTheme: const CardTheme(
          color: Colors.black, // Kartlar için siyah arka plan
        ),
        dialogBackgroundColor: Colors.black, // Dialoglar için siyah arka plan
      );
}
