import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🎨 Color palette
  static const Color primaryGreen = Color(0xFF1B5E20);
  static const Color accentGreen = Color(0xFF2E7D32);
  static const Color mutedBlue = Color(0xFF7F9DAC);
  static const Color darkGray = Color(0xFF202020);
  static const Color lightGray = Color(0xFF9FA2A0);
  static const Color neutralGray = Color(0xFFE9E9E9);
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgroundBeige = Color(0xFFF8F5F0);

  // Precomputed shadow colors (use const hex so analyzer can't complain)
  static const Color _shadowColorLight = Color(0x14000000); // ~8% black
  static const Color _shadowColorSofter = Color(0x0A000000); // ~4% black

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: const ColorScheme.light(
      primary: primaryGreen,
      onPrimary: white,
      secondary: accentGreen,
      onSecondary: white,
      surface: white,
      onSurface: darkGray,
      background: backgroundBeige,
      onBackground: darkGray,
      error: Colors.red,
      onError: white,
    ),

    scaffoldBackgroundColor: backgroundBeige,

    appBarTheme: AppBarTheme(
      backgroundColor: white,
      foregroundColor: primaryGreen,
      elevation: 1.5,
      // use our const shadow color
      shadowColor: _shadowColorLight,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryGreen,
      ),
      surfaceTintColor: white,
    ),

    // ✅ Card style — uses const shadow color (no withOpacity calls)
   // ✅ Card style — updated for Flutter 3.24+
cardTheme: const CardThemeData(
  color: white,
  elevation: 4,
  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  ),
  shadowColor: Color(0x14000000), // 8% black for soft shadow
),


    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      headlineLarge: GoogleFonts.poppins(
        color: primaryGreen,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: GoogleFonts.poppins(
        color: darkGray,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: GoogleFonts.poppins(
        color: darkGray,
        fontSize: 16,
      ),
      labelLarge: GoogleFonts.poppins(
        color: white,
        fontWeight: FontWeight.w600,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(4),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
        ),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return accentGreen.withOpacity(0.9);
          }
          return primaryGreen;
        }),
        foregroundColor: MaterialStateProperty.all(white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        textStyle: MaterialStateProperty.all(
          GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryGreen,
        textStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: neutralGray.withOpacity(0.25),
      hintStyle: GoogleFonts.poppins(color: lightGray),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: neutralGray.withOpacity(0.8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: neutralGray.withOpacity(0.8)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: primaryGreen, width: 1.6),
      ),
      labelStyle: GoogleFonts.poppins(color: lightGray),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryGreen,
      foregroundColor: white,
      elevation: 4,
    ),

    dividerTheme: DividerThemeData(
      color: neutralGray.withOpacity(0.5),
      thickness: 0.8,
      space: 24,
    ),
  );
}
