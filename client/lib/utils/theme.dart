import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const blackColor = Color(0xff1c1c1c);
const blackColor2 = Colors.black12;
const lightGreyColor = Color(0xffeeeeee);

class AppTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: GoogleFonts.exo2(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.grey,
    ),
    bodyMedium: GoogleFonts.exo2(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: blackColor,
    ),
    displayLarge: GoogleFonts.exo2(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: blackColor,
    ),
    displayMedium: GoogleFonts.exo2(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: blackColor,
    ),
    displaySmall: GoogleFonts.exo2(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: blackColor,
    ),
    titleLarge: GoogleFonts.exo2(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: blackColor,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyLarge: GoogleFonts.exo2(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.grey,
    ),
    bodyMedium: GoogleFonts.exo2(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    displayLarge: GoogleFonts.exo2(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displayMedium: GoogleFonts.exo2(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    displaySmall: GoogleFonts.exo2(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleLarge: GoogleFonts.exo2(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  static ThemeData light() {
    return ThemeData(
      primaryColor: Colors.white,
      colorScheme: const ColorScheme.light().copyWith(secondary: blackColor),
      fontFamily: GoogleFonts.exo2().fontFamily,
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        foregroundColor: blackColor,
        backgroundColor: Colors.white,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: blackColor,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.white,
      ),
      textTheme: lightTextTheme,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(color: blackColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.5),
          borderSide: const BorderSide(color: blackColor),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          elevation: MaterialStateProperty.all(6),
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.all(16),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          foregroundColor: MaterialStateProperty.all<Color>(blackColor),
          overlayColor: MaterialStateProperty.all<Color>(lightGreyColor),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        foregroundColor: blackColor,
      )),
      iconTheme: const IconThemeData(
        color: blackColor,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: blackColor,
        selectionColor: Colors.grey,
        selectionHandleColor: blackColor,
      ),
      indicatorColor: blackColor,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: blackColor,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      primaryColor: blackColor,
      colorScheme: const ColorScheme.dark().copyWith(secondary: Colors.white),
      scaffoldBackgroundColor: blackColor,
      fontFamily: GoogleFonts.exo2().fontFamily,
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[900],
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: blackColor,
        backgroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.white,
      ),
      textTheme: darkTextTheme,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.5),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            elevation: MaterialStateProperty.all(6),
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.all(16),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(blackColor),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            overlayColor: MaterialStateProperty.all<Color>(blackColor2)),
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        foregroundColor: Colors.white,
      )),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
        selectionColor: Colors.grey,
        selectionHandleColor: blackColor,
      ),
      indicatorColor: blackColor,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Colors.white,
      ),
    );
  }
}
