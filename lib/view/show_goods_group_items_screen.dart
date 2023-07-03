import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:share_buy_list/config/env.dart';
import 'package:share_buy_list/config/user_config.dart';
import 'package:share_buy_list/model/goods_group_data.dart';
import 'package:share_buy_list/service/graphql_handler.dart';
import 'package:share_buy_list/service/utils.dart';
import 'package:share_buy_list/view/components/add_goods_group_modal.dart';
import 'package:share_buy_list/view/components/goods_group_card.dart';
import 'package:share_buy_list/view/components/loading.dart';

class ShowGoodsGroupItemsScreen extends StatefulWidget {
  const ShowGoodsGroupItemsScreen(
      {Key? key, required this.setLoading, required this.openGoodsItem})
      : super(key: key);

  final Function setLoading;
  final Function openGoodsItem;

  @override
  _ShowGoodsGroupItemsScreenState createState() =>
      _ShowGoodsGroupItemsScreenState();
}

class _ShowGoodsGroupItemsScreenState extends State<ShowGoodsGroupItemsScreen> {
  List<GoodsGroupData> goodsGroupList = <GoodsGroupData>[];

  @override
  void initState() {
    print(widget.key);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getGroupCardList());
  }

  Widget getGroupCardList() {
    return Stack(children: <Widget>[
      Query<dynamic>(
          options: QueryOptions<dynamic>(
              document: gql(fetchUserGoodsItems(UserConfig.userID)),
              fetchPolicy: FetchPolicy.cacheAndNetwork,
              cacheRereadPolicy: CacheRereadPolicy.ignoreOptimisitic),
          builder: (QueryResult<dynamic> result,
              {VoidCallback? refetch, FetchMore<dynamic>? fetchMore}) {
            Widget childWidget;
            final listPadding = EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
              left: 16,
              right: 16,
            );

            if (result.hasException) {
              // Error occured
              print('ERROR');
              print(result.exception);
              childWidget = ListView(padding: listPadding, children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.only(
                        top: 12, right: 16, left: 16, bottom: 12),
                    primary: Theme.of(context).errorColor,
                    side: BorderSide(
                        width: 1, color: Theme.of(context).errorColor),
                  ),
                  onPressed: () async {},
                  child: Text(
                    L10n.of(context)!.showGoodsGroupItemsScreenFetchError,
                  ),
                ),
              ]);
            } else if (result.isLoading) {
              // Now loading
              childWidget =
                  const Center(child: ColorLoader(radius: 15, dotRadius: 3));
            } else if (result.data is! Map<String, dynamic> &&
                !result.data!.containsKey('user_goods_item')) {
              childWidget =
                  const Center(child: ColorLoader(radius: 15, dotRadius: 3));
            } else {
              goodsGroupList = castOrNull<List<GoodsGroupData>>(result
                  .data!['user_goods_item']
                  .map<GoodsGroupData>((dynamic i) => GoodsGroupData.fromJson(
                      i?['goods_item'], i?['id'] as String))
                  .toList())!;

              childWidget = ListView.builder(
                  padding: listPadding,
                  itemCount: goodsGroupList.length + 1,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == goodsGroupList.length) {
                      if (goodsGroupList.length < MAX_GOODS_GROUP_NUM) {
                        return AddGoodsGroupModal(
                            setLoading: widget.setLoading);
                      } else {
                        return Text(
                            L10n.of(context)!
                                .showGoodsGroupItemsScreenGroupNumLimit,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodySmall);
                      }
                    } else {
                      return goodsGroupCard(context, goodsGroupList[index],
                          widget.openGoodsItem, widget.setLoading, refetch);
                    }
                  });
            }

            return Scrollbar(
                child: RefreshIndicator(
                    onRefresh: () async {
                      refetch!();
                    },
                    child: childWidget));
          })
    ]);
  }
}
