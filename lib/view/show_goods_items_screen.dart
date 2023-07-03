import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:share_buy_list/config/user_config.dart';
import 'package:share_buy_list/model/goods_item_data.dart';
import 'package:share_buy_list/service/graphql_handler.dart';
import 'package:share_buy_list/service/sql_handler.dart';
import 'package:share_buy_list/view/components/add_goods_item_modal.dart';
import 'package:share_buy_list/view/components/goods_item_card.dart';
import 'package:share_buy_list/view/components/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowGoodsItemsScreen extends StatefulWidget {
  const ShowGoodsItemsScreen(
      {Key? key,
      required this.goodsItem,
      required this.openGoodsItem,
      required this.setLoading,
      required this.goodsItemDepth})
      : super(key: key);

  final GoodsItemData goodsItem;
  final Function openGoodsItem;
  final Function setLoading;
  final int goodsItemDepth;
  @override
  _ShowGoodsItemsScreenState createState() => _ShowGoodsItemsScreenState();
}

class _ShowGoodsItemsScreenState extends State<ShowGoodsItemsScreen>
    with TickerProviderStateMixin {
  late Animation<double> topBarAnimation;
  late AnimationController animationController;
  late GoodsItemData _goodsItem;
  late List<GoodsItemData> _goodsItemDataList;
  String _lastUpdatedAt = '2020-01-01T00:00:00.00000+00:00';
  String _excludeUserID = '4913e346-07f4-40e5-842d-a47d6fdf4941';

  late SharedPreferences prefs;
  bool loaded = false;
  bool startSubscription = false;

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0;
  bool isAddableTodoItem = true;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    topBarAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: animationController,
        curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    _goodsItem = widget.goodsItem;
    setGoodsItems();
    animationController.forward();

    super.initState();
  }

  Future<void> setGoodsItems() async {
    _goodsItemDataList = await SqlObject.getGoodsItems(_goodsItem.id);
    prefs = await SharedPreferences.getInstance();

    setState(() {
      loaded = true;
      startSubscription = true;
    });
  }

  void openGoodsItem(GoodsItemData goodsItemData) {
    widget.openGoodsItem(goodsItemData, widget.goodsItemDepth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: <Widget>[
          getGoodsItemCardList(context),
          getAppBarUI(),
          startSubscription ? fetchGoodsItemsDataResult(context) : Container(),
          AddGoodsItemModal(
              animationController: animationController,
              goodsItemData: widget.goodsItem,
              isDirAddable: true)
        ],
      ),
    );
  }

  Widget getGoodsItemCardList(BuildContext context) {
    if (!loaded) {
      return const Center(child: ColorLoader(radius: 15, dotRadius: 3));
    } else if (_goodsItemDataList.isEmpty) {
      final widgets = [
        const SizedBox(height: 100),
        SvgPicture.asset(
          'assets/images/illust01.svg',
          color: Theme.of(context).primaryColor,
          height: 80,
        ),
        const SizedBox(height: 20),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: L10n.of(context)!.showGoodsGroupItemsScreenAddItemLeft,
                  style: Theme.of(context).textTheme.titleMedium),
              const WidgetSpan(child: SizedBox(width: 12)),
              const WidgetSpan(child: Icon(Icons.add_box, size: 28)),
              const WidgetSpan(child: SizedBox(width: 12)),
              TextSpan(
                  text: L10n.of(context)!.showGoodsGroupItemsScreenAddItemRight,
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ];
      return Column(children: widgets);
    } else {
      return ReorderableListView.builder(
          onReorder: (before, after) async {
            int newOrder;
            if (before < after) {
              after--;
              newOrder = _goodsItemDataList[after].displayOrder + 5;
            } else {
              newOrder = _goodsItemDataList[after].displayOrder - 5;
            }
            final movedGoodsItem = _goodsItemDataList.removeAt(before);
            setState(() {
              _goodsItemDataList.insert(after, movedGoodsItem);
            });
            movedGoodsItem.displayOrder = newOrder;
            await SqlObject.updateGoodsItemOrder(movedGoodsItem, _goodsItem.id);
            _goodsItemDataList = await SqlObject.getGoodsItems(_goodsItem.id);
            setState(() {
              _goodsItemDataList = _goodsItemDataList;
            });
          },
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
              right: 16,
              left: 16),
          itemCount: _goodsItemDataList.length,
          scrollDirection: Axis.vertical,
          scrollController: scrollController,
          itemBuilder: (BuildContext context, int index) {
            return GoodsItemView(
              key: Key(_goodsItemDataList[index].id),
              goodsItemData: _goodsItemDataList[index],
              changeCurrentGoodsItem: openGoodsItem,
              removeGoodsItem: removeGoodsItem,
              toggleGoodsItem: toggleGoodsItem,
            );
          });
    }
  }

  Future<void> toggleGoodsItem(GoodsItemData goodsItemData) async {
    setState(() {
      goodsItemData.isFinished = !goodsItemData.isFinished;
    });
    try {
      await graphQlObject.query(
          toggleGoodsItemQuery(goodsItemData.id, goodsItemData.isFinished));
    } catch (e) {
      print(e);
    }
    await SqlObject.insertOrUpdateGoodsItem(goodsItemData, _goodsItem.id);
  }

  Future<void> removeGoodsItem(GoodsItemData goodsItemData) async {
    try {
      await graphQlObject.query(deleteGoodsItem(goodsItemData.id));
      await SqlObject.removeGoodsItem(goodsItemData.id);
    } catch (e) {
      await SqlObject.insertOrUpdateGoodsItem(goodsItemData, _goodsItem.id);
      print(e);
    }
    setState(() {
      _goodsItemDataList.remove(goodsItemData);
    });
  }

  Widget fetchGoodsItemsDataResult(BuildContext context) {
    return Subscription<Widget>(
        options: SubscriptionOptions(
          fetchPolicy: FetchPolicy.networkOnly,
          document: gql(
              fetchGoodsItems(_goodsItem.id, _lastUpdatedAt, _excludeUserID)),
        ),
        onSubscriptionResult: (subscriptionResult, client) {
          final goodsItemDataList = List<GoodsItemData>.from(subscriptionResult
              .data!['goods_item']
              .map<GoodsItemData>(GoodsItemData.fromJson)
              .toList() as List<GoodsItemData>);
          for (var i = 0; i < goodsItemDataList.length; i++) {
            final index = _goodsItemDataList.indexWhere(
                (GoodsItemData e) => e.id == goodsItemDataList[i].id);
            if (index >= 0) {
              goodsItemDataList[i].displayOrder =
                  _goodsItemDataList[index].displayOrder;
              if (_goodsItemDataList[index].updatedAt ==
                  goodsItemDataList[i].updatedAt) {
                continue;
              }
              _goodsItemDataList[index].setData(goodsItemDataList[i]);
            } else {
              _goodsItemDataList.add(goodsItemDataList[i]);
            }
            prefs
                .setString('${_goodsItem.id}_last_updated_at',
                    goodsItemDataList[goodsItemDataList.length - 1].updatedAt)
                .toString();
            setState(() {
              _lastUpdatedAt =
                  goodsItemDataList[goodsItemDataList.length - 1].updatedAt;
              _excludeUserID = UserConfig.userID;
            });
          }
          SqlObject.insertOrUpdateGoodsItemList(
              goodsItemDataList, _goodsItem.id);
        },
        builder: (result) {
          if (result.hasException) {
            print('ERROR');
            print(result.exception);
            return Column(children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.only(
                      top: 12, right: 16, left: 16, bottom: 12),
                  primary: Theme.of(context).errorColor,
                  side:
                      BorderSide(width: 1, color: Theme.of(context).errorColor),
                ),
                onPressed: () async {},
                child: Text(
                  L10n.of(context)!.showGoodsGroupItemsScreenFetchError,
                ),
              ),
              const SizedBox(height: 20),
            ]);
          } else {
            return Container();
          }
        });
  }

  Widget getAppBarUI() {
    return Column(children: <Widget>[
      AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
                opacity: topBarAnimation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0, 30 * (1.0 - topBarAnimation.value), 0),
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .primaryColorLight
                              .withOpacity(topBarOpacity),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Theme.of(context)
                                    .shadowColor
                                    .withOpacity(0.4 * topBarOpacity),
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 10),
                          ],
                        ),
                        child: Column(children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).padding.top,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 16 - 8.0 * topBarOpacity,
                                  bottom: 12 - 8.0 * topBarOpacity),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(
                                        icon: const Icon(
                                          Icons.chevron_left,
                                          size: 32,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context, 1);
                                        }),
                                    Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(widget.goodsItem.title,
                                                textAlign: TextAlign.left,
                                                style: Theme.of(context)
                                                    .appBarTheme
                                                    .titleTextStyle)))
                                  ]))
                        ]))));
          })
    ]);
  }
}
