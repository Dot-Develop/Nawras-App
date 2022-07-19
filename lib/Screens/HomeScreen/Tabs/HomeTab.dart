import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/CustomIcons.dart';
import 'package:nawras_app/GlobalWidgets/LoadingIndicator.dart';
import 'package:nawras_app/GlobalWidgets/Responsive.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Models/Authentication/SalePerson.dart';
import 'package:nawras_app/Models/Authentication/Shop.dart';
import 'package:nawras_app/Models/Categories/Category.dart';
import 'package:nawras_app/Providers/AuthProvider.dart';
import 'package:nawras_app/Providers/CategoryProvider.dart';
import 'package:nawras_app/Providers/OrderProvider.dart';
import 'package:nawras_app/Providers/OtherProvider.dart';
import 'package:nawras_app/Providers/providerStates.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as Lunch;
import 'package:delayed_display/delayed_display.dart';

class HomeTab extends StatelessWidget {
  Future<void> getFutures(BuildContext context, token, int salePersonId,
      int marketId, bool isRefresh) async {
    final getCategory = Provider.of<CategoryProvider>(context, listen: false);
    final providerState = Provider.of<ProviderStates>(context, listen: false);
    if (getCategory.categoriesList.isNotEmpty && !isRefresh) return;
    if (!providerState.isHomeTabLoading) providerState.setHomeRefreshed();
    await Future.wait([
      Provider.of<CategoryProvider>(context, listen: false)
          .getCategory(token: token),
      Provider.of<OtherProvider>(context, listen: false).getAllBanners(
        token: token,
        salePersonId: salePersonId,
        marketId: marketId,
      ),
      Provider.of<OtherProvider>(context, listen: false)
          .getAllOffers(token: token),
    ]);
    providerState.setHomeRefreshed();
  }

  @override
  Widget build(BuildContext context) {
    final language = Provider.of<Language>(context);
    final words = language.words;
    final languageCode = language.languageCode;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    Map<String, int> login = {"salePersonId": 0, "marketId": 0};
    if (auth.loginTypeGlobal == "shop") {
      Shop shop = auth.shop;
      login["marketId"] = shop.id;
    } else {
      SalePerson salePerson = auth.salePerson;
      login["salePersonId"] = salePerson.id;
    }
    getFutures(context, auth.session.mainToken, login["salePersonId"],
        login["marketId"], false);

    return RefreshIndicator(
      onRefresh: () async => await getFutures(context, auth.session.mainToken,
          login["salePersonId"], login["marketId"], true),
      child: Consumer<ProviderStates>(
        builder: (_, providerState, __) => providerState.isHomeTabLoading
            ? LoadingIndicator()
            : Consumer<OrderProvider>(
                builder: (_, order, __) => Stack(
                  children: [
                    CustomScrollView(
                      slivers: [
                        Consumer<OtherProvider>(
                          builder: (_, other, __) {
                            return SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CarouselSlider.builder(
                                    itemCount: other.allBannersList.length,
                                    options: CarouselOptions(
                                      height: Responsive.isMobile(context)
                                          ? 200
                                          : 380,
                                      aspectRatio: 16 / 9,
                                      viewportFraction: 0.9,
                                      initialPage: 0,
                                      // enableInfiniteScroll: true,
                                      reverse: false,
                                      autoPlay: true,
                                      autoPlayInterval: Duration(seconds: 3),
                                      autoPlayAnimationDuration:
                                          Duration(milliseconds: 1500),
                                      autoPlayCurve:
                                          Curves.fastLinearToSlowEaseIn,
                                      // enlargeCenterPage: true,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int itemIndex) =>
                                            Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          other.allBannersList[itemIndex].image,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return ImageLoadingIndicator();
                                            // child: CircularProgressIndicator(
                                            //   value: loadingProgress.expectedTotalBytes != null ?
                                            //   loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                            //       : null,
                                            // ),
                                            // );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text(
                                      words["offers"],
                                      style: AppTextStyle.boldTitle24.copyWith(
                                          color: PaletteColors.blackAppColor),
                                    ),
                                  ),
                                  Container(
                                    height: 75,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: other.allOffersList.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () => showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    backgroundColor:
                                                        PaletteColors.whiteBg,
                                                    elevation: 4,
                                                    title: Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          other
                                                              .allOffersList[
                                                                  index]
                                                              .title
                                                              .toString(),
                                                          style: AppTextStyle
                                                              .boldTitle24
                                                              .copyWith(
                                                                  color: PaletteColors
                                                                      .darkRedColorApp),
                                                        )),
                                                    content: Text(other
                                                        .allOffersList[index]
                                                        .description),
                                                    actions: [
                                                      RaisedButton(
                                                          child: Text(
                                                              words["call"]),
                                                          color: PaletteColors
                                                              .darkRedColorApp,
                                                          onPressed: () =>
                                                              Lunch.launch(
                                                                  "tel://07503600525")),
                                                      RaisedButton(
                                                          child: Text(
                                                              words["close"]),
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context)),
                                                    ],
                                                  )),
                                          child: Container(
                                            width: Responsive.isMobile(context)
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.2
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3.2,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                other
                                                    .allOffersList[index].image,
                                                fit: BoxFit.cover,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent
                                                            loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return ImageLoadingIndicator();
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 8),
                                    child: Text(
                                      words["categories"],
                                      style: AppTextStyle.boldTitle24.copyWith(
                                          color: PaletteColors.blackAppColor),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SliverPadding(
                          padding: EdgeInsets.all(14),
                          sliver: Consumer<CategoryProvider>(
                            builder: (_, category, __) => SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing:
                                    Responsive.isMobile(context) ? 3.2 : 6.4,
                                crossAxisSpacing:
                                    Responsive.isMobile(context) ? 3.2 : 6.4,
                                crossAxisCount:
                                    Responsive.isMobile(context) ? 3 : 5,
                              ),
                              // gridDelegate:
                              //     SliverGridDelegateWithMaxCrossAxisExtent(
                              //   maxCrossAxisExtent: 120,
                              //   mainAxisSpacing: 3.2,
                              //   crossAxisSpacing: 3.2
                              //   // mainAxisExtent: 120,
                              // ),
                              delegate: SliverChildBuilderDelegate(
                                  // Don't know what to do here
                                  (context, index) => roundedRectBorderWidget(
                                      context: context,
                                      category: category.categoriesList[index],
                                      onPressed: () {}),
                                  childCount: category.categoriesList.length),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 20,
                      right: 0,
                      child: login["salePersonId"] == 0
                          ? SizedBox.shrink()
                          : GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/setMarket'),
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(12)),
                                    color: PaletteColors.darkRedColorApp
                                        .withOpacity(0.7)),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        order.shopDetailsOrder == null
                                            ? ""
                                            : order.shopDetailsOrder.name
                                                .toUpperCase(),
                                        style: Responsive.isMobile(context)
                                            ? AppTextStyle.semiBoldTitle20
                                                .copyWith(
                                                    color:
                                                        PaletteColors.whiteBg)
                                            : AppTextStyle.semiBoldTitle24
                                                .copyWith(
                                                    color:
                                                        PaletteColors.whiteBg),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    getAppIcons(
                                        asset: AppIcons.market,
                                        size: Responsive.isMobile(context)
                                            ? 40
                                            : 70),
                                  ],
                                ),
                              ),
                            ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget roundedRectBorderWidget({
    BuildContext context,
    final Category category,
    final Function onPressed,
  }) {
    final language = Provider.of<Language>(context);
    final languageDirection = language.languageDirection;
    final languageCode = language.languageCode;
    return DelayedDisplay(
      delay: Duration(milliseconds: 300),
      child: Container(
        margin: EdgeInsets.all(Responsive.isMobile(context) ? 3 : 6),
        decoration: BoxDecoration(
            color: PaletteColors.greyColorApp,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: PaletteColors.blackAppColor.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(3, 3),
                spreadRadius: 0.3,
              ),
            ]),
        child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          splashColor: PaletteColors.mainAppColor,
          padding: EdgeInsets.all(3),
          onPressed: () {
            Navigator.pushNamed(context, "/subCategory", arguments: category);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                alignment: languageDirection == 'rtl'
                    ? Alignment.topRight
                    : Alignment.topLeft,
                padding: EdgeInsets.only(bottom: 2),
                child: Text(
                    languageCode == 'kr'
                        ? category.krName
                        : languageCode == 'en'
                            ? category.enName
                            : category.arName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Responsive.isMobile(context)
                        ? AppTextStyle.regularTitle14
                        : AppTextStyle.regularTitle16
                            .copyWith(color: PaletteColors.darkRedColorApp)),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "${category.image}",
                  fit: BoxFit.fitHeight,
                  height: Responsive.isMobile(context) ? 60 : 80,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return ImageLoadingIndicator();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
