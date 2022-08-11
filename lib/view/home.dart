import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:share_buy_list/config/app_theme.dart';
import 'package:share_buy_list/config/env.dart';
import 'package:share_buy_list/config/size_config.dart';
import 'package:share_buy_list/model/goods_item_data.dart';
import 'package:share_buy_list/view/config_screen.dart';
import 'package:share_buy_list/view/show_goods_group_items_screen.dart';
import 'package:share_buy_list/view/show_goods_items_screen.dart';

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen(
      {Key? key, required this.isFirstAccess, required this.tab})
      : super(key: key);

  final bool isFirstAccess;
  final int tab;

  @override
  _AppHomeScreenState createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  bool visibleLoading = true;
  PersistentTabController? _controller;
  AdWidget? adWidget;
  final homeBannerAd = getBottomBannerAd(0);

  @override
  void initState() {
    if (!widget.isFirstAccess) {
      _controller = PersistentTabController(initialIndex: 0);
      adWidget = AdWidget(ad: homeBannerAd);
      animationController = AnimationController(
          duration: const Duration(milliseconds: 600), vsync: this);

      animationController.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(children: [
      PersistentTabView(context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.white,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          hideNavigationBarWhenKeyboardShows: true,
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(20),
            colorBehindNavBar: Colors.white,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: const ItemAnimationProperties(
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle.style10)
    ]);
  }

  List<Widget> _buildScreens() {
    return [
      ShowGoodsGroupItemsScreen(
          setLoading: setLoading, openGoodsItem: openGoodsItem),
      const ConfigScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.dashboard_customize_rounded),
        title: 'Home',
        activeColorPrimary: AppTheme.tabItemColor,
        activeColorSecondary: AppTheme.white,
        inactiveColorPrimary: AppTheme.tabItemColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings_rounded),
        title: 'Settings',
        activeColorPrimary: AppTheme.tabItemColor,
        activeColorSecondary: AppTheme.white,
        inactiveColorPrimary: AppTheme.tabItemColor,
      ),
    ];
  }

  void openTodoItem(GoodsItemData goodsItemData) {
    final bannerAd = getBottomBannerAd(1);
    final adContainer = Positioned(
        bottom: 0,
        child: Container(
            decoration: const BoxDecoration(
              color: AppTheme.background,
            ),
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            width: MediaQuery.of(context).size.width,
            height: bannerAd.size.height.toDouble() +
                MediaQuery.of(context).padding.bottom,
            child: adWidget));

    animationController.reverse().then<dynamic>((data) {
      if (!mounted) {
        return;
      }

      pushNewScreen<void>(context,
          screen: Stack(children: [
            Padding(
                padding:
                    EdgeInsets.only(bottom: bannerAd.size.height.toDouble()),
                child: ShowGoodsItemsScreen(
                    goodsItem: goodsItemData,
                    goodsItemDepth: 1,
                    openGoodsItem: openGoodsItem,
                    isAddableTodoGroup: true,
                    setLoading: setLoading)),
            adContainer
          ]));
    });
  }

  void openGoodsItem(GoodsItemData goodsItemData, int goodsItemPageDepth) {
    if (goodsItemPageDepth >= MAX_GOODS_GROUP_NUM) {
      return;
    }
    final bannerAd = getBottomBannerAd(goodsItemPageDepth);
    // ignore: cascade_invocations
    bannerAd.load();

    final adContainer = Positioned(
        bottom: 0,
        child: Container(
            decoration: const BoxDecoration(
              color: AppTheme.background,
            ),
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            width: MediaQuery.of(context).size.width,
            height: bannerAd.size.height.toDouble() +
                MediaQuery.of(context).padding.bottom,
            child: AdWidget(ad: bannerAd)));

    pushNewScreen<void>(context,
        screen: Stack(children: [
          Padding(
              padding: EdgeInsets.only(bottom: bannerAd.size.height.toDouble()),
              child: ShowGoodsItemsScreen(
                  goodsItem: goodsItemData,
                  openGoodsItem: openGoodsItem,
                  setLoading: setLoading,
                  isAddableTodoGroup:
                      goodsItemPageDepth + 1 < MAX_GOODS_GROUP_NUM,
                  goodsItemDepth: goodsItemPageDepth + 1)),
          adContainer
        ]));
  }

  void setLoading(bool loading) {
    setState(() {
      visibleLoading = loading;
    });
  }
}

BannerAd getBottomBannerAd(int pageDepth) {
  String adUnitId;
  List<String> adUnitIds;
  if (Platform.isAndroid && pageDepth < 3) {
    adUnitId = 'ca-app-pub-3940256099942544/6300978111';
  } else if (Platform.isIOS && pageDepth < 3) {
    adUnitId = 'ca-app-pub-3940256099942544/6300978111';
  } else if (Platform.isAndroid) {
    adUnitIds = [
      'ca-app-pub-6288892025887848/1853513894',
      'ca-app-pub-6288892025887848/1853513894',
      'ca-app-pub-6288892025887848/5421157570',
      'ca-app-pub-6288892025887848/7664177535'
    ];
    adUnitId = adUnitIds[pageDepth];
  } else if (Platform.isIOS) {
    adUnitIds = [
      'ca-app-pub-6288892025887848/1853513894',
      'ca-app-pub-6288892025887848/1853513894',
      'ca-app-pub-6288892025887848/5421157570',
      'ca-app-pub-6288892025887848/7664177535'
    ];
    adUnitId = adUnitIds[pageDepth];
  } else {
    adUnitId = 'ca-app-pub-3940256099942544/6300978111';
  }
  return BannerAd(
    adUnitId: adUnitId,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );
}
