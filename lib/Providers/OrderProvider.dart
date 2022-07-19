import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:nawras_app/Helper/Links.dart';
import 'package:nawras_app/Helper/NawrasHttp.dart';
import 'package:nawras_app/Models/Orders/Order.dart';
import 'package:nawras_app/Models/Orders/OrderItem.dart';
import 'package:nawras_app/Models/Orders/ShopDetailsOrder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider with ChangeNotifier {
  String buyOrderProductUrl = "$kHost/market_order";
  String acceptedOrRejectOrderUrl = "$kHost/sale_person_order_action";
  String salePersonShopUrl = "$kHost/get_my_markets";
  String salePersonOrderMarketUrl = "$kHost/sale_person_order";
  String marketOrderUrl = "$kHost/market_order";

  List<OrderItem> listOrderItemsCart = [];
  bool isExistInCart = false;
  bool buyOrdersLoading = false;
  String orderIsSuccess = '';

  void addItemToCart(OrderItem orderItem, bool dataSaveFromLocal) {
    isExistInCart = false;
    notifyListeners();

    listOrderItemsCart.add(orderItem);
    if (dataSaveFromLocal) {
      saveOrderItemsInLocal();
    }
    notifyListeners();
  }

  bool checkOrderList(productId) {
    if (listOrderItemsCart.isNotEmpty) {
      var list = listOrderItemsCart
          .where((element) => element.productId == productId)
          .toList();
      if (list.isNotEmpty) {
        isExistInCart = true;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  void removeAllItemsInCart() {
    listOrderItemsCart.clear();
    saveOrderItemsInLocal();
    notifyListeners();
  }

  void removeItemToCart(String orderItemId) {
    listOrderItemsCart.removeWhere((order) => order.id == orderItemId);
    saveOrderItemsInLocal();
    notifyListeners();
  }

  void operationOnNumberOrderCart(String orderItemId, String typeOperation) {
    listOrderItemsCart.forEach((element) {
      if (element.id == orderItemId) {
        if (typeOperation == 'add') {
          element.number++;
        } else if (typeOperation == 'remove') {
          element.number--;
        } else if (typeOperation == 'reset') {
          element.number = 1;
        }
      }
    });
    saveOrderItemsInLocal();
    notifyListeners();
  }

  Future<void> buyOrderProduct({
    @required List<OrderItem> orderItems,
    @required String token,
    double lat,
    double lng,
    int marketId,
  }) async {
    buyOrdersLoading = true;
    orderIsSuccess = '';
    notifyListeners();
    Map<String, dynamic> orders = {};
    for (int i = 0; orderItems.length > i; i++) {
      orders[(i).toString()] = {
        "product_id": orderItems[i].productId,
        "quantity": orderItems[i].number,
        "price": orderItems[i].price,
        "o_price": 123,
      };
    }

    final Map<String, dynamic> body = marketId == null
        ? {
            "token": token,
            "items": orders,
            "note": "shty chakm bo benn",
          }
        : {
            "token": token,
            "items": orders,
            "note": "shty chakm bo benn",
            'lat': lat.toString(),
            'lng': lng.toString(),
            'market_id': marketId
          };

    final response = await postHTTP(
        body: body,
        url: marketId == null ? marketOrderUrl : salePersonOrderMarketUrl);

    if (response == null) {
      orderIsSuccess = 'notSuccess';
      buyOrdersLoading = false;
      notifyListeners();
      return;
    }

    listOrderItemsCart.clear();
    saveOrderItemsInLocal();
    buyOrdersLoading = false;
    orderIsSuccess = 'success';
    notifyListeners();
  }

  List allOrdersList;
  List filterAllOrdersList;

  bool getAllOrdersLoading = false;

  Future<void> getAllOrders({@required token}) async {
    getAllOrdersLoading = true;
    notifyListeners();
    final response = await postHTTP(
      url: 'https://dang-voip.net/nawras/public/api/get_order_list',
      body: {"token": token},
    );
    // try {
    allOrdersList =
        response['order_lists'].map((e) => Order.fromJson(e)).toList();
    // }catch(e){
    //   print(e);
    // }
    filterAllOrdersList = allOrdersList;
    filterAllOrdersList =
        allOrdersList.where((order) => order.status == 'new').toList();
    getAllOrdersLoading = false;
    notifyListeners();
  }

  void filterAllOrders({@required String status}) {
    filterAllOrdersList =
        allOrdersList.where((order) => order.status == status).toList();

    notifyListeners();
  }

  List allMarketOrders = [];

  Future<void> getAllMarketOrders({@required token}) async {
    print('response');
    final response = await postHTTP(
      url: 'https://dang-voip.net/nawras/public/api/market_orders_list',
      body: {"token": token},
    );

    try {
      allMarketOrders =
          response['order_lists'].map((e) => Order.fromJson(e)).toList();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  void operationOnSalePersonListOrder(
      {@required int orderId,
      @required int sortId,
      @required String typeOperation}) {
    Order order = allOrdersList.firstWhere((order) => order.id == orderId);

    order.items.forEach((orderItem) {
      if (orderItem.sortId == sortId) {
        if (typeOperation == 'add') {
          orderItem.number++;
        } else if (typeOperation == 'remove') {
          orderItem.number--;
        } else if (typeOperation == 'reset') {
          orderItem.number = 0;
        }
      }
    });
    notifyListeners();
  }

  bool acceptedOrRejectOrderLoading = false;

  Future<void> acceptedOrRejectOrder({
    @required String token,
    @required String status,
    @required Order order,
    @required double lat,
    @required double lng,
  }) async {
    acceptedOrRejectOrderLoading = true;
    notifyListeners();
    List orders = List.generate(
        order.items.length,
        (index) => {
              "sort_id": order.items[index].sortId,
              "quantity": order.items[index].number,
            });

    await postHTTP(
      url: acceptedOrRejectOrderUrl,
      body: {
        "token": token,
        "status": status,
        "order_id": order.id,
        "lat": lat,
        "lng": lng,
        "items": orders,
      },
    );

    await getAllOrders(token: token);
    acceptedOrRejectOrderLoading = false;
    notifyListeners();
  }

  List listSalePersonShops = [];

  Future<void> getSalePersonShops({String token}) async {
    if (listSalePersonShops.isNotEmpty) return;
    final response =
        await postHTTP(body: {'token': token}, url: salePersonShopUrl);
    listSalePersonShops = response['market_list']
        .map((order) => ShopDetailsOrder.fromJson(order))
        .toList();
    print(response);
    return listSalePersonShops;
  }

  int shopId = 0;
  ShopDetailsOrder shopDetailsOrder;

  void changeShopId({@required id, @required shopDetail}) {
    if (shopId == id) {
      shopId = 0;
      shopDetailsOrder = null;
    } else {
      shopId = id;
      shopDetailsOrder = shopDetail;
    }
    notifyListeners();
  }

  Future<void> saveOrderItemsInLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('orders', jsonEncode(listOrderItemsCart));
  }

  Future<void> getOrderItemsFromLocal(bool isSalePerson) async {
    if (!isSalePerson) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List orderItems = jsonDecode(prefs.getString('orders')) ?? [];
      try {
        listOrderItemsCart =
            orderItems.map((order) => OrderItem.fromJson(order)).toList();
      } catch (error) {
        print(error);
      }
      notifyListeners();
    }
  }
}
