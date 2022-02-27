import 'package:flutter/material.dart';
import 'package:share_buy_list/model/user_data.dart';

class UserConfig {
  static late String userID;
  static late String name;

  void init(User receivedUser) {
    userID = receivedUser.id;
    name = receivedUser.name;
  }
}
