import 'package:share_buy_list/config/app_theme.dart';
import 'package:share_buy_list/config/size_config.dart';
import 'package:share_buy_list/view/config_screen.dart';
import 'package:share_buy_list/view/show_group_items_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class AppHomeScreen extends StatefulWidget {
  @override
  _AppHomeScreenState createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  PersistentTabController? _controller;

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);

    super.initState();
    animationController?.forward();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // init
    SizeConfig().init(context);
    return Stack(children: [
      Padding(
          padding: EdgeInsets.only(bottom: 0),
          // padding: EdgeInsets.only(bottom: bannerAd.size.height.toDouble()),
          child: PersistentTabView(context,
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
                borderRadius: BorderRadius.circular(20.0),
                colorBehindNavBar: Colors.white,
              ),
              popAllScreensOnTapOfSelectedTab: true,
              popActionScreens: PopActionScreensType.all,
              itemAnimationProperties: ItemAnimationProperties(
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: ScreenTransitionAnimation(
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              navBarStyle: NavBarStyle.style10))
    ]);
  }

  List<Widget> _buildScreens() {
    return [
      ConfigScreen(),
      ShowGroupItemsScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.dashboard_customize_rounded),
        title: ("Home"),
        activeColorPrimary: AppTheme.tabItemColor,
        activeColorSecondary: AppTheme.white,
        inactiveColorPrimary: AppTheme.tabItemColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings_rounded),
        title: ("Settings"),
        activeColorPrimary: AppTheme.tabItemColor,
        activeColorSecondary: AppTheme.white,
        inactiveColorPrimary: AppTheme.tabItemColor,
      ),
    ];
  }
}
