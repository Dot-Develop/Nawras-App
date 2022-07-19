import 'package:flutter/cupertino.dart';

// class ShopDetailsOrder {
//   final int id;
//   final String name;
//   final String phone;
//   final double discount;
//   final String shopClass;
//
//   ShopDetailsOrder({
//     @required this.id,
//     @required this.name,
//     @required this.phone,
//     @required this.discount,
//     @required this.shopClass,
//   });
//
//   factory ShopDetailsOrder.fromJson(Map<String, dynamic> data) =>
//       ShopDetailsOrder(
//         id: data['id'],
//         name: data['name'],
//         phone: data['phone'],
//         discount: data['discount'].toDouble(),
//         shopClass: data['class'],
//       );
// }

class  ShopDetailsOrder {
  final int id;
  final String name;
  final String phone;
  final String image;
  final double discount;
  final String shopClass;

  ShopDetailsOrder(
      {@required this.id,
        @required this.name,
        @required this.phone,
        @required this.image,
        @required this.discount,
        @required this.shopClass});

  factory  ShopDetailsOrder.fromJson(Map<String, dynamic> data) =>  ShopDetailsOrder(
      id: data["id"],
      name: data["name"],
      phone: data["phone"],
      image: data["image"],
      discount: data["discount"],
      shopClass: data["class"]);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'phone': phone,
    'image': image,
    'discount': discount,
    'class': shopClass,
  };
}
