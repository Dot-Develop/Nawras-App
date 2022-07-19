import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nawras_app/Helper/Links.dart';
import 'package:nawras_app/Helper/NawrasHttp.dart';
import 'package:nawras_app/Models/Other/Bannar.dart';
import 'package:nawras_app/Models/Other/LocalNotification.dart';
import 'package:nawras_app/Models/Other/Offer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtherProvider with ChangeNotifier {
  String getRequestMarketTeamUrl = "$kHost/market_team";
  String getfeedbackUrl = "$kHost/market_feedback";
  String getBannarUrl = "$kHost/banners";
  String getOfferUrl = "$kHost/offers";

  bool isNotificationShown = false;
  List<LocalNotification> listNotification = [];

  Future<void> sendRequestMarketTeam({Map data}) async {
    var response = await postHTTP(url: getRequestMarketTeamUrl, body: data);
    if (response == null) {
      // return print("null");
    }
    // print('suuccss');
  }

  List<dynamic> allBannersList = [];

  Future<bool> getAllBanners(
      {int salePersonId, int marketId, String token, String language}) async {
    var response = await postHTTP(url: getBannarUrl, body: {
      'sale_person_id': salePersonId,
      'market_id': marketId,
      'language': language,
      'token': token,
    });
    // print(response.toString()+"imageeee");
    if (response == null) {
      return false;
    }

    allBannersList =
        response["banners"].map((data) => Bannar.fromJson(data)).toList();

    // print(allBannarsList[0].image);
    return true;
  }

  List<dynamic> allOffersList = [];

  Future<bool> getAllOffers({String token, String language}) async {
    var response = await postHTTP(url: getOfferUrl, body: {
      'language': language,
      'token': token,
    });
    if (response == null) {
      return false;
    }

    print(response);
    allOffersList =
        response["offers"].map((data) => Offer.fromJson(data)).toList();
    print("Offers" + allOffersList.length.toString());

    return true;
  }

  Future<void> feedbackRequest(
      {String token, String name, String title, String message}) async {
    var response = await postHTTP(url: getfeedbackUrl, body: {
      'name': name,
      'title': title,
      'message': message,
      'token': token,
    });
    if (response == null) {
      return print("null");
    }
    print('suuccss');
  }

  addLocalNotification({@required LocalNotification localNotification}) {
    listNotification.add(localNotification);
    setNotificationsSharedPreferences();
    showNotificationSnackbar();
    notifyListeners();
  }

  showNotificationSnackbar() {
    isNotificationShown = true;
    notifyListeners();
  }

  hideNotificationSnackbar() {
    isNotificationShown = false;
    notifyListeners();
  }

  removeLocalNotification({@required LocalNotification localNotification}) {
    listNotification
        .removeWhere((element) => localNotification.title == element.title);
    setNotificationsSharedPreferences();
    notifyListeners();
  }

  Future<void> getAllNotificationsSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('notifications');
    if (data == null) {
      listNotification = [];
      return;
    }
    List notifications = jsonDecode(data) ?? [];
    try {
      if (notifications.length != 0)
        listNotification = notifications
            .map((notification) => LocalNotification.fromJson(notification))
            .toList();
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }

  Future<void> setNotificationsSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('notifications', json.encode(listNotification));
    print("Data Save");
  }

  void clearAllNotifications() {
    listNotification.clear();
    notifyListeners();
    setNotificationsSharedPreferences();
  }
}
