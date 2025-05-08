import 'package:flutter/material.dart';

// This is a custom theme for the Donezo app
// It defines the colors and text styles used throughout the app
// It also provides a way to access the custom colors and styles in the app
class CustomColors {
  // This is a class that defines the custom colors used in the app
  // It uses the Color class to create colors using RGB values
  static const Color ourYellow = Color.fromRGBO(248, 198, 49, 1);
  static const Color lightPurple = Color.fromRGBO(151, 71, 255, 1);
  static const Color ourGrey = Color.fromRGBO(217, 217, 217, 1);
  static const Color ourWhite = Color.fromRGBO(255, 255, 255, 1);
  static const Color lilac = Color.fromRGBO(186, 131, 222, 1);
  static const Color lighterGrey = Color.fromRGBO(237, 237, 237, 1);
}

ThemeData appTheme = ThemeData(
  // This is the main theme data for the app
  // It defines the primary color, font family, color scheme, and text theme

  fontFamily: 'Baloo',
  colorScheme: const ColorScheme.light(
    primary: Color.fromRGBO(70, 30, 85, 1),
    secondary: Color.fromRGBO(230, 78, 109, 1),
    brightness: Brightness.light,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w200,
    ),
  ),
);

extension CustomTheme on ThemeData {
  // This is an extension on the ThemeData class
  // It provides a way to access the custom colors and styles in the app
  Color get ourGrey => CustomColors.ourGrey;
  Color get ourYellow => CustomColors.ourYellow;
  Color get ourWhite => CustomColors.ourWhite;
  Color get lightPurple => CustomColors.lightPurple;
  Color get lilac => CustomColors.lilac;
  Color get lighterGrey => CustomColors.lighterGrey;
}
