import 'package:share_buy_list/config/app_theme.dart';
import 'package:share_buy_list/config/size_config.dart';
import 'package:share_buy_list/config/user_config.dart';
import 'package:share_buy_list/model/goods_group_data.dart';
import 'package:share_buy_list/service/graphql_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
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
  final List<Widget> _selectItems = [
    const Tab(text: '招待ID'),
    const Tab(text: '編集')
  ];
  TabController? _tabController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  ValueNotifier<int>? _currentIndex1 = ValueNotifier<int>(0);
  TextEditingController? _todoTitleController;
  TextEditingController? _todoDescController;
  TextEditingController? _todoGroupIDController;
  List<Widget>? _modalWidgetList;
  List<Widget>? _modalWidgetListAddUser;

  @override
  void initState() {
    _todoTitleController =
        TextEditingController(text: widget.goodsGroupData.title);
    _todoDescController =
        TextEditingController(text: widget.goodsGroupData.description);
    _todoGroupIDController =
        TextEditingController(text: widget.goodsGroupData.id);

    // TabControllerの初期化
    _tabController = TabController(length: _selectItems.length, vsync: this);
    _modalWidgetList = getModalWidgetList(context, widget.goodsGroupData);
    _modalWidgetListAddUser =
        getModalWidgetListAddUser(context, widget.goodsGroupData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
    final focusNode = FocusNode();

    return BottomHalfModal(
        child: editGoodsGroupButton(context),
        contents: Expanded(
            child: Column(children: [
          SizedBox(
              width: SizeConfig.safeBlockHorizontal * 80,
              height: 40,
              child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.green,
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
              child: TabBarView(controller: _tabController, children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                itemCount: _modalWidgetListAddUser!.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: EdgeInsets.only(
                          right: SizeConfig.safeBlockHorizontal * 10,
                          left: SizeConfig.safeBlockHorizontal * 10),
                      child: _modalWidgetListAddUser![index]);
                }),
            ListView.builder(
                shrinkWrap: true,
                itemCount: _modalWidgetList!.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: EdgeInsets.only(
                          right: SizeConfig.safeBlockHorizontal * 10,
                          left: SizeConfig.safeBlockHorizontal * 10),
                      child: _modalWidgetList![index]);
                })
          ]))
        ])));
  }

  bool clipboardCopied = false;
  List<Widget> getModalWidgetListAddUser(
      BuildContext context, GoodsGroupData goodsGroupData) {
    return <Widget>[
      const Text('※ リストに参加できるユーザーは最大5名です',
          textAlign: TextAlign.left, style: AppTheme.textStyleTmp),
      const SizedBox(height: 12),
      Container(child: AppTheme.getInputForm(_todoGroupIDController!, 'リストID')),
      Container(
        child: clipboardCopied
            ? RaisedButton.icon(
                icon: const Icon(Icons.done),
                label: const Text('コピーしました'),
                onPressed: () {
                  Clipboard.setData(
                      ClipboardData(text: _todoGroupIDController!.text));
                  setState(() {
                    clipboardCopied = true;
                  });
                },
              )
            : RaisedButton.icon(
                icon: const Icon(Icons.copy),
                label: const Text('タップでコピー'),
                onPressed: () {
                  // Clipboard.setData(ClipboardData(text: _todoGroupIDController!.text));
                  Clipboard.setData(
                      ClipboardData(text: _todoGroupIDController!.text));
                  setState(() {
                    clipboardCopied = true;
                  });
                },
              ),
      ),
      const SizedBox(height: 24),
      SizedBox(
        height: 50,
        // リスト追加ボタン
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
              textStyle: const TextStyle(color: AppTheme.colorTMPDark),
              primary: AppTheme.colorTMPDark),
          onPressed: () {
            Navigator.pop(context, 1);
          },
          child: const Text('閉じる'),
        ),
      ),
      const SizedBox(height: 120)
    ];
  }

  List<Widget> getModalWidgetList(
      BuildContext context, GoodsGroupData goodsGroupData) {
    return <Widget>[
      const Text('リストの編集',
          textAlign: TextAlign.left, style: AppTheme.textStyleTmp),
      const SizedBox(height: 14),
      Container(child: AppTheme.getInputForm(_todoTitleController!, 'リストの名前')),
      const SizedBox(height: 8),
      Container(child: AppTheme.getInputArea(_todoDescController!, 'メモ')),
      const SizedBox(height: 20),
      Mutation<dynamic>(
        options: MutationOptions<dynamic>(
          document: gql(updateGoodsGroup),
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
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(color: AppTheme.white),
                  primary: AppTheme.colorTMPDark),
              onPressed: () {
                widget.setLoading(true);
                // runMutation({
                // 'title': _todoTitleController!.text,
                // 'description': _todoDescController!.text,
                // 'user_id': UserConfig.userID,
                // 'id': goodsGroupData.todo_item_id.toString()
                // });
              },
              child: const Text('更新'),
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
            Navigator.pop(context, 1);
          },
          child: const Text('キャンセル'),
        ),
      ),
      const SizedBox(height: 10),
      SizedBox(
          height: 50,
          // リスト追加ボタン
          child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  textStyle: const TextStyle(color: AppTheme.cancelText),
                  primary: AppTheme.cancelText,
                  side: const BorderSide(width: 1, color: AppTheme.cancelText)),
              onPressed: () {
                Navigator.pop(context, 1);
              },
              child: const Text('削除'))),
      const SizedBox(height: 120)
    ];
  }

  Widget editGoodsGroupButton(BuildContext context) {
    return Container(
        height: 40,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
        child: const Icon(Icons.settings_rounded, color: AppTheme.textDark));
  }
}
