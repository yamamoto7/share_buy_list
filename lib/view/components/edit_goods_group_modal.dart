import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:share_buy_list/config/app_theme.dart';
import 'package:share_buy_list/config/size_config.dart';
import 'package:share_buy_list/model/goods_group_data.dart';
import 'package:share_buy_list/service/graphql_handler.dart';
import 'package:share_buy_list/view/components/bottom_half_modal.dart';

class EditGoodsGroupModal extends StatefulWidget {
  const EditGoodsGroupModal(
      {Key? key,
      required this.goodsGroupData,
      required this.setLoading,
      this.onRefetch})
      : super(key: key);

  final GoodsGroupData goodsGroupData;
  final Function setLoading;
  final VoidCallback? onRefetch;

  @override
  _EditGoodsGroupModalState createState() => _EditGoodsGroupModalState();
}

class _EditGoodsGroupModalState extends State<EditGoodsGroupModal>
    with TickerProviderStateMixin {
  late TabController _tabController;

  late TextEditingController _todoTitleController;
  late TextEditingController _todoDescController;
  late TextEditingController _todoGroupIDController;
  late List<Widget> _modalWidgetList;
  late List<Widget> _modalWidgetListAddUser;
  late String _copyButtonText;

  @override
  void initState() {
    _copyButtonText = 'hoge';
    _todoTitleController =
        TextEditingController(text: widget.goodsGroupData.title);
    _todoDescController =
        TextEditingController(text: widget.goodsGroupData.description);
    _todoGroupIDController =
        TextEditingController(text: widget.goodsGroupData.id);

    // TabControllerの初期化
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _selectItems = <Widget>[
      Tab(text: L10n.of(context)!.manageUsers),
      Tab(text: L10n.of(context)!.edit)
    ];
    _tabController = TabController(length: _selectItems.length, vsync: this);
    _modalWidgetList = getModalWidgetList(context, widget.goodsGroupData);
    _modalWidgetListAddUser =
        getModalWidgetListAddUser(context, widget.goodsGroupData);
    return BottomHalfModal(
        child: editGoodsGroupButton(context),
        contents: Expanded(
            child: Column(children: [
          SizedBox(
              width: SizeConfig.safeBlockHorizontal * 80,
              height: 40,
              child: TabBar(
                  controller: _tabController,
                  tabs: _selectItems,
                  onTap: (int index) {})),
          const SizedBox(height: 20),
          Expanded(
              child: TabBarView(controller: _tabController, children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                itemCount: _modalWidgetListAddUser.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: EdgeInsets.only(
                          right: SizeConfig.safeBlockHorizontal * 10,
                          left: SizeConfig.safeBlockHorizontal * 10),
                      child: _modalWidgetListAddUser[index]);
                }),
            ListView.builder(
                shrinkWrap: true,
                itemCount: _modalWidgetList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: EdgeInsets.only(
                          right: SizeConfig.safeBlockHorizontal * 10,
                          left: SizeConfig.safeBlockHorizontal * 10),
                      child: _modalWidgetList[index]);
                })
          ]))
        ])));
  }

  List<Widget> getModalWidgetListAddUser(
      BuildContext context, GoodsGroupData goodsGroupData) {
    return <Widget>[
      Text(L10n.of(context)!.userList,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.titleMedium),
      ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: goodsGroupData.users!.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              child: Text('\u2022 ${goodsGroupData.users![index].name}',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyMedium),
            );
          }),
      Text(L10n.of(context)!.invite,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.titleMedium),
      Text(L10n.of(context)!.editGoodsGroupModalJoniUserNumLimit,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 12),
      Container(
          child: getInputForm(
              context, _todoGroupIDController, L10n.of(context)!.listId)),
      ElevatedButton.icon(
        icon: const Icon(Icons.copy),
        label: Text(_copyButtonText),
        onPressed: () {
          // Clipboard.setData(ClipboardData(text: _todoGroupIDController.text));
          // setState(() {});
          setState(() {
            _copyButtonText = 'fuga';
          });
          Clipboard.setData(ClipboardData(text: _todoGroupIDController.text))
              .then(
            (value) {
              setState(() {
                _copyButtonText = 'fuga';
              });
            },
          );
        },
      ),
      const SizedBox(height: 24),
      SizedBox(
        height: 50,
        // リスト追加ボタン
        child: OutlinedButton(
          onPressed: () {
            Navigator.pop(context, 1);
          },
          child: Text(L10n.of(context)!.close),
        ),
      ),
      const SizedBox(height: 120)
    ];
  }

  List<Widget> getModalWidgetList(
      BuildContext context, GoodsGroupData goodsGroupData) {
    return <Widget>[
      const SizedBox(height: 14),
      Container(
          child: getInputForm(
              context, _todoTitleController, L10n.of(context)!.listName)),
      const SizedBox(height: 8),
      Container(
          child: getInputArea(
              context, _todoDescController, L10n.of(context)!.memo)),
      const SizedBox(height: 20),
      Mutation<dynamic>(
        options: MutationOptions<dynamic>(
          document: gql(updateGoodsGroup),
          fetchPolicy: FetchPolicy.cacheAndNetwork,
          cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
          update: (GraphQLDataProxy cache, QueryResult? result) {
            return cache;
          },
          onCompleted: (dynamic resultData) {
            Navigator.pop(context, 1);
            widget.onRefetch!();
            widget.setLoading(false);
          },
        ),
        builder: (
          RunMutation runMutation,
          QueryResult? result,
        ) {
          return SizedBox(
            height: 50,
            // リスト追加ボタン
            child: ElevatedButton(
              onPressed: () {
                widget.setLoading(true);
                // runMutation({
                // 'title': _todoTitleController.text,
                // 'description': _todoDescController.text,
                // 'user_id': UserConfig.userID,
                // 'id': goodsGroupData.todo_item_id.toString()
                // });
              },
              child: Text(L10n.of(context)!.update),
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
            Navigator.pop(context, 1);
          },
          child: Text(L10n.of(context)!.cancel),
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
          height: 50,
          // リスト追加ボタン
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  textStyle: TextStyle(color: Theme.of(context).errorColor),
                  primary: Theme.of(context).errorColor,
                  side: BorderSide(
                      width: 1, color: Theme.of(context).errorColor)),
              onPressed: () async {
                Navigator.pop(context);
                await showCupertinoModalPopup<void>(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: const Text('Alert'),
                    content: const Text('Proceed with destructive action?'),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        /// This parameter indicates this action is the default,
                        /// and turns the action's text to bold text.
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('No'),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () async {
                          widget.setLoading(true);
                          Navigator.pop(context);
                          dynamic result = await graphQlObject.query(
                              deleteGoodsGroup(
                                  goodsGroupData.myUserGoodsItemID));
                          // print(result);
                          widget.setLoading(false);
                        },
                        child: const Text('Yes'),
                      )
                    ],
                  ),
                );
              },
              child: Text(L10n.of(context)!.delete))),
      const SizedBox(height: 120)
    ];
  }

  Widget editGoodsGroupButton(BuildContext context) {
    return Container(
        height: 64,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        padding:
            const EdgeInsets.only(top: 26, left: 16, right: 16, bottom: 16),
        child:
            Icon(Icons.more_vert_sharp, color: Theme.of(context).primaryColor));
  }
}
