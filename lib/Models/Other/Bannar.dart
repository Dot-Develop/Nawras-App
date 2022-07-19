// `id` bigint(20) UNSIGNED NOT NULL,
// `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `image_kr` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `image_ar` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `image_en` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `links` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `value` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `sort` int(11) DEFAULT NULL,
// `created_at` timestamp NULL DEFAULT NULL,
// `updated_at` timestamp NULL DEFAULT NULL

import 'package:flutter/cupertino.dart';

class Bannar {
  final int id;
  final String title;
  final String image;
  final String links;
  final String type;
  final String value;
  final int sort;
  final DateTime createdAt;
  final DateTime updatedAt;

  Bannar(
      {@required this.id,
        @required this.title,
        @required this.image,
        @required this.links,
        @required this.type,
        @required this.value,
        @required this.sort,
        @required this.createdAt,
        @required this.updatedAt});

  factory Bannar.fromJson(Map<String, dynamic> data) => Bannar(
      id: data["id"],
      title: data["title"],
      image: data["image"],
      links: data["links"],
      type: data["type"],
      value: data["value"],
      sort: data["sort"],
      createdAt: data["created_at"],
      updatedAt: data["updated_at"]);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'title': title,
    'image': image,
    'links': links,
    'type': type,
    'value': value,
    'sort': sort,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
