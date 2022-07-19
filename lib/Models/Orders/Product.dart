import 'package:flutter/cupertino.dart';

class Product {
  final int id;
  final String krName;
  final String enName;
  final String arName;
  final String krUnitName;
  final String enUnitName;
  final String arUnitName;
  final String krDescription;
  final String enDescription;
  final String arDescription;
  final String image;
  final int subId;
  final String storeCode;
  final int quantity;
  final String weight;
  final String packageWeight;
  final int unitId;
  final int packageCount;
  final double price;
  final double originalPrice;
  final double priceA;
  final double priceB;
  final double priceC;
  final double priceD;
  final int isFavorite;
  final int brandId;
  final DateTime expirationDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product(
      {@required this.id,
      @required this.krName,
      @required this.enName,
      @required this.arName,
      @required this.krDescription,
      @required this.enDescription,
      @required this.arDescription,
      @required this.krUnitName,
      @required this.enUnitName,
      @required this.arUnitName,
      @required this.image,
      @required this.subId,
      @required this.storeCode,
      @required this.quantity,
      @required this.weight,
      @required this.packageWeight,
      @required this.unitId,
      @required this.packageCount,
      @required this.price,
      @required this.priceA,
      @required this.priceB,
      @required this.priceC,
      @required this.priceD,
      @required this.originalPrice,
      @required this.isFavorite,
      @required this.brandId,
      @required this.expirationDate,
      @required this.createdAt,
      @required this.updatedAt});

  factory Product.fromJson(Map<String, dynamic> data) => Product(
      id: data["productId"],
      krName: data["kudish_name"],
      enName: data["english_name"],
      arName: data["arabic_name"],
      krDescription: data["kr_description"],
      enDescription: data["en_description"],
      arDescription: data["ar_description"],
      krUnitName: data["kurdish_unit_name"],
      enUnitName: data["english_unit_name"],
      arUnitName: data["arabic_unit_name"],
      image: data["image"],
      subId: data["sub_id"],
      storeCode: data["store_code"],
      quantity: data["quantity"],
      weight: data["weight"],
      packageWeight: data["package_weight"],
      unitId: data["unit_id"],
      packageCount: data["package_count"],
      price: data["price"] == null ? 0.0 : data["price"].toDouble(),
      priceA: data["price_a"] == null ? 0.0 : data["price_a"].toDouble(),
      priceB: data["price_b"] == null ? 0.0 : data["price_a"].toDouble(),
      priceC: data["price_c"] == null ? 0.0 : data["price_a"].toDouble(),
      priceD: data["price_d"] == null ? 0.0 : data["price_a"].toDouble(),
      isFavorite: data["is_favorite"],
      originalPrice: data["orginal_price"] == null
          ? 0.0
          : data["orginal_price"].toDouble(),
      brandId: data["brand_id"],
      expirationDate: DateTime.parse(data["expiration_date"]),
      createdAt: data["created_at"],
      updatedAt: data["updated_at"]);

  Map<String, dynamic> toJson() => {
        'productId': id,
        'kudish_name': krName,
        'english_name': enName,
        'arabic_name': arName,
        'kr_description': krDescription,
        'en_description': enDescription,
        'ar_description': arDescription,
        'kurdish_unit_name': krUnitName,
        'arabic_unit_name': enUnitName,
        'english_unit_name': arUnitName,
        'image': image,
        'sub_id': subId,
        'store_code': storeCode,
        'quantity': quantity,
        'weight': weight,
        'package_weight': packageWeight,
        'unit_id': unitId,
        'package_count': packageCount,
        'price': price,
        'is_favorite': isFavorite,
        'orginal_price': originalPrice,
        'brand_id': brandId,
        'expiration_date': expirationDate.toString(),
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
