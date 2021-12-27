import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const blackColor = Color(0xff1c1c1c);
const lightGreyColor = Color(0xffeeeeee);

class AppTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.exo2(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: blackColor,
    ),
    bodyText2: GoogleFonts.exo2(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.grey,
    ),
    headline1: GoogleFonts.exo2(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: blackColor,
    ),
    headline2: GoogleFonts.exo2(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: blackColor,
    ),
    headline3: GoogleFonts.exo2(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: blackColor,
    ),
    headline6: GoogleFonts.exo2(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: blackColor,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyText1: GoogleFonts.exo2(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodyText2: GoogleFonts.exo2(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.grey,
    ),
    headline1: GoogleFonts.exo2(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headline2: GoogleFonts.exo2(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headline3: GoogleFonts.exo2(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headline6: GoogleFonts.exo2(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  static ThemeData light() {
    return ThemeData(
      primaryColor: Colors.white,
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
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: blackColor),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
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
        primary: blackColor,
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
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(6),
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.all(16),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(blackColor),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            overlayColor: MaterialStateProperty.all<Color>(Colors.black)),
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        primary: Colors.white,
      )),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
        selectionColor: Colors.grey,
        selectionHandleColor: blackColor,
      ),
      indicatorColor: Colors.white,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Colors.white,
      ),
    );
  }
}
