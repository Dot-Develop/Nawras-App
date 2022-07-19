import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/CustomIcons.dart';
import 'package:nawras_app/GlobalWidgets/Direction.dart';
import 'package:nawras_app/GlobalWidgets/network_sensitive%20.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Models/Authentication/SalePerson.dart';
import 'package:nawras_app/Models/Authentication/Shop.dart';
import 'package:nawras_app/Providers/AppSettingsProvider.dart';
import 'package:nawras_app/Providers/AuthProvider.dart';
import 'package:nawras_app/Providers/OrderProvider.dart';
import 'package:nawras_app/Providers/OtherProvider.dart';
import 'package:nawras_app/Screens/HomeScreen/Tabs/ActivityTab.dart';
import 'package:nawras_app/Screens/HomeScreen/Tabs/HomeTab.dart';
import 'package:nawras_app/Screens/HomeScreen/Tabs/RequestTab.dart';
import 'package:nawras_app/Screens/HomeScreen/Tabs/SearchTab.dart';
import 'package:nawras_app/Screens/HomeScreen/Widgets/CartDrawer.dart';
import 'package:nawras_app/Screens/HomeScreen/Widgets/Notification.dart';
import 'package:nawras_app/GlobalWidgets/network_sensitive .dart';
import 'package:provider/provider.dart';
import 'Tabs/ActivityTab.dart';
import 'Tabs/FavoriteTab.dart';
import 'Tabs/SettingsTab.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, int> login;

  @override
  Widget build(BuildContext context) {
    final words = Provider.of<Language>(context).words;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    login = {"salePersonId": 0, "marketId": 0};
    if (auth.loginTypeGlobal == "shop") {
      Shop shop = auth.shop;
      login["marketId"] = shop.id;
    } else {
      SalePerson salePerson = auth.salePerson;
      login["salePersonId"] = salePerson.id;
    }
    final appSettingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);

    // if (appSettingsProvider.tabHome != 0)
    //   appSettingsProvider.jumpToRequestTab();

    return NetworkSensitive(
      child: Direction(
        child: WillPopScope(
          onWillPop: () async => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                backgroundColor: PaletteColors.whiteBg,
                title: Text(words["sure-log-out"]),
                actions: <Widget>[
                  RaisedButton(
                      child: Text(words["log-out"]),
                      color: PaletteColors.darkRedColorApp,
                      onPressed: () async {
                        appSettingsProvider.setHomeTab(0);
                        exit(0);
                      }),
                  RaisedButton(
                      child: Text(words["close"]),
                      onPressed: () => Navigator.of(context).pop(false)),
                ]),
          ),
          child: Consumer<AppSettingsProvider>(
            builder: (_, settings, __) => Scaffold(
              key: _scaffoldKey,
              endDrawer: CartDrawer(),
              drawer: NotificationDrawer(
                mContext: context,
              ),
              backgroundColor: PaletteColors.whiteBg,
              appBar: AppBar(
                title: Text(
                    tabTitles(context)[settings.tabHome]['title'] ==
                            words["home"]
                        ? words["nawras"]
                        : tabTitles(context)[settings.tabHome]['title'],
                    style: AppTextStyle.boldTitle24.copyWith(
                        color: PaletteColors.whiteBg,
                        fontWeight: FontWeight.w600)),
                centerTitle: true,
                iconTheme: IconThemeData(color: PaletteColors.whiteBg),
                backgroundColor: PaletteColors.mainAppColor,
                leading: Builder(
                  builder: (context) => IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 1, right: 3),
                            child: CircleAvatar(
                              radius: 7,
                              backgroundColor: Colors.white,
                              child: Text(
                                Provider.of<OtherProvider>(context)
                                    .listNotification
                                    .length
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: getAppIcons(
                              asset: AppIcons.notifivations,
                              size: 30,
                              color: PaletteColors.whiteBg),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              top: 5.0,
                            ),
                            child: getAppIcons(
                                size: 30,
                                asset: AppIcons.shop2,
                                color: PaletteColors.whiteBg),
                          ),
                          Align(
                            child: CircleAvatar(
                              radius: 7,
                              backgroundColor: Colors.white,
                              child: Text(
                                Provider.of<OrderProvider>(context)
                                    .listOrderItemsCart
                                    .length
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            alignment: Alignment.topRight,
                          )
                        ],
                      ),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  )
                ],
              ),
              bottomNavigationBar: BottomNavyBar(
                backgroundColor: PaletteColors.mainAppColor,
                selectedIndex: settings.tabHome,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                containerHeight: 50,
                curve: Curves.fastLinearToSlowEaseIn,
                iconSize: 24,
                showElevation: true,
                itemCornerRadius: 15,
                onItemSelected: (index) {
                  appSettingsProvider.setHomeTab(index);
                  settings.controller.jumpToPage(index);
                },
                items: tabTitles(context)
                    .map(
                      (tabTitle) => BottomNavyBarItem(
                          activeColor: PaletteColors.whiteBg,
                          inactiveColor: PaletteColors.whiteBg,
                          title: Text(
                            tabTitle['title'],
                            style: AppTextStyle.regularTitle14
                                .copyWith(color: PaletteColors.whiteBg),
                            textAlign: TextAlign.center,
                          ),
                          icon: settings.tabHome == 2 &&
                                  settings.tabHome == tabTitle["index"]
                              ? Image.asset(
                                  tabTitle["icon-solid"],
                                  color: PaletteColors.whiteBg,
                                  height: 30,
                                )
                              : getAppIcons(
                                  asset: tabTitle[
                                      settings.tabHome == tabTitle["index"]
                                          ? "icon-solid"
                                          : "icon"],
                                  size: 30,
                                  color: PaletteColors.whiteBg)),
                    )
                    .toList(),
              ),
              body: SizedBox.expand(
                child: Consumer<OtherProvider>(
                  builder: (_, other, __) {
                    if (other.isNotificationShown) {
                      Fluttertoast.showToast(
                        textColor: PaletteColors.whiteBg,
                        backgroundColor: PaletteColors.blackAppColor,
                        msg: words["notification-status"],
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                      other.hideNotificationSnackbar();
                    }
                    return PageView(
                      children: tabs,
                      controller: settings.controller,
                      onPageChanged: (index) => settings.setHomeTab(index),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> get tabs {
    return [
      HomeTab(),
      login["salePersonId"] == 0 ? ActivityTab() : RequestTab(),
      FavoriteTab(),
      SearchTab(),
      SettingsTab(),
    ];
  }

  List<Map<String, dynamic>> tabTitles(BuildContext context) {
    final words = Provider.of<Language>(context).words;
    return [
      {
        'title': words["home"],
        'icon': AppIcons.homeOutline,
        'icon-solid': AppIcons.home,
        "index": 0
      },
      login["salePersonId"] == 0
          ? {
              'title': words["activity"],
              'icon': AppIcons.activity,
              'icon-solid': AppIcons.activityOutline,
              "index": 1
            }
          : {
              'title': words["requests"],
              'icon': AppIcons.request,
              'icon-solid': AppIcons.requestOutline,
              "index": 1
            },
      {
        'title': words["favorites"],
        'icon': AppIcons.favoriteOutline,
        'icon-solid': AppIcons.favoritePng,
        "index": 2
      },
      {
        'title': words["search"],
        'icon': AppIcons.search,
        'icon-solid': AppIcons.search,
        "index": 3
      },
      {
        'title': words["settings"],
        'icon': AppIcons.settingsOutline,
        'icon-solid': AppIcons.settings,
        "index": 4
      },
    ];
  }
}
