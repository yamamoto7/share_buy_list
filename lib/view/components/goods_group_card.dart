import 'package:flutter/material.dart';
import 'package:share_buy_list/model/goods_group_data.dart';
import 'package:share_buy_list/view/components/edit_goods_group_modal.dart';

Widget goodsGroupCard(BuildContext context, GoodsGroupData goodsGroupData,
    Function openGoodsItem, Function setLoading, VoidCallback? onRefetch) {
  return GestureDetector(
    onTap: () {
      openGoodsItem(goodsGroupData.goodsItem, 1);
    },
    child: Stack(children: [
      Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          padding:
              const EdgeInsets.only(top: 32, left: 32, right: 16, bottom: 32),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(children: <Widget>[
            Expanded(
                child: Column(children: <Widget>[
              Text(goodsGroupData.title,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.displayMedium),
              SizedBox(
                width: double.infinity,
                child: Text(goodsGroupData.description,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
              const SizedBox(
                height: 12,
              ),
            ])),
            Icon(Icons.navigate_next_outlined,
                color: Theme.of(context).primaryColor),
          ])),
      Align(
          alignment: Alignment.topLeft,
          child: EditGoodsGroupModal(
              goodsGroupData: goodsGroupData,
              setLoading: setLoading,
              onRefetch: onRefetch)),
    ]),
  );
}
