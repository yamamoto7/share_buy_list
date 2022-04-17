// ignore_for_file: prefer_int_literals

// import 'package:share_buy_list/ui_view/edit_todo_item_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:share_buy_list/config/app_theme.dart';
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

  @override
  Widget build(BuildContext context) {
    return getSlidableCard(context, widget.goodsItemData);
  }

  Widget getSlidableCard(BuildContext context, GoodsItemData goodsItemData) {
    final isDir = widget.goodsItemData.isDirectory;
    return Slidable(
      key: ValueKey(widget.goodsItemData.id),
      endActionPane: const ActionPane(
        motion: ScrollMotion(),
        children: [
          Text('hoge'),
          Text('fuga'),
        ],
      ),
      child: isDir
          ? todoDirCard(context, goodsItemData)
          : todoItemCard(context, goodsItemData),
    );
  }

  Widget todoDirCard(BuildContext context, GoodsItemData goodsItemData) {
    return GestureDetector(
        onTap: () {
          widget.changeCurrentGoodsItem(goodsItemData);
        },
        child: SizedBox(
            child: Stack(children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Container(
                  decoration: const BoxDecoration(
                    color: AppTheme.cardBgColor,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 20, bottom: 20),
                  child: Row(children: <Widget>[
                    const SizedBox(width: 20),
                    Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          Text(goodsItemData.title,
                              textAlign: TextAlign.center,
                              style: AppTheme.cardTextWhite),
                          Container(
                              child: (goodsItemData.description.isNotEmpty)
                                  ? Text(goodsItemData.description,
                                      textAlign: TextAlign.left,
                                      style: AppTheme.cardTextWhite)
                                  : const SizedBox(height: 0))
                        ])),
                    const Icon(Icons.navigate_next_outlined,
                        color: AppTheme.background)
                  ])))
        ])));
  }

  Widget todoItemCard(BuildContext context, GoodsItemData goodsItemData) {
    return SizedBox(
      child: Stack(children: <Widget>[
        Container(
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            // 背景色（ボーダーの色）
            decoration: BoxDecoration(
                border: (goodsItemData.isFinished)
                    ? Border.all(color: AppTheme.cardWhiteBgColor)
                    : Border.all(color: AppTheme.cardWhiteBorderColor),
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
                            decoration: const BoxDecoration(
                              color: AppTheme.background,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            padding: const EdgeInsets.only(
                                top: 6, bottom: 20, left: 16, right: 16),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    // 丸ボタン
                                    padding: const EdgeInsets.only(
                                        top: 18, right: 8, bottom: 2),
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        border: (goodsItemData.isFinished)
                                            ? Border.all(
                                                color: AppTheme.colorTMPlight)
                                            : Border.all(
                                                color: AppTheme.colorTMPDark),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        // 丸ボタン
                                        padding: const EdgeInsets.all(2),
                                        child: (goodsItemData.isFinished)
                                            ? Container(
                                                height: 16,
                                                width: 16,
                                                decoration: const BoxDecoration(
                                                  color: AppTheme.colorTMPDark,
                                                  //角丸にする
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(
                                                height: 16,
                                                width: 16,
                                              ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                        Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                                '更新: ${goodsItemData.updatedAt} by ${goodsItemData.updatedBy}',
                                                textAlign: TextAlign.right,
                                                style: (goodsItemData
                                                        .isFinished)
                                                    ? AppTheme.cardTextDark
                                                    : AppTheme.cardTextWhite)),
                                        Text(goodsItemData.title,
                                            textAlign: TextAlign.left,
                                            style: (goodsItemData.isFinished)
                                                ? AppTheme.cardTextWhite
                                                : AppTheme.cardTextDark),
                                        Container(
                                            child: (goodsItemData
                                                    .description.isNotEmpty)
                                                ? Text(
                                                    goodsItemData.description,
                                                    textAlign: TextAlign.left,
                                                    style: (goodsItemData
                                                            .isFinished)
                                                        ? AppTheme.cardTextWhite
                                                        : AppTheme.cardTextDark)
                                                : const SizedBox(height: 0))
                                      ]))
                                ])));
                  });
            }))
      ]),
    );
  }
}
