import 'package:flutter/material.dart';
import 'package:share_buy_list/config/app_theme.dart';
import 'package:share_buy_list/config/size_config.dart';
import 'package:share_buy_list/model/goods_group_data.dart';

Widget GoodsGroupCard(BuildContext context, GoodsGroupData goodsGroupData,
    VoidCallback? onRefetch) {
  return GestureDetector(
      onTap: () {
        // widget.openTodoItem(todoGroupData.todo_item);
        print('hoge');
      },
      child: SizedBox(
          // height: 80,
          width: SizeConfig.safeBlockHorizontal * 90,
          child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Padding(
                  // 中身（背景は白）
                  padding: EdgeInsets.all(1),
                  child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.cardBgColor,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 32, right: 16, bottom: 32),
                          child: Column(children: <Widget>[
                            Row(children: <Widget>[
                              Expanded(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(goodsGroupData.description,
                                          textAlign: TextAlign.left,
                                          style: AppTheme.cardTextWhite),
                                    ])),
                            SizedBox(
                              height: 12,
                            ),
                            SizedBox(
                                width: double.infinity,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("共有ユーザー",
                                          textAlign: TextAlign.left,
                                          style: AppTheme.cardTextWhiteH1),
                                      ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              goodsGroupData.users!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              height: 18,
                                              child: Text(
                                                  "\u2022 " +
                                                      goodsGroupData
                                                          .users![index].name,
                                                  textAlign: TextAlign.left,
                                                  style:
                                                      AppTheme.cardTextWhite),
                                            );
                                          })
                                    ]))
                          ])))))));
}
