// `id` bigint(20) UNSIGNED NOT NULL,
// `order_id` bigint(20) UNSIGNED NOT NULL,
// `market_id` bigint(20) UNSIGNED NOT NULL,
// `sale_person_id` bigint(20) UNSIGNED NOT NULL,
// `product_id` bigint(20) UNSIGNED NOT NULL,
// `number` int(11) NOT NULL,
// `price` double(8,2) NOT NULL,
// `orginal_number` int(11) NOT NULL,
// `orginal_price` double(8,2) NOT NULL,
// `status` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
// `zone_id` bigint(20) UNSIGNED NOT NULL,
// `offer_id` bigint(20) UNSIGNED NOT NULL,
// `created_at` timestamp NULL DEFAULT NULL,
// `updated_at` timestamp NULL DEFAULT NULL

import 'package:flutter/cupertino.dart';

class OrderItem {
  final String id;
  final int productId;
  final String image;
  final String productKrName;
  final String productEnName;
  final String productArName;
  int number;
  double price;
  final double originalPrice;

  OrderItem({
    @required this.id,
    @required this.productId,
    @required this.image,
    @required this.productKrName,
    @required this.productEnName,
    @required this.productArName,
    @required this.number,
    @required this.price,
    @required this.originalPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> data) => OrderItem(
        id: data['id'],
        productId: data['product_id'],
        image: data['image'],
        productKrName: data['product_kr_name'],
        productEnName: data['product_en_name'],
        productArName: data['product_ar_name'],
        number: data['number'],
        price: data['price'],
        originalPrice: data['original_price'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'product_kr_name': productKrName,
        'product_en_name': productEnName,
        'product_ar_name': productArName,
        'product_id': productId,
        'number': number,
        'price': price,
        'original_price': originalPrice,
      };
}
