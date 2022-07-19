import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Constants/CustomIcons.dart';
import 'package:nawras_app/GlobalWidgets/LoadingIndicator.dart';
import 'package:nawras_app/GlobalWidgets/RoundedButton.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Helper/LocationService.dart';
import 'package:nawras_app/Models/Orders/OrderItem.dart';
import 'package:nawras_app/Providers/AuthProvider.dart';
import 'package:nawras_app/Providers/OrderProvider.dart';
import 'package:provider/provider.dart';

class CartDrawer extends StatelessWidget {
  const CartDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final words = Provider.of<Language>(context).words;
    final auth = Provider.of<AuthProvider>(context);
    final location = Provider.of<LocationService>(context, listen: false);
    final token = auth.session.mainToken;
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    Map<String, int> login = {"salePersonId": 0, "marketId": 0};
    if (auth.loginTypeGlobal == "shop") {
      login["marketId"] = auth.shop.id;
    } else {
      login["salePersonId"] = auth.salePerson.id;
    }
    return Drawer(
      child: Stack(
        children: [
          Column(
            children: [
              AppBar(
                centerTitle: false,
                title: Text(
                  words["cart"],
                  style: AppTextStyle.boldTitle18
                      .copyWith(color: PaletteColors.whiteBg),
                ),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.add,
                      color: PaletteColors.mainAppColor,
                    ),
                  ),
                  if (orderProvider.shopId != 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Chip(
                        backgroundColor: PaletteColors.cardColorApp,
                        label: Text(
                          orderProvider.shopDetailsOrder.name ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.lightTitle14.copyWith(
                            color: PaletteColors.redColorApp,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Expanded(
                child: FutureBuilder(
                  future: Provider.of<OrderProvider>(context, listen: false)
                      .getOrderItemsFromLocal(login["salePersonId"] != 0),
                  builder: (context, snapshot) => snapshot.connectionState ==
                          ConnectionState.waiting
                      ? LoadingIndicator()
                      : Consumer<OrderProvider>(
                          builder: (_, order, __) =>
                              order.listOrderItemsCart.length == 0
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        getAppIcons(
                                            asset: AppIcons.shopEmpty,
                                            color: PaletteColors.blackIconAppBar
                                                .withOpacity(0.4),
                                            size: 90),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(words["cart-empty"],
                                            style: AppTextStyle.boldTitle16
                                                .copyWith(
                                                    color: PaletteColors
                                                        .blackIconAppBar
                                                        .withOpacity(0.4))),
                                      ],
                                    )
                                  : ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount:
                                          order.listOrderItemsCart.length + 1,
                                      itemBuilder:
                                          (context, index) =>
                                              index ==
                                                      order.listOrderItemsCart
                                                          .length
                                                  ? Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10,
                                                          vertical: 15),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          RoundedButton(
                                                            title: words["buy"],
                                                            onPressed: () =>
                                                                showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      AlertDialog(
                                                                content: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Text(
                                                                      words[
                                                                          'buying-these-products'],
                                                                      style: AppTextStyle
                                                                          .boldTitle16
                                                                          .copyWith(
                                                                              color: PaletteColors.redColorApp),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            15),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        RoundedButton(
                                                                          onPressed: () =>
                                                                              Navigator.pop(context),
                                                                          title:
                                                                              words['cancel'],
                                                                          isThikHeight:
                                                                              true,
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 5),
                                                                          child:
                                                                              RoundedButton(
                                                                            color:
                                                                                PaletteColors.greenColorApp,
                                                                            onPressed:
                                                                                () async {
                                                                              Navigator.pop(context);
                                                                              login["salePersonId"] == 0
                                                                                  ? await order.buyOrderProduct(
                                                                                      orderItems: order.listOrderItemsCart,
                                                                                      token: token,
                                                                                    )
                                                                                  : await order.buyOrderProduct(
                                                                                      orderItems: order.listOrderItemsCart,
                                                                                      token: token,
                                                                                      marketId: order.shopDetailsOrder.id,
                                                                                      lat: location.lat,
                                                                                      lng: location.lng,
                                                                                    );
                                                                              Fluttertoast.showToast(
                                                                                backgroundColor: PaletteColors.greenColorApp,
                                                                                msg: words['the-order-was-successful'],
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                gravity: ToastGravity.BOTTOM,
                                                                              );
                                                                            },
                                                                            title:
                                                                                words['buy'],
                                                                            isThikHeight:
                                                                                true,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            isThikHeight: true,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : CartCard(
                                                      orderItem: order
                                                              .listOrderItemsCart[
                                                          index],
                                                      orderProvider: order,
                                                    ),
                                    ),
                        ),
                ),
              ),
            ],
          ),
          Consumer<OrderProvider>(
            builder: (_, orderProvider, __) => orderProvider.buyOrdersLoading
                ? Container(
                    color: Colors.black26,
                    alignment: Alignment.center,
                    child: LoadingIndicator())
                : SizedBox(),
          )
        ],
      ),
    );
  }
}

class CartCard extends StatelessWidget {
  final OrderItem orderItem;
  final OrderProvider orderProvider;

  const CartCard(
      {Key key, @required this.orderItem, @required this.orderProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final language = Provider.of<Language>(context);
    final words = language.words;
    final languageCode = language.languageCode;
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Image.network(
                orderItem.image,
                width: 50,
                height: 50,
                // loadingBuilder: (BuildContext context, Widget child,
                //     ImageChunkEvent loadingProgress) {
                //   if (loadingProgress == null) return child;
                //   return ImageLoadingIndicator();
                // },
              ),
              title: Text(
                languageCode == 'kr'
                    ? orderItem.productKrName
                    : languageCode == 'en'
                        ? orderItem.productEnName
                        : orderItem.productArName ?? '',
              ),
              subtitle: Text(
                  '${words["total-price"]} ${orderItem.price * orderItem.number}'),
              trailing: IconButton(
                icon: getAppIcons(
                    asset: AppIcons.bin, color: PaletteColors.darkRedColorApp),
                onPressed: () {
                  orderProvider.removeItemToCart(orderItem.id);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: PaletteColors.cardColorApp),
                      borderRadius: BorderRadius.circular(40)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        child: Icon(Icons.add,
                            color: PaletteColors.blackIconAppBar),
                        onTap: () {
                          orderProvider.operationOnNumberOrderCart(
                              orderItem.id, 'add');
                        },
                      ),
                      SizedBox(width: 5),
                      Text(orderItem.number.toString()),
                      SizedBox(width: 5),
                      GestureDetector(
                        child: Icon(Icons.remove,
                            color: PaletteColors.blackIconAppBar),
                        onTap: () {
                          orderProvider.operationOnNumberOrderCart(
                              orderItem.id, 'remove');
                        },
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  child: Text(
                    words["reset"],
                    style: AppTextStyle.regularTitle14
                        .copyWith(color: PaletteColors.darkRedColorApp),
                  ),
                  onPressed: () {
                    orderProvider.operationOnNumberOrderCart(
                        orderItem.id, 'reset');
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
