// `id` bigint(20) UNSIGNED NOT NULL,
// `name_kr` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `name_ar` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `name_en` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `image` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
// `created_at` timestamp NULL DEFAULT NULL,
// `updated_at` timestamp NULL DEFAULT NULL

import 'package:flutter/cupertino.dart';

class Category {
  final int id;
  final String krName;
  final String enName;
  final String arName;
  final String image;
  final DateTime createdAt;

  // final DateTime updated_at;

  Category({
    @required this.id,
    @required this.krName,
    @required this.enName,
    @required this.arName,
    @required this.image,
    @required this.createdAt,
    // @required this.updated_at
  });

  factory Category.fromJson(Map<String, dynamic> data) => Category(
        id: data["id"],
        krName: data["kurdish_name"],
        enName: data["english_name"],
        arName: data["arabic_name"],
        image: data["image"],
        createdAt: DateTime.parse(data["created_at"]),
        // updated_at: DateTime.parse(data["updated_at"])
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'kurdish_name': krName,
        'english_name': enName,
        'arabic_name': arName,
        'image': image,
        'created_at': createdAt,
        // 'updated_at': updated_at,
      };
}
