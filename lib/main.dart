import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_buy_list/config/app_theme.dart';
import 'package:share_buy_list/view/home.dart';

void main() {
  runApp(const StartWidget());
}

class StartWidget extends StatelessWidget {
  const StartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'Share Buy List',
      debugShowCheckedModeBanner: true,
      theme:
          ThemeData(primarySwatch: Colors.blue, textTheme: AppTheme.textTheme),
      initialRoute: '/',
      home: const AppHomeScreen(),
    );
  }
}
