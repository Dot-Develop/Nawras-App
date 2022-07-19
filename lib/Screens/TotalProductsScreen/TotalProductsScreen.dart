import 'package:flutter/material.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Constants/CustomIcons.dart';
import 'package:nawras_app/GlobalWidgets/Direction.dart';
import 'package:nawras_app/GlobalWidgets/RoundedButtonWithIcon.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Models/Orders/Order.dart';
import 'package:nawras_app/Providers/OrderProvider.dart';
import 'package:provider/provider.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:nawras_app/GlobalWidgets/LoadingIndicator.dart';

class TotalProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Order order = ModalRoute.of(context).settings.arguments;
    final words = Provider.of<Language>(context).words;
    return Direction(
      child: Scaffold(
        backgroundColor: PaletteColors.whiteBg,
        appBar: AppBar(
          title: Text(words["total-products"]),
        ),
        body: ListView.builder(
          itemCount: order.items.length,
          itemBuilder: (context, index) => TotalProductCard(
            title: words["nawras"],
            orderItem: order.items[index],
            image: '',
            order: order,
          ),
        ),
      ),
    );
  }
}

class TotalProductCard extends StatelessWidget {
  final String title;
  final SalePersonOrderItem orderItem;
  final String image;
  final Order order;

  const TotalProductCard({
    Key key,
    @required this.title,
    @required this.orderItem,
    @required this.image,
    @required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final language = Provider.of<Language>(context);
    final words = language.words;
    final languageCode = language.languageCode;
    return Consumer<OrderProvider>(
      builder: (_, orderProvider, __) => DelayedDisplay(
        delay: Duration(milliseconds: 300),
        child: Card(
          elevation: 1.4,
          margin: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            languageCode == 'kr'
                                ? orderItem.krName
                                : languageCode == 'en'
                                    ? orderItem.enName
                                    : orderItem.arName ?? words["no-name"],
                            style: AppTextStyle.boldTitle24
                                .copyWith(color: PaletteColors.blackAppColor),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${words["total-price"]}\$ ${orderItem.price * orderItem.number}',
                            style: AppTextStyle.regularTitle14
                                .copyWith(color: PaletteColors.blackAppColor),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${words["quantity"]}: ${orderItem.number}',
                            style: AppTextStyle.regularTitle14
                                .copyWith(color: PaletteColors.blackAppColor),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Image.network(
                        'https://dang-voip.net/nawras_portal_api_Image/product/images/${orderItem.image}',
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return ImageLoadingIndicator();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                if (order.status == 'new')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: PaletteColors.darkRedColorApp),
                              borderRadius: BorderRadius.circular(18)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                child: Icon(Icons.add,
                                    color: PaletteColors.darkRedColorApp),
                                onTap: () => orderProvider
                                    .operationOnSalePersonListOrder(
                                        orderId: order.id,
                                        sortId: orderItem.sortId,
                                        typeOperation: 'add'),
                              ),
                              SizedBox(width: 5),
                              Text(
                                orderItem.number.toString(),
                                style: AppTextStyle.regularTitle14.copyWith(
                                    color: PaletteColors.darkRedColorApp),
                              ),
                              SizedBox(width: 5),
                              GestureDetector(
                                child: Icon(Icons.remove,
                                    color: PaletteColors.darkRedColorApp),
                                onTap: () => orderProvider
                                    .operationOnSalePersonListOrder(
                                        orderId: order.id,
                                        sortId: orderItem.sortId,
                                        typeOperation: 'remove'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      RoundedButtonWithIcon(
                        title: "Delete",
                        onPressed: () =>
                            orderProvider.operationOnSalePersonListOrder(
                                orderId: order.id,
                                sortId: orderItem.sortId,
                                typeOperation: 'reset'),
                        icon: AppIcons.bin,
                        border: 18,
                        bgColor: PaletteColors.darkRedColorApp,
                        textColor: PaletteColors.whiteBg,
                      )
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
