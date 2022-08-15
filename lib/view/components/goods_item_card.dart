// ignore_for_file: prefer_int_literals

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:share_buy_list/model/goods_item_data.dart';
import 'package:share_buy_list/service/graphql_handler.dart';

class GoodsItemView extends StatefulWidget {
  const GoodsItemView(
      {Key? key,
      required this.goodsItemData,
      required this.changeCurrentGoodsItem})
      : super(key: key);

  final GoodsItemData goodsItemData;
  final Function changeCurrentGoodsItem;

  @override
  _GoodsItemViewState createState() => _GoodsItemViewState();
}

class _GoodsItemViewState extends State<GoodsItemView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    // 初期設定
    super.initState();
  }

  void pressEditButton() {
    print(1);
  }

  void pressRemoveButton() {
    print(1);
  }

  @override
  Widget build(BuildContext context) {
    return getSlidableCard(context, widget.goodsItemData);
  }

  Widget getSlidableCard(BuildContext context, GoodsItemData goodsItemData) {
    final isDir = widget.goodsItemData.isDirectory;
    return Slidable(
      key: ValueKey(widget.goodsItemData.id),
      closeOnScroll: false,
      endActionPane: ActionPane(
        dismissible: DismissiblePane(onDismissed: () {}),
        dragDismissible: false,
        motion: const ScrollMotion(),
        children: <Widget>[
          const SizedBox(width: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.only(
                  top: 12, right: 16, left: 16, bottom: 12),
              primary: Theme.of(context).primaryColor,
              side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
            ),
            onPressed: () async {
              pressEditButton();
              Navigator.pop(context, 1);
            },
            child: Text(L10n.of(context)!.edit),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.only(
                  top: 12, right: 16, left: 16, bottom: 12),
              primary: Theme.of(context).errorColor,
              side: BorderSide(width: 1, color: Theme.of(context).errorColor),
            ),
            onPressed: () async {
              pressRemoveButton();
              Navigator.pop(context, 1);
            },
            child: Text(L10n.of(context)!.delete),
          )
        ],
      ),
      child: isDir
          ? goodsDirCard(context, goodsItemData)
          : goodsItemCard(context, goodsItemData),
    );
  }

  Widget goodsDirCard(BuildContext context, GoodsItemData goodsItemData) {
    return GestureDetector(
        onTap: () {
          widget.changeCurrentGoodsItem(goodsItemData);
        },
        child: Container(
            margin: const EdgeInsets.only(top: 4, bottom: 4),
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Row(children: <Widget>[
              const SizedBox(width: 20),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    Text(goodsItemData.title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .apply(color: Theme.of(context).primaryColorLight)),
                    Container(
                        child: (goodsItemData.description.isNotEmpty)
                            ? Text(goodsItemData.description,
                                textAlign: TextAlign.left,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .apply(
                                        color: Theme.of(context)
                                            .primaryColorLight))
                            : const SizedBox(height: 0))
                  ])),
              Icon(Icons.navigate_next_outlined,
                  color: Theme.of(context).primaryColorLight)
            ])));
  }

  Widget goodsItemCard(BuildContext context, GoodsItemData goodsItemData) {
    return Container(
        margin: const EdgeInsets.only(top: 4, bottom: 4),
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        // 背景色（ボーダーの色）
        decoration: BoxDecoration(
            border: (goodsItemData.isFinished)
                ? Border.all(color: Theme.of(context).backgroundColor)
                : Border.all(color: Theme.of(context).primaryColor),
            borderRadius: const BorderRadius.all(Radius.circular(8.0))),
        child: Builder(builder: (context) {
          return Mutation<Widget>(
              options: MutationOptions(
                document: gql(updateGoodsItem),
                update: (GraphQLDataProxy cache, result) {},
                onCompleted: (dynamic resultData) {},
              ),
              builder: (runMutation, result) {
                return GestureDetector(
                    onTap: () {
                      if (goodsItemData.isFinished == true) {
                        runMutation(<String, dynamic>{
                          'id': goodsItemData.id,
                          'is_finished': false
                        });
                        setState(() {
                          goodsItemData.isFinished = false;
                        });
                      } else if (goodsItemData.isFinished == false) {
                        runMutation(<String, dynamic>{
                          'id': goodsItemData.id,
                          'is_finished': true
                        });
                        setState(() {
                          goodsItemData.isFinished = true;
                        });
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                        ),
                        padding: const EdgeInsets.only(
                            top: 12, bottom: 12, left: 16, right: 16),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              statusButton(goodsItemData.isFinished),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                    Text(goodsItemData.title,
                                        textAlign: TextAlign.left,
                                        style: (goodsItemData.isFinished)
                                            ? Theme.of(context)
                                                .textTheme
                                                .headlineLarge!
                                                .apply(
                                                    color: Theme.of(context)
                                                        .disabledColor)
                                            : Theme.of(context)
                                                .textTheme
                                                .headlineLarge),
                                    Container(
                                        child: (goodsItemData
                                                .description.isNotEmpty)
                                            ? Text(goodsItemData.description,
                                                textAlign: TextAlign.left,
                                                style: (goodsItemData
                                                        .isFinished)
                                                    ? Theme.of(context)
                                                        .textTheme
                                                        .headlineMedium!
                                                        .apply(
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor)
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .headlineMedium)
                                            : const SizedBox(height: 2)),
                                  ]))
                            ])));
              });
        }));
  }

  Widget statusButton(bool isFinished) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        border: isFinished
            ? Border.all(color: Theme.of(context).disabledColor)
            : Border.all(color: Theme.of(context).primaryColor),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: isFinished
          ? Container(
              margin: const EdgeInsets.all(2),
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor,
                //角丸にする
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            )
          : const SizedBox(
              height: 16,
              width: 16,
            ),
    );
  }
}
