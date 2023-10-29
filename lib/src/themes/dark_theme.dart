import 'package:flutter/material.dart';

class CustomDarkTheme {
  static final Color darkGradientStart = Colors.cyan.shade800;
  static final Color darkGradientEnd = Colors.greenAccent.shade700;
  static const Color darkThemeSelectedColor = Color(0xFF64ffda);

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkGradientStart,
    primaryColorLight: darkGradientStart,
    primaryColorDark: darkGradientEnd,
    colorScheme: ThemeData.dark().colorScheme.copyWith(
      secondary: darkThemeSelectedColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(16)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            return darkGradientStart;
          },
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 2,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
      backgroundColor: darkGradientStart,
      actionsIconTheme: const IconThemeData(
        color: Colors.white70,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: darkThemeSelectedColor,
      selectionColor: darkThemeSelectedColor.withOpacity(0.5),
      selectionHandleColor: darkThemeSelectedColor,
    ),
  );
}
