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
                  top: 12, right: 24, left: 24, bottom: 12),
              textStyle: AppTheme.bodyTextSmaller,
              primary: AppTheme.buttonEditBorder,
              side:
                  const BorderSide(width: 1, color: AppTheme.buttonEditBorder),
            ),
            onPressed: () async {
              pressEditButton();
              Navigator.pop(context, 1);
            },
            child: const Text('編集'),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.only(
                  top: 12, right: 24, left: 24, bottom: 12),
              textStyle: AppTheme.bodyTextSmaller,
              primary: AppTheme.buttonCancelBorder,
              side: const BorderSide(
                  width: 1, color: AppTheme.buttonCancelBorder),
            ),
            onPressed: () async {
              pressRemoveButton();
              Navigator.pop(context, 1);
            },
            child: const Text('削除'),
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
            decoration: const BoxDecoration(
              color: AppTheme.cardBgColor,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
            ])));
  }

  Widget goodsItemCard(BuildContext context, GoodsItemData goodsItemData) {
    return Container(
        margin: const EdgeInsets.only(top: 4, bottom: 4),
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        // 背景色（ボーダーの色）
        decoration: BoxDecoration(
            border: (goodsItemData.isFinished)
                ? Border.all(color: AppTheme.goodsCardDisableBorderColor)
                : Border.all(color: AppTheme.goodsCardActiveBorderColor),
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
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        padding: const EdgeInsets.only(
                            top: 6, bottom: 6, left: 16, right: 16),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              statusButton(goodsItemData.isFinished),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                    Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                            'updated ${goodsItemData.updatedAt}',
                                            textAlign: TextAlign.right,
                                            style: (goodsItemData.isFinished)
                                                ? AppTheme.goodsCardDisableDate
                                                : AppTheme
                                                    .goodsCardActiveDate)),
                                    Text(goodsItemData.title,
                                        textAlign: TextAlign.left,
                                        style: (goodsItemData.isFinished)
                                            ? AppTheme.goodsCardDisableTitle
                                            : AppTheme.goodsCardActiveTitle),
                                    Container(
                                        child: (goodsItemData
                                                .description.isNotEmpty)
                                            ? Text(goodsItemData.description,
                                                textAlign: TextAlign.left,
                                                style: (goodsItemData
                                                        .isFinished)
                                                    ? AppTheme
                                                        .goodsCardDisableText
                                                    : AppTheme
                                                        .goodsCardActiveText)
                                            : const SizedBox(height: 0)),
                                    Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                            'by ${goodsItemData.updatedBy}',
                                            textAlign: TextAlign.right,
                                            style: (goodsItemData.isFinished)
                                                ? AppTheme.goodsCardDisableDate
                                                : AppTheme
                                                    .goodsCardActiveDate)),
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
            ? Border.all(color: AppTheme.goodsCardDisableButtonColor)
            : Border.all(color: AppTheme.goodsCardActiveButtonColor),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: isFinished
          ? Container(
              margin: const EdgeInsets.all(2),
              height: 16,
              width: 16,
              decoration: const BoxDecoration(
                color: AppTheme.goodsCardDisableButtonColor,
                //角丸にする
                borderRadius: BorderRadius.all(
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
