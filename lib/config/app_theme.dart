import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

const String fontName = 'NotoSansJP';

class AppStyle {
  AppStyle(String themeName) {}

  final Map<int, String> themeNames = {0: 'default'};

  Color _primeColor = Color(0xFF2A383D); // prime;
  Color _backgroundColor = Color(0xFFF2F2F2);
  Color _accentColor = Color(0xFF2A383D);
  Color _editColor = Color.fromARGB(255, 18, 90, 138);
  Color _errorColor = Color.fromARGB(255, 165, 39, 17);

  Color _primeColorDark = Color(0xFF2A383D); // prime;
  Color _backgroundColorDark = Color(0xFF181821);
  Color _accentColorDark = Color(0xFF424280);
  Color _editColorDark = Color.fromARGB(255, 18, 90, 138);
  Color _errorColorDark = Color.fromARGB(255, 165, 39, 17);

  final fontWeightDefault = FontWeight.w500;

  late ThemeData themeDataDark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    bottomAppBarColor: _backgroundColorDark,
    scaffoldBackgroundColor: _backgroundColorDark,
    backgroundColor: _backgroundColorDark,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontFamily: fontName,
        fontWeight: FontWeight.w700,
        fontSize: 16,
        letterSpacing: -0.05,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontName,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        letterSpacing: -0.05,
        color: Colors.white,
      ),
      bodySmall: TextStyle(
        fontFamily: fontName,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        letterSpacing: -0.05,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          textStyle: TextStyle(color: _backgroundColorDark),
          primary: _accentColorDark),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
          textStyle: TextStyle(color: Colors.white), primary: Colors.white),
    ),
  );
  late ThemeData themeData = ThemeData(
    cupertinoOverrideTheme: CupertinoThemeData(
      primaryColor: _primeColor,
      barBackgroundColor: _backgroundColor,
      scaffoldBackgroundColor: _backgroundColor,
    ),
    brightness: Brightness.light,
    /*
      ## Colors ##
       - accentColor アクセントカラー
       - primaryColor メインカラー
       - primaryColorLight 反転色
       - shadowColor 影の色
       - scaffoldBackgroundColor
       - bottomAppBarColor
       - cardColor
       - hintColor グレー
       - disabledColor 無効時の色 薄いグレー
       - backgroundColor 背景色
       - errorColor 赤
     */
    // Color? accentColor,
    primaryColor: _primeColor,
    primaryColorLight: Colors.white,
    shadowColor: Colors.grey,
    scaffoldBackgroundColor: _backgroundColor,
    bottomAppBarColor: Colors.white,
    cardColor: _accentColor,
    disabledColor: const Color.fromARGB(255, 149, 161, 167),
    backgroundColor: _backgroundColor,
    errorColor: _errorColorDark,
    /*
      ## Font ##
     */
    fontFamily: 'NotoSansJP',
    textTheme: const TextTheme(
      /* 
        ## Texts ##
         - Display Large // x
         - Display Medium // グループカードタイトル
         - Display Small // x
         - Headline Large // カードタイトル
         - Headline Medium // カード説明文
         - Headline Small // x
         - Title Large // x
         - Title Medium // x
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
        color: Colors.black87,
      ),
      headlineLarge: TextStyle(
        fontFamily: fontName,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        letterSpacing: -0.05,
        color: Colors.black87,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontName,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: -0.05,
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontName,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        letterSpacing: -0.05,
        color: Colors.black87,
      ),
      bodySmall: TextStyle(
        /* 注釈 */
        fontFamily: fontName,
        fontWeight: FontWeight.w500,
        fontSize: 12,
        letterSpacing: -0.05,
        color: Colors.black87,
      ),
      titleMedium: TextStyle(
        fontFamily: fontName,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        letterSpacing: -0.05,
        color: Colors.black87,
      ),
    ),
    /*
      ## Others ##
     */
    iconTheme: IconThemeData(color: _primeColor),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: _backgroundColor,
      titleTextStyle: const TextStyle(
        fontFamily: fontName,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: -0.05,
        color: Colors.black87,
      ),
      iconTheme: const IconThemeData(color: Colors.black87),
      toolbarHeight: 50,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(color: Colors.white),
          primary: _primeColor),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
          textStyle: TextStyle(color: _primeColor), primary: _primeColor),
    ),
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: _primeColor,
      labelColor: Colors.white,
      indicator: RectangularIndicator(
        color: _primeColor,
        topLeftRadius: 16,
        topRightRadius: 16,
        bottomLeftRadius: 16,
        bottomRightRadius: 16,
      ),
    ),
  );
}

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
