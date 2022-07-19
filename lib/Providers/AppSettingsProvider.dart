import 'package:flutter/material.dart';

class AppSettingsProvider extends ChangeNotifier {
  int tabHome = 0;
  PageController controller = PageController();

  void setHomeTab(int tab) {
    tabHome = tab;
    controller.animateToPage(tab,
        duration: Duration(milliseconds: 900), curve: Curves.ease);
    notifyListeners();
  }

  int getHomeTab() {
    if (tabHome == null) {
      tabHome = 2;
    }
    return tabHome;
  }
}
