// ignore_for_file: prefer_int_literals

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:share_buy_list/model/goods_item_data.dart';

class GoodsItemView extends StatefulWidget {
  const GoodsItemView({
    Key? key,
    required this.goodsItemData,
    required this.changeCurrentGoodsItem,
    required this.removeGoodsItem,
    required this.toggleGoodsItem,
  }) : super(key: key);

  final GoodsItemData goodsItemData;
  final Function changeCurrentGoodsItem;
  final Function removeGoodsItem;
  final Function toggleGoodsItem;

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

  Future<void> pressEditButton() async {
    Navigator.pop(context, 1);
  }

  Future<void> pressRemoveButton(GoodsItemData goodsItemData) async {
    await widget.removeGoodsItem(goodsItemData);
  }

  @override
  Widget build(BuildContext context) {
    return getSlidableCard(context, widget.goodsItemData);
  }

  Widget getSlidableCard(BuildContext context, GoodsItemData goodsItemData) {
    final isDir = widget.goodsItemData.isDirectory;
    return isDir
        ? goodsDirCard(context, goodsItemData)
        : goodsItemCard(context, goodsItemData);
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
          return GestureDetector(
              onTap: () async {
                await widget.toggleGoodsItem(goodsItemData);
              },
              child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                  padding: const EdgeInsets.only(
                      top: 12, bottom: 12, left: 16, right: 16),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        statusButton(goodsItemData.isFinished),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  child: (goodsItemData.description.isNotEmpty)
                                      ? Text(goodsItemData.description,
                                          textAlign: TextAlign.left,
                                          style: (goodsItemData.isFinished)
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium!
                                                  .apply(
                                                      color: Theme.of(context)
                                                          .disabledColor)
                                              : Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium)
                                      : const SizedBox(height: 2)),
                            ]))
                      ])));
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
