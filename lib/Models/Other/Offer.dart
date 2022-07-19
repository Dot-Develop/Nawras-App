// `id` bigint(20) UNSIGNED NOT NULL,
// `created_at` timestamp NULL DEFAULT NULL,
// `updated_at` timestamp NULL DEFAULT NULL

// "id": 7,
// "title": "offer2",
// "target": "all",
// "admin_id": 1,
// "product_id": 11,
// "class_a": 1,
// "class_b": 1,
// "class_c": 1,
// "class_d": 1,
// "class_a_single": 1,
// "class_b_single": 1,
// "class_c_single": "1.000",
// "class_d_single": 1,
// "start_date": "2021-01-02 00:00:00",
// "expire_date": "2021-01-05 00:00:00",
// "active_state": 1,
// "created_at": "2021-01-06 15:07:55",
// "updated_at": "2021-01-07 11:49:26"
import 'package:flutter/cupertino.dart';

class Offer {
  final int id;
  final String title;
  final String target;
  final String image;
  final String description;
  final int adminId;
  final int productId;
  final int classA;
  final int classB;
  final int classC;
  final int classD;
  final int classASingle;
  final int classBSingle;
  final int classCSingle;
  final int classDSingle;
  final DateTime startDate;
  final DateTime expireDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Offer(
      {@required this.id,
      @required this.title,
      @required this.target,
      @required this.image,
      @required this.description,
      @required this.adminId,
      @required this.productId,
      @required this.classA,
      @required this.classB,
      @required this.classC,
      @required this.classD,
      @required this.classASingle,
      @required this.classBSingle,
      @required this.classCSingle,
      @required this.classDSingle,
      @required this.startDate,
      @required this.expireDate,
      @required this.createdAt,
      @required  this.updatedAt
      }
      );

  factory Offer.fromJson(Map<String, dynamic> data) => Offer(
      id: data["id"],
      title: data["title"],
      target: data["target"],
       image: data["image"]?? "",
      description: data["description"]?? "",
      adminId: data["admin_id"],
      productId: data["product_id"],
      classA: data["class_a"]?? 0,
      classB: data["class_b"]?? 0,
      classC: data["class_c"]?? 0,
      classD: data["class_d"]?? 0,
      classASingle: data["class_a_single"]?? 0,
      classBSingle: data["class_b_single"]?? 0,
      classCSingle: data["class_c_single"]?? 0,
      classDSingle: data["class_d_single"]?? 0,
      startDate:DateTime.parse(data["start_date"]),
      expireDate:DateTime.parse(data["expire_date"]),
      createdAt:DateTime.parse(data["created_at"]),
      updatedAt:DateTime.parse(data["updated_at"])
      // startDate: data["start_date"],
      // expireDate: data["expire_date"],
      // createdAt: data["created_at"],
      // updatedAt: data["updated_at"]
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'target': target,
        'image': image,
        'description': description,
        'admin_id': adminId,
        'product_id': productId,
        'class_a': classA,
        'class_b': classB,
        'class_c': classC,
        'class_d': classD,
        'class_a_single': classASingle,
        'class_b_single': classBSingle,
        'class_c_single': classCSingle,
        'class_d_single': classDSingle,
        'start_date': startDate,
        'expire_date': expireDate,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
