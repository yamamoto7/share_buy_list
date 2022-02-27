import 'package:hive/hive.dart';

class User {
  String id;
  String name;
  int iconId;

  User({this.id = '', this.name = '', this.iconId = 1});

  factory User.fromJson(Map<dynamic, dynamic>? parsedJson) {
    if (parsedJson is Null) {
      return User();
    }
    return User(
      id: parsedJson['id'],
      name: parsedJson['name'],
      iconId: parsedJson['icon_id'],
    );
  }

  Map<dynamic, dynamic> toJson() {
    return <dynamic, dynamic>{'id': id, 'name': name, 'icon_id': iconId};
  }
}
