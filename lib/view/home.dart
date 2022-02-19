import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:share_buy_list/config/app_theme.dart';
import 'package:share_buy_list/config/size_config.dart';
import 'package:share_buy_list/view/config_screen.dart';
import 'package:share_buy_list/view/show_group_items_screen.dart';

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({Key? key}) : super(key: key);

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
      const ConfigScreen(),
      const ShowGroupItemsScreen(),
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
}
