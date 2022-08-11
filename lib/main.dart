import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:share_buy_list/config/app_theme.dart';
import 'package:share_buy_list/config/config.dart';
import 'package:share_buy_list/config/user_config.dart';
import 'package:share_buy_list/data/seed_for_init.dart';
import 'package:share_buy_list/model/user_data.dart';
import 'package:share_buy_list/service/graphql_handler.dart';
import 'package:share_buy_list/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: avoid_void_async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  final prefs = await SharedPreferences.getInstance();
  final user = await initUser(prefs);
  UserConfig().init(user);
  await Config.hoge();
  //[FIXME: delete] print(Directory.systemTemp.path);

  await SystemChrome.setPreferredOrientations(
          <DeviceOrientation>[DeviceOrientation.portraitUp])
      .then((_) => runApp(GraphQLProvider(
            client: graphQlObject.client,
            child: const CacheProvider(child: StartWidget()),
          )));
}

class StartWidget extends StatefulWidget {
  const StartWidget({Key? key}) : super(key: key);

  @override
  State<StartWidget> createState() => _StartWidgetState();
}

class _StartWidgetState extends State<StartWidget> {
  @override
  void initState() {
    super.initState();
  }

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
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blueGrey,
          textTheme: AppTheme.textTheme),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: Config.themeMode,
      /* ThemeMode.system to follow system theme, 
         ThemeMode.light for light theme, 
         ThemeMode.dark for dark theme
      */
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) =>
            const AppHomeScreen(isFirstAccess: false, tab: 0),
        '/config': (BuildContext context) =>
            const AppHomeScreen(isFirstAccess: false, tab: 1),
        '/web': (BuildContext context) => const WebView(initialUrl: ''),
      },
      localizationsDelegates: const [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Config.getLanguageCode(),
      supportedLocales: L10n.supportedLocales,
    );
  }
}

Future<User> initUser(SharedPreferences prefs) async {
  final userName = prefs.getString('user_name') ?? '';
  final userId = prefs.getString('user_id') ?? '';

  User? user;
  if (userId.isNotEmpty) {
    user = User(id: userId, name: userName);
  } else {
    try {
      final dynamic queryResult = await graphQlObject
          .query(addNewUser('User${math.Random().nextInt(10000)}', 1));
      user = User(
          id: queryResult.data!['insert_user']['returning'][0]['id'].toString(),
          iconId: int.parse(queryResult.data!['insert_user']['returning'][0]
                  ['icon_id']
              .toString()),
          name: queryResult.data!['insert_user']['returning'][0]['name']
              .toString());
      prefs.setString('user_name', user.name).toString();
      prefs.setString('user_id', user.id).toString();
      final dynamic seedQueryResult =
          await graphQlObject.query(seedQueryForInit(user.id));
      print(seedQueryResult);
      print(user);
    } catch (e) {
      return User();
    }
  }
  return user;
}
