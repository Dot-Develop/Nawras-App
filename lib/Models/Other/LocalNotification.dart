

import 'package:flutter/cupertino.dart';

class LocalNotification {
  final String id;
  final String productId;
  final String title;
  // final String titleKr;
  // final String titleAr;
  final String body;
  // final String bodyKr;
  // final String bodyAr;
  final String image;
  final String type;
  final DateTime time;

  LocalNotification({
    @required this.id,
    @required this.productId,
    @required this.title,
    // @required this.titleKr,
    // @required this.titleAr,
    @required this.body,
    // @required this.bodyKr,
    // @required this.bodyAr,
    @required this.image,
    @required this.type,
    @required this.time,
  });

  factory LocalNotification.fromJson(Map<String, dynamic> data) => LocalNotification(
    id: data["id"],
    productId: data["product_id"],
      title: data["title"],
    // titleKr: data["title_kr"],
    // titleAr: data["title_ar"],
    body: data["body"],
    // bodyAr: data["body_kr"],
    // bodyAr: data["body_ar"],
    image: data["image"],
      type: data["type"],
    time: DateTime.parse(data["time"]),
 );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'product_id': productId,
        'title': title,
        // 'title_kr': titleKr,
        // 'title_ar': titleAr,
        'body': body,
        // 'body_kr': bodyAr,
        // 'body_ar': bodyAr,
        'type': type,
        'image': image,
        'time': time.toString(),
      };
}
