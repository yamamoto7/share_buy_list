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

  late TextEditingController _goodsGroupTitleController;
  late TextEditingController _goodsGroupDescController;
  late TextEditingController _goodsGroupGroupIDController;
  late List<Widget> _modalWidgetList;
  late List<Widget> _modalWidgetListAddUser;
  late String _copyButtonText;
  late List<Widget> _selectItems;

  @override
  void initState() {
    _goodsGroupTitleController =
        TextEditingController(text: widget.goodsGroupData.title);
    _goodsGroupDescController =
        TextEditingController(text: widget.goodsGroupData.description);
    _goodsGroupGroupIDController =
        TextEditingController(text: widget.goodsGroupData.id);

    // TabControllerの初期化
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _copyButtonText = L10n.of(context)!.copy;
    _selectItems = <Widget>[
      Tab(text: L10n.of(context)!.manageUsers),
      Tab(text: L10n.of(context)!.edit)
    ];
    _tabController = TabController(length: _selectItems.length, vsync: this);
    _modalWidgetList = getModalWidgetList(context, widget.goodsGroupData);
    _modalWidgetListAddUser =
        getModalWidgetListAddUser(context, widget.goodsGroupData);
    return BottomHalfModal(
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
        ])),
        child: editGoodsGroupButton(context));
  }

  List<Widget> getModalWidgetListAddUser(
      BuildContext context, GoodsGroupData goodsGroupData) {
    return <Widget>[
      RichText(
        text: TextSpan(
          children: [
            const WidgetSpan(child: Icon(Icons.people, size: 24)),
            const WidgetSpan(child: SizedBox(width: 4)),
            TextSpan(
                text: L10n.of(context)!.userList,
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
      const SizedBox(height: 12),
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
      const SizedBox(height: 18),
      RichText(
        text: TextSpan(
          children: [
            const WidgetSpan(child: Icon(Icons.person_add, size: 24)),
            const WidgetSpan(child: SizedBox(width: 4)),
            TextSpan(
                text: L10n.of(context)!.invite,
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Text(L10n.of(context)!.editGoodsGroupModalJoniUserNumLimit,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 12),
      Container(
          child: getInputForm(
              context, _goodsGroupGroupIDController, L10n.of(context)!.listId)),
      const SizedBox(height: 8),
      StatefulBuilder(
        builder: (BuildContext context, setState) => SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.copy),
            label: Text(_copyButtonText),
            onPressed: () {
              // Clipboard.setData(ClipboardData(text: _goodsGroupGroupIDController.text));
              // setState(() {});
              Clipboard.setData(
                      ClipboardData(text: _goodsGroupGroupIDController.text))
                  .then(
                (value) {
                  setState(() {
                    _copyButtonText = L10n.of(context)!.copied;
                  });
                },
              );
            },
          ),
        ),
      ),
      const SizedBox(height: 8),
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
              context, _goodsGroupTitleController, L10n.of(context)!.listName)),
      const SizedBox(height: 8),
      Container(
          child: getInputArea(
              context, _goodsGroupDescController, L10n.of(context)!.memo)),
      const SizedBox(height: 20),
      Mutation<dynamic>(
        options: MutationOptions<dynamic>(
          document: gql(updateGoodsGroup),
          fetchPolicy: FetchPolicy.cacheAndNetwork,
          cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
          update: (GraphQLDataProxy cache, result) {},
          onCompleted: (dynamic resultData) {
            Navigator.pop(context, 1);
            widget.onRefetch!();
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
                // runMutation({
                // 'title': _goodsGroupTitleController.text,
                // 'description': _goodsGroupDescController.text,
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
                    content: Text(L10n.of(context)!.areYouDelete),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        /// This parameter indicates this action is the default,
                        /// and turns the action's text to bold text.
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(L10n.of(context)!.cancel),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () async {
                          widget.setLoading(true);
                          Navigator.pop(context);
                          await graphQlObject.query(deleteGoodsGroup(
                              goodsGroupData.myUserGoodsItemID));
                          // print(result);
                          widget.setLoading(false);
                        },
                        child: Text(L10n.of(context)!.delete),
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
