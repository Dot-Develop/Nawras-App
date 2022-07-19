import 'package:flutter/material.dart';
import 'package:nawras_app/Helper/Links.dart';
import 'package:nawras_app/Helper/NawrasHttp.dart';
import 'package:nawras_app/Models/Categories/Category.dart';
import 'package:nawras_app/Models/Categories/SubCategory.dart';

class CategoryProvider extends ChangeNotifier {
  String getCatUrl = "$kHost/main_cats";
  String getSubCatUrl = "$kHost/sub_cats";

  List<dynamic> categoriesList = [];
  List<dynamic> subCategoriesList = [];

  Future<void> getCategory({String token}) async {
    var response = await postHTTP(url: getCatUrl, body: {
      'token': token,
    });
    if (response == null) {}
    categoriesList =
        response["main_cats"].map((data) => Category.fromJson(data)).toList();
    notifyListeners();
  }

  Future<void> getSubCategory({
    String token,
    String categoryId,
    String checked,
    int marketId,
    int salePersonId,
    bool pageLoading,
  }) async {
    try {
      var response = await postHTTP(url: getSubCatUrl, body: {
        'token': token,
        'category_id': categoryId,
        'checked': checked,
        'market_id': marketId,
        'sale_person_id': salePersonId,
      });
      if (response == null) {
        print("null");
      }

      subCategoriesList = response["sub_category"]
          .map((data) => SubCategory.fromJson(data))
          .toList();
    } catch (error) {
      // print(error);
    }
    subCategoryId = subCategoriesList[0].id;
    notifyListeners();
  }

  // sub category button state
  int subCategoryId;

  void setSubCategoryId(int id) {
    // print(id);
    subCategoryId = id;
    notifyListeners();
  }
}
