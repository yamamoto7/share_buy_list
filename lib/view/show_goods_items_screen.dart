import 'package:flutter/material.dart';
import 'package:share_buy_list/config/app_theme.dart';
import 'package:share_buy_list/model/goods_item_data.dart';
import 'package:share_buy_list/view/components/add_goods_item_modal.dart';
import 'package:share_buy_list/view/components/goods_items_view.dart';

class ShowGoodsItemsScreen extends StatefulWidget {
  const ShowGoodsItemsScreen(
      {Key? key,
      required this.goodsItem,
      required this.openGoodsItem,
      required this.setLoading,
      required this.isAddableTodoGroup,
      required this.goodsItemDepth})
      : super(key: key);

  final GoodsItemData goodsItem;
  final Function openGoodsItem;
  final Function setLoading;
  final bool isAddableTodoGroup;
  final int goodsItemDepth;
  @override
  _ShowGoodsItemsScreenState createState() => _ShowGoodsItemsScreenState();
}

class _ShowGoodsItemsScreenState extends State<ShowGoodsItemsScreen>
    with TickerProviderStateMixin {
  late Animation<double> topBarAnimation;
  late AnimationController animationController;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  bool isAddableTodoItem = true;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    listViews = <Widget>[
      GoodsItemsView(
        goodsItem: widget.goodsItem,
        changeCurrentGoodsItem: openGoodsItem,
        setAddableTodoItem: setAddableTodoItem,
      ),
      const SizedBox(height: 40)
    ];

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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void openGoodsItem(GoodsItemData goodsItemData) {
    widget.openGoodsItem(goodsItemData, widget.goodsItemDepth);
  }

  void setAddableTodoItem(bool isAddable) {
    setState(() {
      isAddableTodoItem = isAddable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            AddGoodsItemModal(
                animationController: animationController,
                goodsItemData: widget.goodsItem,
                isDirAddable: true)
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.only(
        top: AppBar().preferredSize.height +
            MediaQuery.of(context).padding.top +
            24,
        bottom: 62 + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: listViews.length,
      itemBuilder: (BuildContext context, int index) {
        animationController.forward();
        return listViews[index];
      },
    );
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
                        0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppTheme.white.withOpacity(topBarOpacity),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(32.0),
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: AppTheme.mainColorDark
                                    .withOpacity(0.4 * topBarOpacity),
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 10.0),
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
                                        icon: const Icon(Icons.chevron_left,
                                            size: 32,
                                            color: AppTheme.mainColorDark),
                                        onPressed: () {
                                          Navigator.pop(context, 1);
                                        }),
                                    Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(widget.goodsItem.title,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 22 +
                                                      6 -
                                                      6 * topBarOpacity,
                                                  letterSpacing: 1.2,
                                                  color: AppTheme.mainColorDark,
                                                ))))
                                  ]))
                        ]))));
          })
    ]);
  }
}
