// `id` bigint(20) UNSIGNED NOT NULL,
// `symbol` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `name_kr` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `name_ar` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `name_en` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `created_at` timestamp NULL DEFAULT NULL,
// `updated_at` timestamp NULL DEFAULT NULL

import 'package:flutter/cupertino.dart';

class  Unit {
  final int id;
  final String name;
  final String symbol;
  final DateTime createdAt;
  final DateTime updatedAt;

  Unit(
      {@required this.id,
      @required this.name,
      @required this.symbol,
        @required this.createdAt,
        @required this.updatedAt});

  factory  Unit.fromJson(Map<String, dynamic> data) =>  Unit(
      id: data["id"],
      name: data["name"],
      symbol: data["symbol"],
      createdAt: data["created_at"],
      updatedAt: data["updated_at"]);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'symbol': symbol,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
