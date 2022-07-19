import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Models/Orders/Product.dart';
import 'package:nawras_app/Providers/ProductProvider.dart';
import 'package:provider/provider.dart';
import 'package:delayed_display/delayed_display.dart';
import 'Responsive.dart';
import 'LoadingIndicator.dart';

class ProductCardItem extends StatelessWidget {
  final BuildContext context;
  final Product product;
  final Function onPressed;

  ProductCardItem(
      {@required this.context,
      @required this.product,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final productAuth = Provider.of<ProductProvider>(context);
    bool isFav = productAuth.isFavoriteInSharedPreferences(product: product);
    final languageCode =
        Provider.of<Language>(context, listen: false).languageCode;
    return DelayedDisplay(
      delay: Duration(milliseconds: 300),
      child: Container(
        margin: EdgeInsets.all(Responsive.isMobile(context) ? 4 : 10),
        decoration: BoxDecoration(
            color: PaletteColors.greyColorApp,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: PaletteColors.blackAppColor.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset(3, 3),
                  spreadRadius: 0.3),
            ]),
        child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          splashColor: PaletteColors.mainAppColor,
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pushNamed(context, "/detailsProduct", arguments: product);
          },
          child: Padding(
            padding: EdgeInsets.all(2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.image,
                        fit: BoxFit.contain,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return ImageLoadingIndicator();
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          languageCode == 'kr'
                              ? product.krName
                              : languageCode == 'en'
                                  ? product.enName
                                  : product.arName,
                          style: Responsive.isMobile(context)
                              ? AppTextStyle.regularTitle12.copyWith(
                                  color: PaletteColors.darkRedColorApp)
                              : AppTextStyle.regularTitle18.copyWith(
                                  color: PaletteColors.darkRedColorApp),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      isFav
                          ? Icon(
                              Icons.favorite,
                              size: 20,
                              color: PaletteColors.mainAppColor,
                            )
                          : Icon(
                              Icons.favorite_border,
                              size: 20,
                              color:
                                  PaletteColors.mainAppColor.withOpacity(0.4),
                            )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
