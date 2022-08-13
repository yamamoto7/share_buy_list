import 'package:flutter/material.dart';
import 'package:share_buy_list/config/app_theme.dart';
import 'package:share_buy_list/model/goods_group_data.dart';
import 'package:share_buy_list/view/components/loading.dart';
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
            color: AppTheme.background,
            border: Border.all(color: AppTheme.cardWhiteBorderColor),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(children: <Widget>[
            Expanded(
                child: Column(children: <Widget>[
              Text(goodsGroupData.title,
                  textAlign: TextAlign.left, style: AppTheme.cardTextDarkH1),
              Text(goodsGroupData.description,
                  textAlign: TextAlign.left, style: AppTheme.cardTextDark),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                  width: double.infinity,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text('共有ユーザー',
                            textAlign: TextAlign.left,
                            style: AppTheme.cardTextDarkH1),
                        ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: goodsGroupData.users!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return SizedBox(
                                height: 18,
                                child: Text(
                                    '\u2022 ${goodsGroupData.users![index].name}',
                                    textAlign: TextAlign.left,
                                    style: AppTheme.cardTextDark),
                              );
                            })
                      ]))
            ])),
            const Icon(Icons.navigate_next_outlined,
                color: AppTheme.colorTMPDark)
          ]),
        ),
        Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            padding:
                const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
            child: EditGoodsGroupModal(
                goodsGroupData: goodsGroupData,
                setLoading: setLoading,
                onRefetch: onRefetch)),
      ]));
}
