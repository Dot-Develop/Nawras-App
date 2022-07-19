import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nawras_app/Helper/Links.dart';
import 'package:nawras_app/Helper/NawrasHttp.dart';
import 'package:nawras_app/Models/Orders/Product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductProvider extends ChangeNotifier {
  String getAllProductUrl = "$kHost/all_products";
  String getProductByIdUrl = "$kHost/products";
  String getAddToFavoriteUrl = "$kHost/favorite";

  List<dynamic> allProductsList = [];
  List<Product> allProductsFavoriteList = [];
  List<dynamic> allFavoritesList = [];

  String checkedSelection = 'all';
  bool isLoading = false;

  void setCheckedSelection(String value) {
    checkedSelection = value;
    notifyListeners();
  }

  Future<void> getAllProduct({
    int salePersonId,
    int marketId,
    String token,
  }) async {
    isLoading = true;
    notifyListeners();
    var response = await postHTTP(url: getAllProductUrl, body: {
      'sale_person_id': salePersonId,
      'market_id': marketId,
      'checked': checkedSelection,
      'token': token,
    });

    if (response == null) {}

    allProductsList =
        response["products"].map((data) => Product.fromJson(data)).toList();
    searchItems = allProductsList;
    isLoading = false;
    notifyListeners();
  }

  List<dynamic> _getAllProductCategoryList = [];
  List<dynamic> getAllProductCategoryFilter = [];

  // bool _isLoading = false;

  Future<void> getAllProductCategory(
      {int salePersonId,
      int marketId,
      String token,
      int subCategoryId,
      String language}) async {
    // if (_isLoading) return;
    if (_getAllProductCategoryList.isNotEmpty) return;
    var response = await postHTTP(
        url: 'https://dang-voip.net/nawras/public/api/all_products',
        body: {
          'sale_person_id': salePersonId,
          'market_id': marketId,
          'checked': 'all',
          'language': language,
          'token': token,
        });

    try {
      _getAllProductCategoryList =
          response["products"].map((data) => Product.fromJson(data)).toList();
    } catch (error) {
      print(error);
    }

    getAllProductCategoryFilter = _getAllProductCategoryList;
    productCategoryFilter(categoryId: subCategoryId);
    // _isLoading = true;
  }

  void productCategoryFilter({@required int categoryId}) {
    _getAllProductCategoryList.forEach((element) {});

    getAllProductCategoryFilter = _getAllProductCategoryList.where((product) {
      return product.subId == categoryId;
    }).toList();
    notifyListeners();
  }

  List<dynamic> searchItems = [];

  void searchProduct(String text) {
    searchItems = allProductsList.where((b) {
      return b.name.contains(text);
    }).toList();

    notifyListeners();
  }

  // void addAndRemoveProductToFavorite({
  //   int salePersonId,
  //   int marketId,
  //   int productId,
  //   String token,
  // }) async {
  //   var response = await postHTTP(url: getAddToFavoriteUrl, body: {
  //     'sale_person_id': salePersonId,
  //     'market_id': marketId,
  //     'product_id': productId,
  //     'token': token,
  //   });
  //   // print(response);
  //
  //   if (response == null) {
  //     print("Response is null");
  //   }
  // }
  //
  // Future<void> getAllFavorites({
  //   int salePersonId,
  //   int marketId,
  //   String token,
  // }) async {
  //   var response = await postHTTP(url: getAllProductUrl, body: {
  //     'sale_person_id': salePersonId,
  //     'market_id': marketId,
  //     'checked': "all",
  //     'language': language,
  //     'token': token,
  //   });
  //   print(response["products"]);
  //
  //   if (response == null) {
  //     // return false;
  //   }
  //
  //   allProductsList =
  //       response["products"].map((data) => Product.fromJson(data)).toList();
  //   allFavoritesList =
  //       allProductsList.where((element) => element.isFavorite == 1).toList();
  // }

  bool isFavoriteInSharedPreferences({Product product}) {
    var isContain =
        allProductsFavoriteList.where((element) => element.id == product.id);
    if (isContain.isEmpty)
      return false;
    else
      return true;
  }

  Future<void> addFavoritesSharedPreferences({Product product}) async {
    allProductsFavoriteList.add(product);
    setFavoritesSharedPreferences();
    notifyListeners();
    print("added");
  }

  Future<void> removeFavoritesSharedPreferences({Product product}) async {
    allProductsFavoriteList.removeWhere((element) => product.id == element.id);
    setFavoritesSharedPreferences();
    notifyListeners();
  }

  Future<void> getAllFavoritesSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('favoriteMap');
    if (data == null) {
      allProductsFavoriteList = [];
      return;
    }
    List favorite = jsonDecode(data) ?? [];
    try {
      allProductsFavoriteList =
          favorite.map((product) => Product.fromJson(product)).toList();
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }

  Future<void> setFavoritesSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        'favoriteMap', json.encode(allProductsFavoriteList));
  }
}
