import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF1B5E20);
  static const Color lightGreen = Color(0xFF2E7D32);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color bgLight = Color(0xFFF5F0E8);
  static const Color bgCard = Color(0xFFFFFDF7);
  static const Color bgDark = Color(0xFF0D2B0D);
  static const Color bgCardDark = Color(0xFF1A3A1A);
  static const Color textDark = Color(0xFF1C1C1C);
  static const Color textLight = Color(0xFFF5F5F0);
  static const Color textGrey = Color(0xFF6B6B6B);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGreen,
          primary: primaryGreen,
          secondary: accentGold,
          surface: bgLight,
          background: bgLight,
        ),
        scaffoldBackgroundColor: bgLight,
        textTheme: GoogleFonts.cairoTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.cairo(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        cardTheme: CardThemeData(
          color: bgCard,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGreen,
          brightness: Brightness.dark,
          primary: lightGreen,
          secondary: accentGold,
          surface: bgCardDark,
          background: bgDark,
        ),
        scaffoldBackgroundColor: bgDark,
        textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: bgDark,
          foregroundColor: textLight,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.cairo(
              fontSize: 20, fontWeight: FontWeight.bold, color: textLight),
        ),
        cardTheme: CardThemeData(
          color: bgCardDark,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      );
}
