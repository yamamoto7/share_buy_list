import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_buy_list/config/app_theme.dart';
import 'package:share_buy_list/config/user_config.dart';
import 'package:share_buy_list/data/seed_for_init.dart';
import 'package:share_buy_list/model/user_data.dart';
import 'package:share_buy_list/service/graphql_handler.dart';
import 'package:share_buy_list/view/home.dart';

// ignore: avoid_void_async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  final box = await Hive.openBox<dynamic>('config');
  final user = await initUser(box);
  await initSeed(box, user.id);
  UserConfig().init(user);
  print(Directory.systemTemp.path);

  await SystemChrome.setPreferredOrientations(
          <DeviceOrientation>[DeviceOrientation.portraitUp])
      .then((_) => runApp(GraphQLProvider(
            client: graphQlObject.client,
            child: const CacheProvider(child: StartWidget()),
          )));
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

Future<User> initUser(dynamic box) async {
  final userName = box.get('user_name').toString();
  final dynamic userIdRaw = box.get('user_id');
  final userId = (userIdRaw == null) ? '' : userIdRaw.toString();

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
      await box.put('user_id', user.id);
      await box.put('user_name', user.name);
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

Future<bool> initSeed(dynamic box, String userId) async {
  final seedVersion = box.get('seed_version').toString();
  if (seedVersion.isEmpty && userId.isNotEmpty) {
    try {
      final dynamic seedQueryResult =
          await graphQlObject.query(seedQueryForInit(userId));
      await box.put('seed_version', 1);
      print(seedQueryResult);
    } catch (e) {
      return false;
    }
  }
  return true;
}
