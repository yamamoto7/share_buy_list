class User {
  User({this.id = '', this.name = '', this.iconId = 1});
  factory User.fromJson(dynamic parsedJson) {
    if (parsedJson == null) {
      return User();
    }
    return User(
      id: parsedJson['id'] as String,
      name: parsedJson['name'] as String,
      iconId: parsedJson['icon_id'] as int,
    );
  }

  String id;
  String name;
  int iconId;

  Map<dynamic, dynamic> toJson() {
    return <dynamic, dynamic>{'id': id, 'name': name, 'icon_id': iconId};
  }
}
