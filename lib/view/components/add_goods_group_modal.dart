// [TODO] 未着手

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:share_buy_list/config/app_theme.dart';
import 'package:share_buy_list/config/size_config.dart';
import 'package:share_buy_list/config/user_config.dart';
import 'package:share_buy_list/service/graphql_handler.dart';
import 'package:share_buy_list/view/components/bottom_half_modal.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class AddGoodsGroupModal extends StatefulWidget {
  const AddGoodsGroupModal({Key? key, required this.setLoading, this.onRefetch})
      : super(key: key);
  final Function setLoading;
  final VoidCallback? onRefetch;

  @override
  _AddGoodsGroupModalState createState() => _AddGoodsGroupModalState();
}

class _AddGoodsGroupModalState extends State<AddGoodsGroupModal>
    with TickerProviderStateMixin {
  final List<Widget> _selectItems = [
    const Tab(text: '新規作成'),
    const Tab(text: 'リストに参加')
  ];
  TabController? _tabController;

  late TextEditingController _todoTitleController;
  late TextEditingController _todoDescController;
  late List<Widget> _modalWidgetList;
  late List<Widget> _modalWidgetListJoinList;
  @override
  void initState() {
    _todoTitleController = TextEditingController(text: '');
    _todoDescController = TextEditingController(text: '');

    // TabControllerの初期化
    _tabController = TabController(length: _selectItems.length, vsync: this);
    _modalWidgetList = getModalWidgetList(context);
    _modalWidgetListJoinList = getModalWidgetListJoinList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomHalfModal(
        contents: Expanded(
            child: Column(
          children: [
            SizedBox(
                width: SizeConfig.safeBlockHorizontal * 80,
                height: 40,
                child: TabBar(
                    controller: _tabController,
                    indicatorColor: AppTheme.colorTMPDark,
                    tabs: _selectItems,
                    labelColor: AppTheme.background,
                    unselectedLabelColor: AppTheme.colorTMPDark,
                    indicator: RectangularIndicator(
                      color: AppTheme.colorTMPDark,
                      topLeftRadius: 16,
                      topRightRadius: 16,
                      bottomLeftRadius: 16,
                      bottomRightRadius: 16,
                    ),
                    onTap: (int index) {})),
            const SizedBox(height: 20),
            Expanded(
                child:
                    TabBarView(controller: _tabController, children: <Widget>[
              ListView.builder(
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: _modalWidgetList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        padding: EdgeInsets.only(
                            right: SizeConfig.safeBlockHorizontal * 10,
                            left: SizeConfig.safeBlockHorizontal * 10),
                        child: _modalWidgetList[index]);
                  }),
              ListView.builder(
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  itemCount: _modalWidgetListJoinList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        padding: EdgeInsets.only(
                            right: SizeConfig.safeBlockHorizontal * 10,
                            left: SizeConfig.safeBlockHorizontal * 10),
                        child: _modalWidgetListJoinList[index]);
                  })
            ])),
            const SizedBox(height: 40)
          ],
        )),
        child: addTodoGroupCard(context));
  }

  List<Widget> getModalWidgetListJoinList(BuildContext context) {
    return <Widget>[
      const SizedBox(height: 20),
      const Text('※ 他のユーザーが作成したリストに参加します。',
          textAlign: TextAlign.left, style: AppTheme.cardTextDarkSmaller),
      const Text('※ リストのIDを共有してもらい、以下入力してください。',
          textAlign: TextAlign.left, style: AppTheme.cardTextDarkSmaller),
      const SizedBox(height: 14),
      SizedBox(
        height: 50,
        // リスト追加ボタン
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              textStyle: const TextStyle(color: AppTheme.colorTMPDark),
              primary: AppTheme.colorTMPDark),
          onPressed: () {
            // Navigator.pop(context, 1);
            Navigator.of(context).pushReplacementNamed('/');
          },
          child: const Text('キャンセル'),
        ),
      ),
    ];
  }

  List<Widget> getModalWidgetList(BuildContext context) {
    return <Widget>[
      const SizedBox(height: 20),
      const Text('※ 名前は後から変更できます',
          textAlign: TextAlign.left, style: AppTheme.cardTextDarkSmaller),
      const Text('※ ユーザーの追加は作成後に行えます',
          textAlign: TextAlign.left, style: AppTheme.cardTextDarkSmaller),
      const SizedBox(height: 14),
      Container(child: AppTheme.getInputForm(_todoTitleController, 'リストの名前')),
      const SizedBox(height: 8),
      Container(child: AppTheme.getInputArea(_todoDescController, 'メモ')),
      const SizedBox(height: 20),
      Mutation<dynamic>(
        options: MutationOptions<dynamic>(
          document: gql(addGoodsGroupItem),
          update: (GraphQLDataProxy cache, QueryResult<dynamic>? result) =>
              cache,
          onCompleted: (dynamic resultData) {
            Navigator.of(context).pushReplacementNamed('/');
            widget.setLoading(false);
          },
        ),
        builder: (
          runMutation,
          result,
        ) {
          print(result);
          return SizedBox(
            height: 50,
            // リスト追加ボタン
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(color: AppTheme.white),
                  primary: AppTheme.colorTMPDark),
              onPressed: () {
                widget.setLoading(true);
                runMutation(<String, String>{
                  'title': _todoTitleController.text,
                  'description': _todoDescController.text,
                  'user_id': UserConfig.userID,
                });
                // Navigator.pop(context, 1);
              },
              child: const Text('作成'),
            ),
          );
        },
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 50,
        // リスト追加ボタン
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              textStyle: const TextStyle(color: AppTheme.colorTMPDark),
              primary: AppTheme.colorTMPDark),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
          child: const Text('キャンセル'),
        ),
      ),
    ];
  }

  Widget addTodoGroupCard(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        decoration: const BoxDecoration(
          color: AppTheme.addButtonBgColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: const Padding(
            padding: EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 32),
            child: Icon(Icons.add, size: 32, color: AppTheme.background)));
  }
}
