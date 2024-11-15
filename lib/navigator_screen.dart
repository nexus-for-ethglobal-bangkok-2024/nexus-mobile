import 'package:flutter/material.dart';
import 'package:nexus_mobile/market_data_screen.dart';
import 'package:nexus_mobile/swap_screen.dart';
import 'package:nexus_mobile/wallet_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({super.key});

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  List<Widget> buildScreens() {
    return [const MarketDataScreen(), const SwapScreen(), WalletScreen()];
  }

  List<PersistentBottomNavBarItem> navBarItems() {
    return [
      PersistentBottomNavBarItem(
          activeColorPrimary: Colors.white,
          icon: const Icon(
            Icons.analytics_outlined,
            color: Colors.white,
          ),
          inactiveIcon: const Icon(
            Icons.analytics_outlined,
            color: Colors.grey,
          )),
      PersistentBottomNavBarItem(
          activeColorPrimary: Colors.white,
          icon: const Icon(
            Icons.swap_horiz_outlined,
            color: Colors.white,
          ),
          inactiveIcon: const Icon(
            Icons.swap_horiz_outlined,
            color: Colors.grey,
          )),
      PersistentBottomNavBarItem(
          activeColorPrimary: Colors.white,
          icon: const Icon(
            Icons.wallet,
            color: Colors.white,
          ),
          inactiveIcon: const Icon(
            Icons.wallet,
            color: Colors.grey,
          )),
    ];
  }

  PersistentTabController controller = PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      navBarHeight: 70,
      context,
      controller: controller,
      screens: buildScreens(),
      items: navBarItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.black,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInCirc,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.linearToEaseOut,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.simple,
      margin: EdgeInsets.all(0),
    );
  }
}
