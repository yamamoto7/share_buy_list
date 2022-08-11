import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static const languageJa = 'ja';
  static const languageEn = 'en';

  void init() {}

  static late bool isFirstAccess;
  static late SharedPreferences prefs;
  static late bool darkmode;
  static late ThemeMode themeMode;

  static Future<void> hoge() async {
    prefs = await SharedPreferences.getInstance();

    var isFirstAccess = prefs.getBool('isFirstAccess') ?? true;
    if (isFirstAccess) {
      isFirstAccess = true;
      await prefs.setBool('isFirstAccess', false);
    }

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
  }

  static Locale getLanguageCode() {
    return (prefs.getString('key') != null && prefs.getString('key')! == 'ja')
        ? const Locale('ja')
        : const Locale('en');
  }

  static String getLanguageKey() {
    return (prefs.getString('key') != null && prefs.getString('key')! == 'ja')
        ? 'ja'
        : 'en';
  }

  static String getLanguageLabel() {
    return (prefs.getString('key') != null && prefs.getString('key')! == 'ja')
        ? '日本語'
        : 'English';
  }

  static bool getIsFirstAccess() {
    return isFirstAccess;
  }

  static bool setLanguage(String key) {
    if (key == languageJa) {
      prefs.setString('key', languageJa);
    } else if (key == languageEn) {
      prefs.setString('key', languageEn);
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
