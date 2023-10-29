import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomLightTheme {
  static const Color primaryGradientStart = Colors.cyan;
  static const Color primaryGradientEnd = Colors.greenAccent;

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: primaryGradientStart,
    primaryColorDark: primaryGradientEnd,
    iconTheme: const IconThemeData(color: primaryGradientStart),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: primaryGradientStart),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryGradientStart,
      textTheme: ButtonTextTheme.primary,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryGradientStart,
      selectionColor: primaryGradientStart.withOpacity(0.5),
      selectionHandleColor: primaryGradientStart,
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
        .copyWith(secondary: primaryGradientStart),
  );
}
