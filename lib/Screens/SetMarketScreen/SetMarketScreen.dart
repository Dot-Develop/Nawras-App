import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/GlobalWidgets/Direction.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Providers/AuthProvider.dart';
import 'package:nawras_app/Providers/OrderProvider.dart';
import 'package:provider/provider.dart';
import 'package:nawras_app/GlobalWidgets/LoadingIndicator.dart';

class SetMarketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final language = Provider.of<Language>(context, listen: false);
    final words = language.words;
    final languageCode = language.languageCode;
    final token =
        Provider.of<AuthProvider>(context, listen: false).session.mainToken;
    return Direction(
      child: Scaffold(
        appBar: AppBar(
          title: Text(words["shop-list"]),
        ),
        body: FutureBuilder(
          future: Provider.of<OrderProvider>(context, listen: false)
              .getSalePersonShops(token: token),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<OrderProvider>(
                  builder: (_, order, __) => ListView.builder(
                    padding: EdgeInsets.all(5),
                    itemCount: order.listSalePersonShops.length,
                    itemBuilder: (context, index) => DelayedDisplay(
                      delay: Duration(milliseconds: 100),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          color: PaletteColors.greyColorApp,
                          borderRadius: BorderRadius.circular(12),
                          elevation: 2,
                          shadowColor: Colors.white,
                          child: GestureDetector(
                            onTap: () {
                              order.changeShopId(
                                  id: order.listSalePersonShops[index].id,
                                  shopDetail: order.listSalePersonShops[index]);
                              order.removeAllItemsInCart();
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: PaletteColors.greyColorApp,
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(12)),
                                  ),
                                  child: Container(
                                    height: languageCode == 'en' ? 80 : 97,
                                    width: 32,
                                    decoration: BoxDecoration(
                                      color: order.shopId ==
                                              order
                                                  .listSalePersonShops[index].id
                                          ? PaletteColors.darkRedColorApp
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: languageCode == 'en' ? 80 : 97,
                                    padding: EdgeInsets.all(15),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: PaletteColors.greyColorApp,
                                      borderRadius: BorderRadius.horizontal(
                                        right: Radius.circular(
                                            language.languageDirection == 'ltr'
                                                ? 0
                                                : 12),
                                        left: Radius.circular(
                                            language.languageDirection == 'ltr'
                                                ? 12
                                                : 0),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                order.listSalePersonShops[index]
                                                    .name,
                                                style: AppTextStyle.boldTitle24
                                                    .copyWith(
                                                        color: order.shopId ==
                                                                order
                                                                    .listSalePersonShops[
                                                                        index]
                                                                    .id
                                                            ? PaletteColors
                                                                .darkRedColorApp
                                                            : PaletteColors
                                                                .blackAppColor),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                order.listSalePersonShops[index]
                                                    .phone
                                                    .toString(),
                                                style: AppTextStyle
                                                    .regularTitle14
                                                    .copyWith(
                                                        color: order
                                                                    .shopId ==
                                                                order
                                                                    .listSalePersonShops[
                                                                        index]
                                                                    .id
                                                            ? PaletteColors
                                                                .darkRedColorApp
                                                            : PaletteColors
                                                                .blackAppColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Image.network(
                                          "${order.listSalePersonShops[index].image}",
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return ImageLoadingIndicator();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
