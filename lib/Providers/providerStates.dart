import 'package:flutter/cupertino.dart';

class ProviderStates with ChangeNotifier {
  // sub category button state
  bool isHomeTabLoading = true;

  void setHomeRefreshed() {
    isHomeTabLoading = !isHomeTabLoading;
    notifyListeners();
  } // sub category button state

  bool isFavoriteTabLoading = false;

  void setFavoriteRefreshed() {
    isFavoriteTabLoading = !isFavoriteTabLoading;
    notifyListeners();
  }

  bool isRequestAndActivityLoading = false;

  void setRequestAndActivityRefreshed() {
    isRequestAndActivityLoading = !isRequestAndActivityLoading;
    notifyListeners();
  }
}
