import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:share_buy_list/config/app_theme.dart';
import 'package:share_buy_list/config/env.dart';
import 'package:share_buy_list/config/user_config.dart';
import 'package:share_buy_list/model/goods_group_data.dart';
import 'package:share_buy_list/service/graphql_handler.dart';
import 'package:share_buy_list/service/utils.dart';
import 'package:share_buy_list/view/components/add_goods_group_modal.dart';
import 'package:share_buy_list/view/components/goods_group_card.dart';
import 'package:share_buy_list/view/components/loading.dart';

class ShowGoodsGroupItemsScreen extends StatefulWidget {
  const ShowGoodsGroupItemsScreen({Key? key, required this.setLoading})
      : super(key: key);

  final Function setLoading;

  @override
  _ShowGoodsGroupItemsScreenState createState() =>
      _ShowGoodsGroupItemsScreenState();
}

class _ShowGoodsGroupItemsScreenState extends State<ShowGoodsGroupItemsScreen> {
  List<GoodsGroupData> goodsGroupList = <GoodsGroupData>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.background,
        body: Stack(children: <Widget>[getGroupCardList()]));
  }

  Widget getGroupCardList() {
    return Query<dynamic>(
        options: QueryOptions<dynamic>(
            document: gql(fetchUserGoodsItems(UserConfig.userID)),
            fetchPolicy: FetchPolicy.noCache),
        builder: (QueryResult<dynamic> result,
            {VoidCallback? refetch, FetchMore<dynamic>? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if (result.isLoading) {
            return const Center(child: ColorLoader(radius: 15, dotRadius: 3));
          }

          if (result.data is! Map<String, dynamic> &&
              !result.data!.containsKey('user_goods_item')) {
            return const Center(child: ColorLoader(radius: 15, dotRadius: 3));
          }

          goodsGroupList = castOrNull<List<GoodsGroupData>>(result
              .data!['user_goods_item']
              .map<GoodsGroupData>(
                  (dynamic i) => GoodsGroupData.fromJson(i?['goods_item']))
              .toList())!;

          return Scrollbar(
              child: ListView.builder(
                  padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top +
                        24,
                    bottom: 62 + MediaQuery.of(context).padding.bottom,
                    left: 16,
                    right: 16,
                  ),
                  itemCount: goodsGroupList.length + 1,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == goodsGroupList.length) {
                      if (goodsGroupList.length < MAX_GOODS_GROUP_NUM) {
                        return AddGoodsGroupModal(
                            setLoading: widget.setLoading, onRefetch: refetch);
                      } else {
                        return const Text(
                            '※ 大変申し訳ございませんが、現在一人のユーザーが参加できるリストを最大$MAX_GOODS_GROUP_NUM個に制限しています。\n※ ご意見・ご要望は Setting > 「お問い合わせ・ご要望」 から随時受け付けています。',
                            textAlign: TextAlign.left,
                            style: AppTheme.bodyTextSmaller);
                      }
                    } else {
                      return goodsGroupCard(
                          context, goodsGroupList[index], refetch);
                    }
                  }));
        });
  }
}
