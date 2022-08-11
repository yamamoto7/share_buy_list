import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:share_buy_list/model/goods_item_data.dart';
import 'package:share_buy_list/service/graphql_handler.dart';
import 'package:share_buy_list/view/components/goods_item_card.dart';
import 'package:share_buy_list/view/components/loading.dart';

class GoodsItemsView extends StatefulWidget {
  const GoodsItemsView(
      {Key? key,
      required this.goodsItem,
      required this.changeCurrentGoodsItem,
      required this.setAddableTodoItem})
      : super(key: key);

  final GoodsItemData goodsItem;
  final Function changeCurrentGoodsItem;
  final Function setAddableTodoItem;
  @override
  _GoodsItemsViewState createState() => _GoodsItemsViewState();
}

class _GoodsItemsViewState extends State<GoodsItemsView>
    with TickerProviderStateMixin {
  late GoodsItemData _goodsItem;
  @override
  void initState() {
    // 初期設定
    _goodsItem = widget.goodsItem;
    super.initState();
  }

  @override
  void dispose() {
    // 終了設定（初期設定の逆）
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Subscription<Widget>(
        options: SubscriptionOptions(
          fetchPolicy: FetchPolicy.cacheAndNetwork,
          document: gql(fetchGoodsItems(_goodsItem.id)),
        ),
        onSubscriptionResult: (subscriptionResult, client) {},
        builder: (result) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if (result.isLoading || result.data == null) {
            return const Center(child: ColorLoader(radius: 15, dotRadius: 3));
          }
          final goodsItemDataList = List<GoodsItemData>.from(result
              .data!['goods_item']
              .map<GoodsItemData>(GoodsItemData.fromJson)
              .toList() as List<GoodsItemData>);

          // if (true) {
          if (goodsItemDataList.isEmpty) {
            return const Text('hoge');
          } else {
            return Scrollbar(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 0, right: 16, left: 16),
                    itemCount: goodsItemDataList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return GoodsItemView(
                          goodsItemData: goodsItemDataList[index],
                          changeCurrentGoodsItem:
                              widget.changeCurrentGoodsItem);
                    }));
          }
        });
  }

  QueryResult<Widget> newMethod(QueryResult<Widget> result) => result;
}
