import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/GlobalWidgets/Direction.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Models/Orders/Order.dart';
import 'package:provider/provider.dart' as provider;
import 'package:nawras_app/GlobalWidgets/LoadingIndicator.dart';

class MarketHistoryOrderItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Order orderItems = ModalRoute.of(context).settings.arguments;

    final words = provider.Provider.of<Language>(context).words;
    return Direction(
      child: Scaffold(
        appBar: AppBar(
          title: Text(words["order-item"]),
        ),
        body: ListView.builder(
          itemCount: orderItems.items.length,
          itemBuilder: (context, index) => activityCardTile(
              orderItem: orderItems.items[index], context: context),
        ),
      ),
    );
  }
}

Widget activityCardTile({@required orderItem, @required BuildContext context}) {
  print(orderItem.image);
  final language = provider.Provider.of<Language>(context);
  final words = language.words;
  final languageCode = language.languageCode;
  return Container(
    margin: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: PaletteColors.cardColorApp,
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0.4, 0.4))
        ]),
    child: Row(
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
                        : orderItem.arName,
                style: AppTextStyle.boldTitle24,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10),
              Text(
                  '${words["total-price"]}: ${orderItem.price * orderItem.number}    ${words["quantity"]}: ${orderItem.number}'),
              SizedBox(height: 5),
              // Text( DateFormat.yMd().format(orderItem.createdAt),),
            ],
          ),
        ),
        SizedBox(width: 5),
        Image.network(
          orderItem.image,
          width: 100,
          height: 100,
          fit: BoxFit.contain,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return ImageLoadingIndicator();
          },
        )
      ],
    ),
  );
}
