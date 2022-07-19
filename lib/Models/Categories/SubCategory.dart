import 'package:flutter/cupertino.dart';

class SubCategory {
  final int id;
  final String krName;
  final String enName;
  final String arName;
  final int mainCatId;
  final DateTime createdAt;

  SubCategory({
    @required this.id,
    @required this.krName,
    @required this.enName,
    @required this.arName,
    @required this.mainCatId,
    @required this.createdAt,
  });

  factory SubCategory.fromJson(Map<String, dynamic> data) => SubCategory(
      id: data["id"],
      krName: data["kurdish_name"],
      enName: data["english_name"],
      arName: data["arabic_name"],
      mainCatId: data["main_cat_id"],
      createdAt: data["created_at"]);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'kurdish_name': krName,
        'english_name': enName,
        'arabic_name': arName,
        'main_cat_id': mainCatId,
        'created_at': createdAt,
      };
}
