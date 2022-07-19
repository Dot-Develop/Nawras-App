import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/GlobalWidgets/Direction.dart';
import 'package:nawras_app/GlobalWidgets/LoadingIndicator.dart';
import 'package:nawras_app/GlobalWidgets/ProductCardItem.dart';
import 'package:nawras_app/GlobalWidgets/Responsive.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Models/Authentication/SalePerson.dart';
import 'package:nawras_app/Models/Authentication/Shop.dart';
import 'package:nawras_app/Models/Categories/Category.dart';
import 'package:nawras_app/Providers/AuthProvider.dart';
import 'package:nawras_app/Providers/CategoryProvider.dart';
import 'package:nawras_app/Providers/ProductProvider.dart';
import 'package:provider/provider.dart';

class SubCategoryScreen extends StatelessWidget {
  Future<void> getFutures({BuildContext context}) async {
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    final Category category = ModalRoute.of(context).settings.arguments;
    final token = auth.session.mainToken;
    Map<String, int> login = {"salePersonId": 0, "marketId": 0};

    if (auth.loginTypeGlobal == "shop") {
      Shop shop = auth.shop;
      login["marketId"] = shop.id;
    } else {
      SalePerson salePerson = auth.salePerson;
      login["salePersonId"] = salePerson.id;
    }
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    await categoryProvider.getSubCategory(
      token: token,
      categoryId: category.id.toString(),
      marketId: login["marketId"],
      salePersonId: login["salePersonId"],
    );
    await productProvider.getAllProductCategory(
      token: token,
      marketId: login["marketId"],
      salePersonId: login["salePersonId"],
      subCategoryId: categoryProvider.subCategoryId,
    );
    productProvider.productCategoryFilter(
        categoryId: categoryProvider.subCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    final language = Provider.of<Language>(context);
    final words = language.words;
    final languageCode = language.languageCode;
    final productProv = Provider.of<CategoryProvider>(context, listen: false);
    return Direction(
      child: Scaffold(
        appBar: AppBar(
          title: Text(words["categories"]),
        ),
        body: FutureBuilder(
          future: getFutures(context: context),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? LoadingIndicator()
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                        height: Responsive.isMobile(context) ? 65 : 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productProv.subCategoriesList.length,
                          itemBuilder: (context, index) {
                            return chip(
                              context: context,
                              label: languageCode == 'kr'
                                  ? productProv.subCategoriesList[index].krName
                                  : languageCode == 'en'
                                      ? productProv
                                          .subCategoriesList[index].enName
                                      : productProv
                                          .subCategoriesList[index].arName,
                              subCategoryId:
                                  productProv.subCategoriesList[index].id,
                            );
                          },
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.all(14),
                      sliver: Consumer<ProductProvider>(
                        builder: (_, product, __) {
                          return SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  Responsive.isMobile(context) ? 3 : 5,
                              childAspectRatio: MediaQuery.of(context)
                                      .size
                                      .width /
                                  (MediaQuery.of(context).size.height / 1.8),
                              mainAxisSpacing:
                                  Responsive.isMobile(context) ? 6 : 12,
                              crossAxisSpacing:
                                  Responsive.isMobile(context) ? 6 : 12,
                            ),
                            delegate: SliverChildBuilderDelegate(
                                (context, index) => ProductCardItem(
                                    context: context,
                                    product: product
                                        .getAllProductCategoryFilter[index],
                                    onPressed: () {}),
                                childCount:
                                    product.getAllProductCategoryFilter.length),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget chip({
    BuildContext context,
    String label,
    int subCategoryId,
  }) {
    return Consumer<CategoryProvider>(
      builder: (_, subCat, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: GestureDetector(
          onTap: () {
            print(subCat.subCategoryId);
            subCat.setSubCategoryId(subCategoryId);
            Provider.of<ProductProvider>(context, listen: false)
                .productCategoryFilter(categoryId: subCat.subCategoryId);
          },
          child: subCategoryId == subCat.subCategoryId
              ? Center(
                  child: Container(
                    padding: Responsive.isMobile(context)
                        ? EdgeInsets.symmetric(vertical: 3, horizontal: 4)
                        : EdgeInsets.all(10),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(label,
                            style: AppTextStyle.boldTitle16
                                .copyWith(color: PaletteColors.whiteBg)),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: PaletteColors.darkRedColorApp,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    padding: Responsive.isMobile(context)
                        ? EdgeInsets.symmetric(vertical: 3, horizontal: 4)
                        : EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: PaletteColors.mainAppColor, width: 0.6),
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(label,
                          style: AppTextStyle.boldTitle16
                              .copyWith(color: PaletteColors.darkRedColorApp)),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
