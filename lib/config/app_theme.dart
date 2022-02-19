import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Basic App Theme
  static const Color background = Color(0xFFF2F2F2);

  // Text Color
  static const Color textDark = Color(0xFF2A383D);
  static const Color textLight = Color(0xFF4E626B);

  // Color Utils
  static const Color white = Color(0xFFFFFFFF);

  // App Body Text Theme
  static const String fontName = 'Roboto';
  static const TextTheme textTheme = TextTheme(
    bodyText1: body1,
    bodyText2: body2,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: textDark,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: textDark,
  );
}
