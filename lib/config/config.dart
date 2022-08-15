import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageItem {
  LanguageItem(
      int indexVal, String codeVal, String labelVal, Locale localeValue) {
    index = indexVal;
    code = codeVal;
    label = labelVal;
    locale = localeValue;
  }

  late int index;
  late String code;
  late String label;
  late Locale locale;

  int getIndex() {
    return index;
  }

  String getCode() {
    return code;
  }

  String getLabel() {
    return label;
  }

  Locale getLocale() {
    return locale;
  }
}

class Config {
  static final Map<String, LanguageItem> languageItems = {
    'en': LanguageItem(0, 'en', 'English', const Locale('en')),
    'ja': LanguageItem(1, 'ja', '日本語', const Locale('ja'))
  };
  static final Map<int, String> languageKeys = {0: 'en', 1: 'ja'};

  void init() {}

  static late SharedPreferences prefs;
  static late bool darkmode;
  static late ThemeMode themeMode;
  static late LanguageItem currentLanguageItem;

  static Future<void> hoge() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('darkmode') != null &&
        prefs.getBool('darkmode') == true) {
      darkmode = true;
    } else {
      darkmode = false;
    }

    if (darkmode) {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }

    if (prefs.getString('languageCode') != null &&
        languageItems.containsKey(prefs.getString('languageCode'))) {
      currentLanguageItem = languageItems[prefs.getString('languageCode')]!;
    } else {
      currentLanguageItem = languageItems['en']!;
    }
  }

  static Locale getLanguageLocale() {
    return currentLanguageItem.getLocale();
  }

  static String getLanguageKey() {
    return currentLanguageItem.getCode();
  }

  static String getLanguageLabel() {
    return currentLanguageItem.getLabel();
  }

  static bool setLanguage(String languageCode) {
    if (languageItems.containsKey(languageCode)) {
      prefs.setString('languageCode', languageCode);
      currentLanguageItem = languageItems[prefs.getString('languageCode')]!;
    } else {
      return false;
    }
    return true;
  }

  static bool setDarkMode(bool value) {
    prefs.setBool('darkmode', value);
    darkmode = value;
    if (value) {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }

    return true;
  }
}
