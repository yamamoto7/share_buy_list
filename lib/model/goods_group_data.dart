import 'package:share_buy_list/model/goods_item_data.dart';
import 'package:share_buy_list/model/user_data.dart';
import 'package:share_buy_list/service/utils.dart';

class GoodsGroupData {
  GoodsGroupData(
      {this.id = '',
      this.title = '',
      this.description = '',
      required this.goodsItemId,
      this.goodsItem,
      this.users});

  factory GoodsGroupData.fromJson(dynamic parsedJson) {
    final users = castOrNull<List<User>>(parsedJson['user_goods_items']
        .map<User>((dynamic i) => User.fromJson(i?['user']))
        .toList());
    return GoodsGroupData(
        id: parsedJson['id'] as String,
        title: parsedJson['title'] as String,
        description: parsedJson['description'] as String,
        goodsItemId: parsedJson['goods_item_id'] as String,
        goodsItem: GoodsItemData.fromJson(parsedJson),
        users: users);
  }

  String id;
  String title;
  String description;
  String goodsItemId;
  GoodsItemData? goodsItem;
  List<User>? users;
}
