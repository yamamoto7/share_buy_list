import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:share_buy_list/config/app_theme.dart';
import 'package:share_buy_list/config/env.dart';
import 'package:share_buy_list/config/size_config.dart';
import 'package:share_buy_list/config/user_config.dart';
import 'package:share_buy_list/model/goods_item_data.dart';
import 'package:share_buy_list/service/graphql_handler.dart';
import 'package:share_buy_list/view/components/bottom_half_modal.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class AddGoodsItemModal extends StatefulWidget {
  const AddGoodsItemModal(
      {Key? key,
      required this.animationController,
      required this.goodsItemData,
      required this.isDirAddable})
      : super(key: key);

  final AnimationController animationController;
  final GoodsItemData goodsItemData;
  final bool isDirAddable;

  @override
  _AddTodoItemModalState createState() => _AddTodoItemModalState();
}

class _AddTodoItemModalState extends State<AddGoodsItemModal>
    with TickerProviderStateMixin {
  late List<Widget> _selectItems;
  bool selectIsDir = false;
  TabController? _tabController;

  late TextEditingController _todoTitleController;
  late TextEditingController _todoDescController;
  late List<Widget> _modalWidgetList;

  @override
  void initState() {
    _todoTitleController = TextEditingController(text: '');
    _todoDescController = TextEditingController(text: '');

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!widget.isDirAddable) {
      _selectItems = [Tab(text: L10n.of(context)!.item)];
    } else {
      _selectItems = [
        Tab(text: L10n.of(context)!.item),
        Tab(text: L10n.of(context)!.folder)
      ];
    }

    _tabController = TabController(length: _selectItems.length, vsync: this);
    _modalWidgetList = getModalWidgetList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.bottomCenter,
        margin: const EdgeInsets.only(bottom: 60),
        child: BottomHalfModal(
            contents: Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _modalWidgetList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: EdgeInsets.only(
                              right: SizeConfig.safeBlockHorizontal * 10,
                              left: SizeConfig.safeBlockHorizontal * 10),
                          child: _modalWidgetList[index]);
                    })),
            child: Container(
                color: Colors.transparent,
                width: 52,
                height: 52,
                child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0, end: 1).animate(
                        // [memo]スケールインアニメーション
                        CurvedAnimation(
                            parent: widget.animationController,
                            curve: Curves.fastOutSlowIn)),
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 10,
                                  spreadRadius: 1)
                            ]),
                        child: Icon(
                          Icons.add,
                          color: Theme.of(context).primaryColorLight,
                          size: 30,
                        ))))));
  }

  List<Widget> getModalWidgetList(BuildContext context) {
    return <Widget>[
      TabBar(
          controller: _tabController,
          tabs: _selectItems,
          labelColor: Theme.of(context).primaryColor,
          // add it here
          indicator: DotIndicator(
            color: Theme.of(context).primaryColor,
            distanceFromCenter: 16,
            radius: 3,
            paintingStyle: PaintingStyle.fill,
          ),
          onTap: (int index) {
            selectIsDir = index == 1;
          }),
      const SizedBox(height: 20),
      Container(
          child: getInputForm(
              context, _todoTitleController, L10n.of(context)!.name)),
      const SizedBox(height: 8),
      Container(
          child: getInputArea(
              context, _todoDescController, L10n.of(context)!.memo)),
      const SizedBox(height: 20),
      Mutation<Widget>(
        options: MutationOptions(
          document: gql(addGoodsItem),
          update: (GraphQLDataProxy cache, result) {},
          onCompleted: (dynamic resultData) {},
        ),
        builder: (runMutation, result) {
          return SizedBox(
            height: 50,
            // リスト追加ボタン
            child: ElevatedButton(
              onPressed: () {
                runMutation(<String, dynamic>{
                  'title': _todoTitleController.text,
                  'description': _todoDescController.text,
                  'goods_item_id': widget.goodsItemData.id,
                  'user_id': UserConfig.userID,
                  'is_directory': selectIsDir
                });
                Navigator.pop(context, 1);
                _todoTitleController.clear();
                _todoDescController.clear();
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
            Navigator.pop(context, 1);
          },
          child: Text(L10n.of(context)!.cancel),
        ),
      ),
      if (!widget.isDirAddable)
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 8),
          child: Text(
              L10n.of(context)!.textMaxDepthNotion(MAX_GOODS_ITEM_DEPTH),
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodySmall),
        ),
    ];
  }
}
