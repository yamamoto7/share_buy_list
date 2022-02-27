import 'package:share_buy_list/model/goods_item_data.dart';
import 'package:share_buy_list/model/user_data.dart';
import 'package:hive/hive.dart';

class GoodsGroupData {
  String id;
  String title;
  String description;
  BigInt goodsItemId;
  BigInt userGoodsGroupId;
  GoodsItemData? goodsItem;
  List<User>? users;

  GoodsGroupData(
      {this.id = '',
      this.title = '',
      this.description = '',
      required this.goodsItemId,
      required this.userGoodsGroupId,
      this.goodsItem,
      this.users});

  factory GoodsGroupData.fromJson(Map<dynamic, dynamic>? parsedJson) {
    if (parsedJson is Null) {
      return GoodsGroupData(
          goodsItemId: BigInt.from(-1), userGoodsGroupId: BigInt.from(-1));
    }
    List<User> users = parsedJson['user_goods_groups']
        .map<User>((i) => User.fromJson(i?["user"]))
        .toList();
    return GoodsGroupData(
        id: parsedJson['id'],
        title: parsedJson['goods_item']['title'],
        description: parsedJson['goods_item']['description'],
        goodsItemId: BigInt.from(parsedJson['goods_item_id']),
        userGoodsGroupId: BigInt.from(parsedJson['user_goods_groups'][0]['id']),
        goodsItem: GoodsItemData.fromJson(parsedJson['goods_item']),
        users: users);
  }
}
