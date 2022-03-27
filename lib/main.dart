import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_buy_list/config/app_theme.dart';
import 'package:share_buy_list/config/user_config.dart';
import 'package:share_buy_list/model/user_data.dart';
import 'package:share_buy_list/service/graphql_handler.dart';
import 'package:share_buy_list/service/utils.dart';
import 'package:share_buy_list/view/home.dart';

// ignore: avoid_void_async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  final user = await initUser();
  UserConfig().init(user);

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

Future<User> initUser() async {
  final box = await Hive.openBox<dynamic>('config');
  final userName = castOrNull<String>(box.get('user_name'));
  final userId = castOrNull<String>(box.get('user_id'));
  User? user;
  if (userId is String && userName is String) {
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
      // QueryResult seedQueryResult =
      // await graphQlObject.query(insertSeedData(user.id));
    } catch (e) {
      return User();
    }
  }
  return user;
}
