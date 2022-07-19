import 'package:flutter/cupertino.dart';

class PageLoadingProvider with ChangeNotifier {
  bool homePageLoading = true;
  bool searchPageLoading = true;

  changeAllHomeLoading() {
    homePageLoading = false;
    notifyListeners();
  }

  changeHomePageLoading() {
    homePageLoading = true;
    notifyListeners();
  }

  changeSearchPageLoading() {
    searchPageLoading = true;
    notifyListeners();
  }
}
