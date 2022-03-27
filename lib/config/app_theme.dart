import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  // tmp
  static const Color colorTMPDark = Color(0xFF2A383D);
  static const Color colorTMPlight = Color(0xFF4E626B);

  // Basic App Theme
  static const Color background = Color(0xFFF2F2F2);
  static const Color mainColorDark = Color(0xFFF2F2F2);
  static const Color subColorDark = Color(0xFFF2F2F2);
  static const Color mainColorLight = Color(0xFFF2F2F2);
  static const Color subColorLight = Color(0xFFF2F2F2);

  // Text Color
  static const Color textDark = Color(0xFF2A383D);
  static const Color textLight = Color(0xFF4E626B);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Tab Color
  static const Color tabItemColor = Color(0xFF3A5160);

  // Color For Card
  static const Color cardBgColor = Color(0xFF2A383D);
  static const Color addButtonBgColor = Color(0xFF2A383D);

  // Color For Form
  static const Color formBorderColor = Color(0xFF3A5160);

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

  static const TextStyle bodyTextSmaller = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: textDark,
  );

  // Text Style For Card
  static const TextStyle cardTextDark = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: textWhite,
  );

  // Text Style For Card
  static const TextStyle cardTextDarkSmaller = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: textWhite,
  );

  static const TextStyle cardTextDarkH1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: textWhite,
  );

  static const TextStyle cardTextWhite = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: textWhite,
  );

  static const TextStyle cardTextWhiteSmaller = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: textWhite,
  );

  static const TextStyle cardTextWhiteH1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: textWhite,
  );

  static TextField getInputForm(
      TextEditingController controller, String label) {
    return TextField(
        controller: controller,
        cursorColor: formBorderColor,
        keyboardType: TextInputType.text,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          // filled: true,
          // fillColor: AppTheme.inputFormBg,
          labelText: label,
          labelStyle: const TextStyle(color: formBorderColor),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: formBorderColor),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: formBorderColor),
          ),
        ));
  }

  static TextField getInputArea(
      TextEditingController controller, String label) {
    return TextField(
        controller: controller,
        cursorColor: formBorderColor,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          // filled: true,
          // fillColor: AppTheme.inputFormBg,
          labelText: label,
          labelStyle: const TextStyle(color: formBorderColor),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: formBorderColor),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: formBorderColor),
          ),
        ));
  }
}
