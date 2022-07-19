import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Constants/CustomIcons.dart';
import 'package:nawras_app/GlobalWidgets/LoadingIndicator.dart';
import 'package:nawras_app/GlobalWidgets/ProductCardItem.dart';
import 'package:nawras_app/GlobalWidgets/Responsive.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Models/Authentication/SalePerson.dart';
import 'package:nawras_app/Models/Authentication/Shop.dart';
import 'package:nawras_app/Providers/AuthProvider.dart';
import 'package:nawras_app/Providers/ProductProvider.dart';
import 'package:provider/provider.dart';

class SearchTab extends StatelessWidget {
  Future<void> getAllProduct({
    @required BuildContext context,
    @required bool isSort,
  }) async {
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    Map<String, int> login = {"salePersonId": 0, "marketId": 0};
    if (auth.loginTypeGlobal == "shop") {
      Shop shop = auth.shop;
      login["marketId"] = shop.id;
    } else {
      SalePerson salePerson = auth.salePerson;
      login["salePersonId"] = salePerson.id;
    }
    // check
    if (productProvider.allProductsList.isNotEmpty && !isSort) return;
    await productProvider.getAllProduct(
      token: auth.session.mainToken,
      marketId: login["marketId"],
      salePersonId: login["salePersonId"],
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final words = Provider.of<Language>(context).words;
    List<Map<String, dynamic>> checkData = [
      {'label': words["all"], 'value': 'all'},
      {'label': words['most-popular'], 'value': 'popular'},
      {'label': words['best-seller'], 'value': 'wanted'},
      {'label': words['new-product'], 'value': 'new'},
    ];
    getAllProduct(context: context, isSort: false);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    words["search-for-product"],
                    style: AppTextStyle.boldTitle24
                        .copyWith(color: PaletteColors.blackAppColor),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextField(
                        decoration:
                            InputDecoration(hintText: words["type-here"]),
                        onChanged: (text) {
                          productProvider.searchProduct(text);
                        },
                      ),
                    ),
                    PopupMenuButton<String>(
                        icon: getAppIcons(
                            asset: AppIcons.filter,
                            color:
                                PaletteColors.blackIconAppBar.withOpacity(0.8)),
                        onSelected: (String value) async {
                          // print(value);
                          productProvider.setCheckedSelection(value);
                          await getAllProduct(context: context, isSort: true);
                        },
                        itemBuilder: (BuildContext context) => checkData
                            .map(
                              (e) => PopupMenuItem<String>(
                                value: e['value'],
                                child: Row(
                                  children: [
                                    Icon(
                                      productProvider.checkedSelection ==
                                              e['value']
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                      color: PaletteColors.redColorApp,
                                      size: 20,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      e['label'],
                                      style: TextStyle(
                                          color: productProvider
                                                      .checkedSelection ==
                                                  e['value']
                                              ? PaletteColors.redColorApp
                                              : PaletteColors.blackIconAppBar),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList())
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(14),
          sliver: Consumer<ProductProvider>(
            builder: (_, product, __) {
              if (product.isLoading)
                return SliverToBoxAdapter(
                  child: Center(
                    child: LoadingIndicator(),
                  ),
                );
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Responsive.isMobile(context) ? 3 : 4,
                  childAspectRatio: Responsive.isMobile(context) ? 1.05 : 0.8,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                delegate: SliverChildBuilderDelegate(
                    (context, index) => ProductCardItem(
                          context: context,
                          product: product.searchItems[index],
                          onPressed: () {},
                        ),
                    childCount: product.searchItems.length),
              );
            },
          ),
        ),
      ],
    );
  }
}
