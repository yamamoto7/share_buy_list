import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:share_buy_list/model/goods_group_data.dart';
import 'package:share_buy_list/service/graphql_handler.dart';
import 'package:share_buy_list/config/env.dart';
import 'package:share_buy_list/config/app_theme.dart';
import 'package:share_buy_list/config/user_config.dart';
import 'package:share_buy_list/view/components/goods_group_card.dart';
import 'package:share_buy_list/view/components/loading.dart';

class ShowGoodsGroupItemsScreen extends StatefulWidget {
  const ShowGoodsGroupItemsScreen({Key? key, required Function this.setLoading})
      : super(key: key);

  final Function setLoading;

  @override
  _ShowGoodsGroupItemsScreenState createState() =>
      _ShowGoodsGroupItemsScreenState();
}

class _ShowGoodsGroupItemsScreenState extends State<ShowGoodsGroupItemsScreen> {
  List<GoodsGroupData> goodsGroupDataList = <GoodsGroupData>[];

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
    return Query(
        options:
            QueryOptions(document: gql(fetchUserGoodsItems(UserConfig.userID))),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if (result.isLoading) {
            return Center(child: ColorLoader(radius: 15.0, dotRadius: 3));
          }
          return Text('Fetch succeed');
        });
  }
}
