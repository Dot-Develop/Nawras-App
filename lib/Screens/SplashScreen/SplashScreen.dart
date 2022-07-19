import 'dart:async';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/GlobalWidgets/LoadingIndicator.dart';
import 'package:nawras_app/GlobalWidgets/network_sensitive%20.dart';
import 'package:nawras_app/Models/Other/LocalNotification.dart';
import 'package:nawras_app/Providers/AuthProvider.dart';
import 'package:nawras_app/Providers/OtherProvider.dart';
import 'package:nawras_app/Providers/ProductProvider.dart';
import 'package:provider/provider.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    checkNotification();
    checkLoggingState();
  }

  @override
  Widget build(BuildContext context) {
    String languageCode = Provider.of<Language>(context).languageCode;
    return NetworkSensitive(
      child: Theme(
        data: ThemeData(fontFamily: languageCode == "en" ? "Raleway" : "Droid"),
        child: Scaffold(
          body: Center(child: LoadingIndicator()),
        ),
      ),
    );
  }

  void goToScreen(String route) {
    Provider.of<ProductProvider>(context, listen: false)
        .getAllFavoritesSharedPreferences();
    Provider.of<OtherProvider>(context, listen: false)
        .getAllNotificationsSharedPreferences();
    Timer(Duration(milliseconds: 0), () {
      Navigator.pushNamed(context, '/$route');
    });
  }

  void checkLoggingState() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Provider.of<Language>(context, listen: false).getLanguageDataInLocal();
    String token = sharedPreferences.getString('mainToken');
    if (token != null) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      bool status = await auth.autoLogin(token: token);
      if (status) {
        goToScreen("home");
      } else {
        print("SPLASH STUCK !!!!");
      }
    } else {
      goToScreen("login");
    }
  }

  void checkNotification() {
    OtherProvider provider = Provider.of<OtherProvider>(context, listen: false);
    var random = new Random();
    String uid =
        random.nextInt(1000).toString() + random.nextInt(1000).toString();

    _firebaseMessaging.subscribeToTopic("all");
    _firebaseMessaging.getToken().then((value) {
      print("firebase token: = $value");
      final auth = Provider.of<AuthProvider>(context, listen: false);
      auth.setFirebaseToken(token: value);
    });
    //Needed by iOS only
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registereddd: $settings");
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage3: $message");
        final other = Provider.of<OtherProvider>(context, listen: false);
        other.showNotificationSnackbar();
        provider.addLocalNotification(
            localNotification: LocalNotification(
                id: uid,
                productId: message["data"]["product_id"],
                title: message["data"]["title"],
                body: message["data"]["body"],
                type: message["data"]["type"],
                time: DateTime.now()));
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLunch3: $message");
        provider.addLocalNotification(
            localNotification: LocalNotification(
                id: uid,
                productId: message["data"]["product_id"],
                title: message["data"]["title"],
                body: message["data"]["body"],
                type: message["data"]["type"],
                time: DateTime.now()));
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume3: $message");
        provider.addLocalNotification(
          localNotification: LocalNotification(
            id: uid,
            productId: message["data"]["product_id"],
            title: message["data"]["title"],
            body: message["data"]["body"],
            type: message["data"]["type"],
            time: DateTime.now(),
          ),
        );
      },
    );
  }
}
