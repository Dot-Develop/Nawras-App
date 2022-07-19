import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/GlobalWidgets/Direction.dart';
import 'package:nawras_app/GlobalWidgets/RoundedButton.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Models/Orders/OrderItem.dart';
import 'package:nawras_app/Models/Orders/Product.dart';
import 'package:nawras_app/Providers/AuthProvider.dart';
import 'package:nawras_app/Providers/OrderProvider.dart';
import 'package:nawras_app/Providers/ProductProvider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:nawras_app/GlobalWidgets/LoadingIndicator.dart';

class DetailsProductScreen extends StatelessWidget {
  bool isFav;

  @override
  Widget build(BuildContext context) {
    final language = Provider.of<Language>(context);
    final words = language.words;
    final languageCode = language.languageCode;
    Product product = ModalRoute.of(context).settings.arguments;
    final productAuth = Provider.of<ProductProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    int number = 1;
    isFav = productAuth.isFavoriteInSharedPreferences(product: product);
    Map<String, int> login = {"salePersonId": 0, "marketId": 0};
    bool isMarket = false;
    if (auth.loginTypeGlobal == "shop") {
      login["marketId"] = auth.shop.id;
      isMarket = true;
    } else {
      login["salePersonId"] = auth.salePerson.id;
    }
    double marketProductPrice;
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    if (login["salePersonId"] != 0 && orderProvider.shopId != 0)
      switch (orderProvider.shopDetailsOrder.shopClass) {
        case 'a':
          marketProductPrice = product.priceA;
          break;
        case 'b':
          marketProductPrice = product.priceB;
          break;
        case 'c':
          marketProductPrice = product.priceC;
          break;
        case 'd':
          marketProductPrice = product.priceD;
          break;
      }
    return Direction(
      child: Scaffold(
        appBar: AppBar(
          title: Text(words["details-product"]),
          actions: [
            IconButton(
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_outline),
              onPressed: () {
                if (isFav) {
                  productAuth.removeFavoritesSharedPreferences(
                      product: product);
                } else {
                  productAuth.addFavoritesSharedPreferences(product: product);
                }
              },
            ),
          ],
        ),
        body: StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) =>
                  ListView(
            padding: EdgeInsets.all(10),
            children: [
              Image.network(
                product.image,
                fit: BoxFit.contain,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return ImageLoadingIndicator();
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: Text(
                      languageCode == 'kr'
                          ? product.krName
                          : languageCode == 'en'
                              ? product.enName
                              : product.arName,
                      style: AppTextStyle.boldTitle24
                          .copyWith(color: PaletteColors.mainAppColor),
                      maxLines: 2,
                    ),
                  ),
                  if (orderProvider.shopId != 0 || isMarket)
                    Container(
                      margin: EdgeInsets.only(top: 5, left: 2),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: PaletteColors.darkRedColorApp),
                          borderRadius: BorderRadius.circular(40)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            child: Icon(Icons.add,
                                color: PaletteColors.darkRedColorApp),
                            onTap: () {
                              setState(() {
                                number++;
                              });
                            },
                          ),
                          SizedBox(width: 5),
                          Text(
                            number.toStringAsFixed(0),
                            style: AppTextStyle.regularTitle14
                                .copyWith(color: PaletteColors.darkRedColorApp),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            child: Icon(Icons.remove,
                                color: PaletteColors.darkRedColorApp),
                            onTap: () {
                              setState(() {
                                if (number > 1) number--;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              detailRow(words["price"], "\$${product.price}"),
              detailRow(words["expire-date"],
                  DateFormat.yMd().format(product.expirationDate)),
              detailRow(words["weight"], product.weight.toString()),
              detailRow(words["package-weight"], product.packageWeight),
              SizedBox(
                height: 30,
              ),
              if (orderProvider.shopId != 0 || isMarket)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      child: RoundedButtonDD(
                        title: words["cancel"],
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        height: 40.0,
                      ),
                    ),
                    Consumer<OrderProvider>(
                      builder: (_, orderProvider, __) => SizedBox(
                        width: 120,
                        child: RoundedButtonDD(
                          height: 40.0,
                          title: words["add-to-card"],
                          onPressed: () {
                            if (orderProvider.checkOrderList(product.id)) {
                              Fluttertoast.showToast(
                                backgroundColor: PaletteColors.blackIconAppBar,
                                msg: words["product-already-order"],
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                              return;
                            }
                            orderProvider.addItemToCart(
                                OrderItem(
                                  id: Uuid().v1(),
                                  image: product.image,
                                  productKrName: product.krName,
                                  productEnName: product.enName,
                                  productArName: product.arName,
                                  productId: product.id,
                                  number: number.toInt(),
                                  originalPrice: login["salePersonId"] == 0
                                      ? product.originalPrice
                                      : marketProductPrice,
                                  price: login["salePersonId"] == 0
                                      ? product.price
                                      : marketProductPrice * (2 - 1),
                                ),
                                login["marketId"] != 0);
                            Fluttertoast.showToast(
                              backgroundColor: PaletteColors.greenColorApp,
                              msg: words["add-to-your-a-cart"],
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  detailRow(String title, String price) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: AppTextStyle.boldTitle18
              .copyWith(color: PaletteColors.blackAppColor),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          price,
          style: AppTextStyle.regularTitle16
              .copyWith(color: PaletteColors.blackAppColor),
        ),
        Divider(
          thickness: 0.4,
          color: PaletteColors.blackAppColor.withOpacity(0.3),
        ),
      ],
    );
  }
}
