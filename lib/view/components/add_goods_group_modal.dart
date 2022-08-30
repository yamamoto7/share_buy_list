import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:share_buy_list/config/app_theme.dart';
import 'package:share_buy_list/config/size_config.dart';
import 'package:share_buy_list/config/user_config.dart';
import 'package:share_buy_list/service/graphql_handler.dart';
import 'package:share_buy_list/view/components/bottom_half_modal.dart';

class AddGoodsGroupModal extends StatefulWidget {
  const AddGoodsGroupModal({Key? key, required this.setLoading})
      : super(key: key);
  final Function setLoading;

  @override
  _AddGoodsGroupModalState createState() => _AddGoodsGroupModalState();
}

class _AddGoodsGroupModalState extends State<AddGoodsGroupModal>
    with TickerProviderStateMixin {
  late List<Widget> _selectItems;
  TabController? _tabController;

  late TextEditingController _todoTitleController;
  late TextEditingController _todoDescController;
  late List<Widget> _modalWidgetList;
  late List<Widget> _modalWidgetListJoinList;

  @override
  void initState() {
    _todoTitleController = TextEditingController(text: '');
    _todoDescController = TextEditingController(text: '');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectItems = [
      Tab(text: L10n.of(context)!.createNew),
      Tab(text: L10n.of(context)!.join),
    ];

    // TabControllerの初期化
    _tabController = TabController(length: _selectItems.length, vsync: this);
    _modalWidgetList = getModalWidgetList(context);
    _modalWidgetListJoinList = getModalWidgetListJoinList(context);
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
                    tabs: _selectItems,
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
      Text(L10n.of(context)!.textJoinList,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodySmall),
      Text(L10n.of(context)!.textGetID,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 14),
      SizedBox(
        height: 50,
        // リスト追加ボタン
        child: OutlinedButton(
          onPressed: () {
            // Navigator.pop(context, 1);
            Navigator.of(context).pop();
          },
          child: Text(L10n.of(context)!.cancel),
        ),
      ),
    ];
  }

  List<Widget> getModalWidgetList(BuildContext context) {
    return <Widget>[
      const SizedBox(height: 20),
      Text(L10n.of(context)!.textNameChange,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodySmall),
      Text(L10n.of(context)!.textAddUser,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 14),
      Container(
          child: getInputForm(context, _todoTitleController,
              L10n.of(context)!.listName, false)),
      const SizedBox(height: 8),
      Container(
          child: getInputArea(context, _todoDescController,
              L10n.of(context)!.description, false)),
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
          return SizedBox(
            height: 50,
            // リスト追加ボタン
            child: ElevatedButton(
              onPressed: () {
                widget.setLoading(true);
                runMutation(<String, String>{
                  'title': _todoTitleController.text,
                  'description': _todoDescController.text,
                  'user_id': UserConfig.userID,
                });
                // Navigator.pop(context, 1);
              },
              child: Text(L10n.of(context)!.create),
            ),
          );
        },
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 50,
        // リスト追加ボタン
        child: OutlinedButton(
          onPressed: () {
            // Navigator.of(context).pushReplacementNamed('/');
            Navigator.of(context).pop();
          },
          child: Text(L10n.of(context)!.cancel),
        ),
      ),
    ];
  }

  Widget addTodoGroupCard(BuildContext context) {
    return Container(
        width: SizeConfig.safeBlockHorizontal * 94,
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: Padding(
            padding:
                const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 32),
            child: Icon(Icons.add,
                size: 32, color: Theme.of(context).primaryColorLight)));
  }
}
