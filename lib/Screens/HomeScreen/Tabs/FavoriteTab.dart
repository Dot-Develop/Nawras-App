import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Constants/CustomIcons.dart';
import 'package:nawras_app/GlobalWidgets/LoadingIndicator.dart';
import 'package:nawras_app/GlobalWidgets/ProductCardItem.dart';
import 'package:nawras_app/GlobalWidgets/Responsive.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Providers/ProductProvider.dart';
import 'package:nawras_app/Providers/providerStates.dart';
import 'package:provider/provider.dart';

class FavoriteTab extends StatelessWidget {
  void getAllFavorites(BuildContext context) async {
    final providerState = Provider.of<ProviderStates>(context, listen: false);
    providerState.setFavoriteRefreshed();
    await Provider.of<ProductProvider>(context, listen: false)
        .getAllFavoritesSharedPreferences();
    providerState.setFavoriteRefreshed();
  }

  @override
  Widget build(BuildContext context) {
    final words = Provider.of<Language>(context).words;
    final providerState = Provider.of<ProviderStates>(context, listen: false);
    return providerState.isFavoriteTabLoading
        ? LoadingIndicator()
        : Consumer<ProductProvider>(
            builder: (_, product, __) => product.allProductsFavoriteList.isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getAppIcons(
                          asset: AppIcons.favoriteOutline,
                          color: PaletteColors.blackIconAppBar.withOpacity(0.4),
                          size: 90),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        words["no-favorite"],
                        style: AppTextStyle.boldTitle16.copyWith(
                            color:
                                PaletteColors.blackIconAppBar.withOpacity(0.4)),
                      ),
                    ],
                  )
                : CustomScrollView(
                    slivers: [
                      if (product.allProductsFavoriteList.isEmpty)
                        SliverToBoxAdapter(
                          child: ListTile(
                            title: Text(
                              words["list-favorite"],
                              style: AppTextStyle.boldTitle16
                                  .copyWith(color: PaletteColors.blackAppColor),
                            ),
                          ),
                        ),
                      SliverPadding(
                        padding: EdgeInsets.all(14),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                Responsive.isMobile(context) ? 3 : 4,
                            childAspectRatio:
                                Responsive.isMobile(context) ? 1.05 : 0.8,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => ProductCardItem(
                              context: context,
                              product: product.allProductsFavoriteList[index],
                              onPressed: () {},
                            ),
                            childCount: product.allProductsFavoriteList.length,
                          ),
                        ),
                      ),
                    ],
                  ),
          );
  }
}
