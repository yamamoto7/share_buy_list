import 'package:share_buy_list/model/goods_item_data.dart';
import 'package:share_buy_list/model/user_data.dart';
import 'package:share_buy_list/service/utils.dart';

class GoodsGroupData {
  GoodsGroupData(
      {this.id = '',
      this.userGoodsItemID = '',
      required this.goodsItem,
      this.users});

  factory GoodsGroupData.fromJson(dynamic parsedJson, String userGodosItemID) {
    final users = castOrNull<List<User>>(parsedJson['user_goods_items']
        .map<User>((dynamic i) => User.fromJson(i?['user']))
        .toList());
    return GoodsGroupData(
        id: parsedJson['id'] as String,
        userGoodsItemID: userGodosItemID,
        goodsItem: GoodsItemData.fromJson(parsedJson),
        users: users);
  }

  String id;
  String userGoodsItemID;
  GoodsItemData goodsItem;
  List<User>? users;
}
