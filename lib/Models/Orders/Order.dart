// `id` bigint(20) UNSIGNED NOT NULL,
// `market_id` bigint(20) UNSIGNED NOT NULL,
// `sale_person_id` bigint(20) UNSIGNED NOT NULL,
// `who_order` int(11) NOT NULL,
// `status` int(11) NOT NULL,
// `note` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
// `final_time` timestamp NULL DEFAULT NULL,
// `area_id` bigint(20) UNSIGNED NOT NULL,
// `discount` double(8,2) DEFAULT NULL,
// `created_at` timestamp NULL DEFAULT NULL,
// `updated_at` timestamp NULL DEFAULT NULL

import 'package:flutter/cupertino.dart';

class Order {
  final int id;
  final int marketId;
  final String marketName;
  String status;
  final String note;
  final int areaId;
  final DateTime createdAt;
  final List<dynamic> items;

  Order({
    @required this.id,
    @required this.marketId,
    @required this.marketName,
    @required this.status,
    @required this.note,
    @required this.areaId,
    @required this.createdAt,
    @required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> data) => Order(
        id: data['id'],
        marketId: data['market_id'],
        marketName: data['market_name'],
        status: data['status'],
        note: data['note'],
        areaId: data['area_id'],
        createdAt: DateTime.parse(data['created_at']),
        items: data['items']
            .map((item) => SalePersonOrderItem.fromJson(item))
            .toList(),
      );
}

class SalePersonOrderItem {
  int sortId;
  String krName;
  String enName;
  String arName;
  String image;
  int productId;
  double price;
  int number;
  int zoneId;
  int offerId;

  SalePersonOrderItem({
    @required this.sortId,
    @required this.krName,
    @required this.enName,
    @required this.arName,
    @required this.image,
    @required this.productId,
    @required this.price,
    @required this.number,
    @required this.zoneId,
    @required this.offerId,
  });

  factory SalePersonOrderItem.fromJson(Map<String, dynamic> data) =>
      SalePersonOrderItem(
        sortId: data['sort_id'],
        krName: data['kurdish_name'],
        enName: data['english_name'],
        arName: data['arabic_name'],
        image: data['image'],
        productId: data['product_id'],
        price: data['price'].toDouble(),
        number: data['number'],
        zoneId: data['zone_id'],
        offerId: data['offer_id'],
      );
}
