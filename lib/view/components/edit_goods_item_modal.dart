import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:share_buy_list/config/app_theme.dart';
import 'package:share_buy_list/config/size_config.dart';
import 'package:share_buy_list/config/user_config.dart';
import 'package:share_buy_list/model/goods_item_data.dart';
import 'package:share_buy_list/service/graphql_handler.dart';
import 'package:share_buy_list/view/components/bottom_half_modal.dart';

class EditGoodsItemModal extends StatefulWidget {
  const EditGoodsItemModal({Key? key, required this.goodsItemData})
      : super(key: key);

  final GoodsItemData goodsItemData;

  @override
  _EditGoodsItemModalState createState() => _EditGoodsItemModalState();
}

class _EditGoodsItemModalState extends State<EditGoodsItemModal>
    with TickerProviderStateMixin {
  late TextEditingController _goodsGroupTitleController;
  late TextEditingController _goodsGroupDescController;
  late List<Widget> _modalWidgetList;

  @override
  Widget build(BuildContext context) {
    _goodsGroupTitleController =
        TextEditingController(text: widget.goodsItemData.title);
    _goodsGroupDescController =
        TextEditingController(text: widget.goodsItemData.description);

    // TabControllerの初期化
    _modalWidgetList = getModalWidgetList(context);
    return BottomHalfModal(
        contents: ListView.builder(
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
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
              width: 65,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              child: Text(
                L10n.of(context)!.edit,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .apply(color: Theme.of(context).primaryColor),
              )),
        ));
  }

  List<Widget> getModalWidgetList(BuildContext context) {
    return <Widget>[
      const SizedBox(height: 30),
      Container(
          child: getInputForm(context, _goodsGroupTitleController,
              L10n.of(context)!.name, true)),
      const SizedBox(height: 8),
      Container(
          child: getInputArea(context, _goodsGroupDescController,
              L10n.of(context)!.memo, false)),
      const SizedBox(height: 20),
      Mutation<dynamic>(
        options: MutationOptions<dynamic>(
          document: gql(updateGoodsItemData),
          update: (GraphQLDataProxy cache, result) {},
          onCompleted: (dynamic resultData) {},
        ),
        builder: (
          runMutation,
          result,
        ) {
          return SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  runMutation(<String, dynamic>{
                    'title': _goodsGroupTitleController.text,
                    'description': _goodsGroupDescController.text,
                    'user_id': UserConfig.userID,
                    'id': widget.goodsItemData.id
                  });
                  Navigator.pop(context, 1);
                  _goodsGroupTitleController.clear();
                  _goodsGroupDescController.clear();
                },
                child: Text(L10n.of(context)!.update),
              ));
        },
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 50,
        child: OutlinedButton(
          onPressed: () {
            Navigator.pop(context, 1);
          },
          child: Text(
            L10n.of(context)!.cancel,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    ];
  }
}
