import 'package:flutter/cupertino.dart';
import 'package:nawras_app/Helper/Links.dart';
import 'package:nawras_app/Helper/NawrasHttp.dart';
import 'package:nawras_app/Models/Other/Schedule.dart';

class ScheduleProvider with ChangeNotifier {
  String scheduleUrl = "$kHost/get_calender";
  List<dynamic> scheduleItems = [];

  Future<void> getScheduleData({String token}) async {
    final response = await postHTTP(url: scheduleUrl, body: {"token": token});

    scheduleItems =
        response['schedular'].map((s) => Schedule.fromJson(s)).toList();
  }
}
