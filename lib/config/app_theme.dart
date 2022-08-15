import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

const String fontName = 'NotoSansJP';

class AppStyle {
  AppStyle(String themeName) {}

  final Color _primeColor = const Color(0xFF2A383D); // prime;
  final Color _backgroundColor = const Color(0xFFF2F2F2);
  final Color _editColor = const Color.fromARGB(255, 15, 59, 89);
  final Color _errorColor = const Color.fromARGB(255, 165, 39, 17);
  final Color _textColor = Colors.black87;
  final Color _textReversedColor = Colors.white;
  final Color _shadowColor = Colors.grey;
  final Color _disableColor = const Color.fromARGB(255, 149, 161, 167);

  final Color _primeColorDark =
      const Color.fromARGB(255, 220, 227, 228); // prime;
  final Color _backgroundColorDark = const Color(0xFF181821);
  final Color _editColorDark = const Color.fromARGB(255, 39, 108, 155);
  final Color _errorColorDark = const Color.fromARGB(255, 201, 67, 43);
  final Color _textColorDark = const Color.fromARGB(221, 240, 240, 240);
  final Color _textReversedColorDark = const Color.fromARGB(255, 40, 46, 54);
  final Color _shadowColorDark = const Color.fromARGB(255, 75, 75, 75);
  final Color _disableColorDark = const Color.fromARGB(255, 75, 83, 86);

  final fontWeightDefault = FontWeight.w500;

  late ThemeData themeData = getThemeData(
      Brightness.light,
      _primeColor,
      _backgroundColor,
      _editColor,
      _errorColor,
      _textColor,
      _textReversedColor,
      _shadowColor,
      _disableColor);

  late ThemeData themeDataDark = getThemeData(
      Brightness.dark,
      _primeColorDark,
      _backgroundColorDark,
      _editColorDark,
      _errorColorDark,
      _textColorDark,
      _textReversedColorDark,
      _shadowColorDark,
      _disableColorDark);
}

ThemeData getThemeData(
        Brightness brightness,
        Color primeColor,
        Color backgroundColor,
        Color editColor,
        Color errorColor,
        Color textColor,
        Color textReversedColor,
        Color shadowColor,
        Color disableColor) =>
    ThemeData(
      brightness: brightness,
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: primeColor,
        barBackgroundColor: backgroundColor,
        scaffoldBackgroundColor: backgroundColor,
        textTheme: CupertinoTextThemeData(
          primaryColor: primeColor,
          textStyle: TextStyle(color: textColor),
        ),
      ),
      /*
      ## Colors ##
       - primaryColor メインカラー
       - primaryColorLight 反転色
       - shadowColor 影の色
       - scaffoldBackgroundColor
       - bottomAppBarColor
       - cardColor
       - hintColor 青
       - disabledColor 無効時の色 薄いグレー
       - backgroundColor 背景色
       - errorColor 赤
     */
      primaryColor: primeColor,
      primaryColorLight: textReversedColor,
      shadowColor: shadowColor,
      scaffoldBackgroundColor: backgroundColor,
      bottomAppBarColor: textReversedColor,
      disabledColor: disableColor,
      backgroundColor: backgroundColor,
      hintColor: editColor,
      errorColor: errorColor,
      /*
      ## Font ##
     */
      fontFamily: 'NotoSansJP',
      textTheme: TextTheme(
        /* 
        ## Texts ##
         - Display Large // x
         - Display Medium // グループカードタイトル
         - Display Small // x
         - Headline Large // カードタイトル
         - Headline Medium // カード説明文
         - Headline Small // x
         - Title Large // x
         - Title Medium // モーダル内見出し
         - Title Small // x
         - Label Large // タブラベル
         - Label Medium // ボタンテキスト
         - Label Small // x
         - Body Large // x
         - Body Medium // 通常テキスト
         - Body Small // 注釈
       */
        displayMedium: TextStyle(
          fontFamily: fontName,
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: -0.05,
          color: textColor,
        ),
        headlineLarge: TextStyle(
          fontFamily: fontName,
          fontWeight: FontWeight.w500,
          fontSize: 16,
          letterSpacing: -0.05,
          color: textColor,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontName,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: -0.05,
          color: textColor,
        ),
        titleMedium: TextStyle(
          fontFamily: fontName,
          fontWeight: FontWeight.w500,
          fontSize: 16,
          letterSpacing: -0.05,
          color: textColor,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontName,
          fontWeight: FontWeight.w500,
          fontSize: 16,
          letterSpacing: -0.05,
          color: textColor,
        ),
        bodySmall: TextStyle(
          /* 注釈 */
          fontFamily: fontName,
          fontWeight: FontWeight.w500,
          fontSize: 12,
          letterSpacing: -0.05,
          color: textColor,
        ),
      ),
      /*
      ## Others ##
     */
      iconTheme: IconThemeData(color: primeColor),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: backgroundColor,
        titleTextStyle: TextStyle(
          fontFamily: fontName,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: -0.05,
          color: textColor,
        ),
        iconTheme: IconThemeData(color: textColor),
        toolbarHeight: 50,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            textStyle: TextStyle(color: textReversedColor), primary: editColor),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            textStyle: TextStyle(color: primeColor), primary: primeColor),
      ),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: primeColor,
        labelColor: textReversedColor,
        indicator: RectangularIndicator(
          color: primeColor,
          topLeftRadius: 16,
          topRightRadius: 16,
          bottomLeftRadius: 16,
          bottomRightRadius: 16,
        ),
      ),
    );

TextField getInputForm(
    BuildContext context, TextEditingController controller, String label) {
  return TextField(
      controller: controller,
      cursorColor: Theme.of(context).primaryColor,
      keyboardType: TextInputType.text,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ));
}

TextField getInputArea(
    BuildContext context, TextEditingController controller, String label) {
  return TextField(
      controller: controller,
      cursorColor: Theme.of(context).primaryColor,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ));
}
