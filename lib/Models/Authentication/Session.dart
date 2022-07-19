

import 'package:flutter/cupertino.dart';

class  Session {
  final int id;
  final String firebaseToken;
  final String mainToken;
  final String refreshToken;

  Session(
      {@required this.id,
        @required this.firebaseToken,
        @required this.mainToken,
        @required this.refreshToken});

  factory  Session.fromJson(Map<String, dynamic> data) =>  Session(
      id: data["id"],
    firebaseToken: data["firebase_token"],
    mainToken: data["token"],
    refreshToken: data["r_token"],
     );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'firebase_token': firebaseToken,
    'token': mainToken,
    'r_token': refreshToken,
  };
}
