// `id` bigint(20) UNSIGNED NOT NULL,
// `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `username` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `phone` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
// `image` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
// `lat` double(8,2) DEFAULT NULL,
// `lng` double(8,2) DEFAULT NULL,
// `status` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
// `active_state` tinyint(1) NOT NULL,
// `area_id` bigint(20) UNSIGNED NOT NULL,
// `sale_person_id` bigint(20) UNSIGNED NOT NULL,
// `login_time` timestamp NULL DEFAULT NULL,
// `register_by` bigint(20) UNSIGNED NOT NULL,
// `discount` double(8,2) DEFAULT NULL,
// `change_location_sale_person` int(11) DEFAULT NULL,
// `price_class` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
// `market_cat` int(11) NOT NULL,
// `created_at` timestamp NULL DEFAULT NULL,
// `updated_at` timestamp NULL DEFAULT NULL

import 'package:flutter/cupertino.dart';

class Shop {
  final int id;
  final String name;
  final String username;
  final String password;
  final String phone;
  final String description;
  final String image;
  final String lat;
  final String lng;
  final String status;
  final int activeState;
  final int areaId;
  final int salePersonId;
  final DateTime loginTime;
  final int registerBy;
  final double discount;
  final int changeLocationSalePerson;
  final String priceClass;
  final int marketCat;
  final DateTime createdAt;
  final DateTime updatedAt;

  Shop(
      {@required this.id,
      @required this.name,
      @required this.username,
      @required this.password,
      @required this.phone,
      @required this.description,
      @required this.image,
      @required this.lat,
      @required this.lng,
      @required this.status,
      @required this.activeState,
      @required this.areaId,
      @required this.salePersonId,
      @required this.loginTime,
      @required this.registerBy,
      @required this.discount,
      @required this.changeLocationSalePerson,
      @required this.priceClass,
      @required this.marketCat,
      @required this.createdAt,
      @required this.updatedAt});

  factory Shop.fromJson(Map<String, dynamic> data) => Shop(
      id: data["id"],
      name: data["name"],
      username: data["username"],
      password: data["password"],
      phone: data["phone"],
      description: data["description"],
      image: data["image"] ?? "",
      lat: data["lat"],
      lng: data["lng"],
      status: data["status"],
      activeState: data["active_state"],
      areaId: data["area_id"],
      salePersonId: data["sale_person_id"],
      loginTime: data["login_time"],
      registerBy: data["register_by"],
      discount: data["discount"],
      changeLocationSalePerson: data["change_location_sale_person"],
      priceClass: data["price_class"] ?? "UNKNOWN",
      marketCat: data["market_cat"],
      createdAt: data["created_at"],
      updatedAt: data["updated_at"]);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'username': username,
        'password': password,
        'phone': phone,
        'description': description,
        'image': image,
        'lat': lat,
        'lng': lng,
        'status': status,
        'active_state': activeState,
        'area_id': areaId,
        'sale_person_id': salePersonId,
        'login_time': loginTime,
        'register_by': registerBy,
        'discount': discount,
        'change_location_sale_person': changeLocationSalePerson,
        'price_class': priceClass,
        'market_cat': marketCat,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
