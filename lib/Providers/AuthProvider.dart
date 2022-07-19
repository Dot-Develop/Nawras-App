import 'package:flutter/material.dart';
import 'package:nawras_app/Helper/Links.dart';
import 'package:nawras_app/Helper/NawrasHttp.dart';
import 'package:nawras_app/Models/Authentication/SalePerson.dart';
import 'package:nawras_app/Models/Authentication/Session.dart';
import 'package:nawras_app/Models/Authentication/Shop.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String loginUrl = "$kHost/login";
  String autoLoginUrl = "$kHost/saved_login";
  String firebaseToken;
  Session session;
  SalePerson salePerson;
  Shop shop;
  String loginTypeGlobal;
  bool isLoading = false;

  void setFirebaseToken({String token}) {
    firebaseToken = token;
    notifyListeners();
  }

  // void setMainToken({String token}) {
  //   mainToken = token;
  //   notifyListeners();
  // }
  // void setRefreshToken({String token}) {
  //   refreshToken = token;
  //   notifyListeners();
  // }

  bool isLoggedIn = false;

  void setLoginTrue() {
    isLoggedIn = true;
    notifyListeners();
  }

  void setLoginFalse() {
    isLoggedIn = false;
    notifyListeners();
  }

  // List<SalePerson> salePersonList = [];
  // Future<List<SalePerson>> futureSalePersonList;

  Future<bool> login({String loginType, String phone, String password}) async {
    // var deviceId;

    isLoading = true;
    notifyListeners();

    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // if (Platform.isAndroid) {
    //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //   deviceId = androidInfo;
    // } else if (Platform.isIOS) {
    //   IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    //   deviceId = iosInfo;
    // }

    var response = await postHTTP(url: loginUrl, body: {
      'login_type': loginType,
      'phone': phone,
      "password": password,
      "device_id": DateTime.now().toString(),
      "firebase_token": firebaseToken
    });
    if (response == null) {
      isLoading = false;
      notifyListeners();
      return false;
    }

    if (loginType == "shop") {
      shop = Shop.fromJson(response["market_info"]);
      session = Session.fromJson(response["session_info"]);
    } else {
      salePerson = SalePerson.fromJson(response["sale_person_info"]);
      session = Session.fromJson(response["session_info"]);
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('loginType', loginType);
    sharedPreferences.setString('mainToken', session.mainToken);
    sharedPreferences.setString('refreshToken', session.refreshToken);

    loginTypeGlobal = loginType;

    isLoading = false;
    notifyListeners();

    return true;
  }

  Future<bool> autoLogin({String token}) async {
    var response = await postHTTP(url: autoLoginUrl, body: {
      'token': token,
    });
    // print(response);
    if (response == null) {
      return false;
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String loginType = sharedPreferences.getString('loginType');

    if (loginType == "shop") {
      shop = Shop.fromJson(response["market_info"]);
      session = Session.fromJson(response["session_info"]);
    } else {
      salePerson = SalePerson.fromJson(response["\$sale_person_info"]);
      session = Session.fromJson(response["session_info"]);
      // print("Auto Login for :"+ loginType.toString()+ "succeeded");
    }
    loginTypeGlobal = loginType;
    return true;
  }

  Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }
}
