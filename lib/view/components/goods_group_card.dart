import 'package:flutter/material.dart';
import 'package:share_buy_list/config/app_theme.dart';
import 'package:share_buy_list/model/goods_group_data.dart';

Widget goodsGroupCard(BuildContext context, GoodsGroupData goodsGroupData,
    VoidCallback? onRefetch) {
  return GestureDetector(
      onTap: () {
        // widget.openTodoItem(todoGroupData.todo_item);
        print('hoge');
      },
      child: Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          decoration: const BoxDecoration(
            color: AppTheme.cardBgColor,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Padding(
              padding: const EdgeInsets.only(
                  top: 16, left: 32, right: 16, bottom: 32),
              child: Column(children: <Widget>[
                Row(children: <Widget>[
                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        Text(goodsGroupData.title,
                            textAlign: TextAlign.left,
                            style: AppTheme.cardTextWhiteH1),
                      ])),
                  // EditTodoGroupModal(
                  // todoGroupData: todoGroupData,
                  // setLoading: widget.setLoading,
                  // onRefetch: onRefetch)
                ]),
                SizedBox(
                    width: double.infinity,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(goodsGroupData.description,
                              textAlign: TextAlign.left,
                              style: AppTheme.cardTextWhite),
                        ])),
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
                              style: AppTheme.cardTextWhiteH1),
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
                                      style: AppTheme.cardTextWhite),
                                );
                              })
                        ]))
              ]))));
}
