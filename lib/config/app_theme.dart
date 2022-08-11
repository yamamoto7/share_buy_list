import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  // tmp
  static const Color colorTMPDark = Color(0xFF2A383D);
  static const Color colorTMPlight = Color(0xFF4E626B);
  // #6F97B1

  // Basic App Theme
  static const Color background = Color(0xFFF2F2F2);
  static const Color mainColorDark = Color(0xFF2A383D);
  static const Color subColorDark = Color(0xFF2A383D);
  static const Color mainColorLight = Color(0xFFF2F2F2);
  static const Color subColorLight = Color(0xFFF2F2F2);

  // Text Color
  static const Color textDark = Color(0xFF2A383D);
  static const Color textLight = Color(0xFF4E626B);
  static const Color textExLight = Color.fromARGB(255, 149, 161, 167);
  static const Color textLightGray = Color.fromARGB(255, 178, 183, 185);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Tab Color
  static const Color tabItemColor = Color(0xFF3A5160);

  // Color For Card
  static const Color cardBgColor = Color(0xFF3A5160);
  static const Color cardWhiteBgColor = Colors.transparent;
  static const Color cardWhiteBorderColor = Color.fromARGB(255, 149, 152, 154);
  static const Color goodsCardActiveBgColor = Colors.transparent;
  static const Color goodsCardActiveBorderColor =
      Color.fromARGB(255, 149, 152, 154);
  static const Color goodsCardActiveButtonColor = Color(0xFF3A5160);
  static const Color goodsCardDisableBgColor = Colors.transparent;
  static const Color goodsCardDisableBorderColor = Colors.transparent;
  static const Color goodsCardDisableButtonColor =
      Color.fromARGB(255, 149, 152, 154);
  static const Color addButtonBgColor = Color(0xFF2A383D);

  // Color For Form
  static const Color formBorderColor = Color(0xFF3A5160);

  // Color For Button
  static const Color buttonCancelBorder = Color.fromARGB(255, 165, 39, 17);
  static const Color buttonEditBorder = Color.fromARGB(255, 18, 90, 138);

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
    fontSize: 14,
    letterSpacing: -0.05,
    color: textDark,
  );

  static const TextStyle cardTextDarkSmaller = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: -0.05,
    color: textDark,
  );

  static const TextStyle cardTextDarkH1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: textDark,
  );

  static const TextStyle cardTextWhite = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.05,
    color: textWhite,
  );

  static const TextStyle cardTextWhiteSmaller = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: -0.05,
    color: textWhite,
  );

  static const TextStyle cardTextWhiteH1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    letterSpacing: 1,
    color: textWhite,
  );

  static const TextStyle goodsCardActiveTitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: textDark,
  );

  static const TextStyle goodsCardActiveText = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.05,
    color: textLight,
  );

  static const TextStyle goodsCardActiveDate = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 1,
    color: textExLight,
  );

  static const TextStyle goodsCardDisableTitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: textExLight,
  );

  static const TextStyle goodsCardDisableText = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.05,
    color: textExLight,
  );

  static const TextStyle goodsCardDisableDate = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 1,
    color: textLightGray,
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
