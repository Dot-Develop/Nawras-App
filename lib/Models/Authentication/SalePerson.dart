// `id` bigint(20) UNSIGNED NOT NULL,
// `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `username` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `phone` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `car_number` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
// `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
// `status` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
// `image` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
// `zone_id` bigint(20) UNSIGNED NOT NULL,
// `login_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
// `active_state` tinyint(1) NOT NULL,
// `is_market` tinyint(1) NOT NULL,
// `created_at` timestamp NULL DEFAULT NULL,
// `updated_at` timestamp NULL DEFAULT NULL

import 'package:flutter/cupertino.dart';

class SalePerson {
  final int id;
  final String name;
  final String username;
  final String phone;
  final String email;
  final String carNumber;
  final String description;
  final String status;
  final String image;
  final int zoneId;
  final DateTime loginTime;
  final int activeState;
  final int isMarket;
  final DateTime createdAt;
  final DateTime updatedAt;

  SalePerson(
      {@required this.id,
      @required this.name,
      @required this.username,
      @required this.phone,
      @required this.email,
      @required this.carNumber,
      @required this.description,
      @required this.status,
      @required this.image,
      @required this.zoneId,
      @required this.loginTime,
      @required this.activeState,
      @required this.isMarket,
      @required this.createdAt,
      @required this.updatedAt});

  factory SalePerson.fromJson(Map<String, dynamic> data) => SalePerson(
      id: data["id"],
      name: data["name"],
      username: data["username"],
      phone: data["phone"],
      email: data["email"],
      carNumber: data["car_number"],
      description: data["description"],
      status: data["status"],
      image: data["image"],
      zoneId: data["zone_id"],
      loginTime: data["login_time"],
      activeState: data["active_state"],
      isMarket: data["is_market"],
      createdAt: data["created_at"],
      updatedAt: data["updated_at"]);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'username': username,
        'phone': phone,
        'email': email,
        'car_number': carNumber,
        'description': description,
        'status': status,
        'image': image,
        'zone_id': zoneId,
        'login_time': loginTime,
        'active_state': activeState,
        'is_market': isMarket,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
