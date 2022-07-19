import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Constants/CustomIcons.dart';
import 'package:nawras_app/GlobalWidgets/Direction.dart';
import 'package:nawras_app/GlobalWidgets/LoadingIndicator.dart';
import 'package:nawras_app/GlobalWidgets/RoundedButton.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Helper/LocationService.dart';
import 'package:nawras_app/Models/Orders/Order.dart';
import 'package:nawras_app/Providers/AuthProvider.dart';
import 'package:nawras_app/Providers/OrderProvider.dart';
import 'package:provider/provider.dart';

class DetailRequestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Order order = ModalRoute.of(context).settings.arguments;
    final words = Provider.of<Language>(context, listen: false).words;
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final token =
        Provider.of<AuthProvider>(context, listen: false).session.mainToken;
    final location = Provider.of<LocationService>(context, listen: false);
    return Direction(
      child: Scaffold(
        appBar: AppBar(
          title: Text(words["request"]),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        DetailRequestCard(
                          title: words["market"] + ":",
                          subTitle: 'Kurdistan',
                          icon: AppIcons.market,
                          isItems: false,
                        ),
                        DetailRequestCard(
                          title: words["phone"] + ":",
                          subTitle: '075044444444',
                          icon: AppIcons.phone,
                          isItems: false,
                        ),
                        DetailRequestCard(
                          title: words["date"] + ":",
                          subTitle: DateFormat.yMd().format(order.createdAt),
                          icon: AppIcons.date,
                          isItems: false,
                        ),
                        DetailRequestCard(
                          title: words["total-price"],
                          subTitle: '5500\$',
                          icon: AppIcons.price,
                          isItems: false,
                        ),
                        DetailRequestCard(
                          title: words["items"] + ":",
                          subTitle: order.items.length.toString(),
                          icon: AppIcons.shop1,
                          isItems: true,
                          order: order,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  if (order.status == 'new')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RoundedButtonDD(
                          title: words["approve"],
                          onPressed: () async {
                            await orderProvider.acceptedOrRejectOrder(
                              token: token,
                              status: 'accepted',
                              order: order,
                              lat: location.lat,
                              lng: location.lng,
                            );
                            Navigator.pop(context);
                          },
                          color: Colors.teal,
                          height: 40,
                          radius: 12,
                        ),
                        RoundedButtonDD(
                          title: words["reject"],
                          onPressed: () async {
                            await orderProvider.acceptedOrRejectOrder(
                              token: token,
                              status: 'rejected',
                              order: order,
                              lat: location.lat,
                              lng: location.lng,
                            );
                            Navigator.pop(context);
                          },
                          height: 40,
                          radius: 12,
                        ),
                      ],
                    ),
                  SizedBox(height: 20)
                ],
              ),
            ),
            Consumer<OrderProvider>(
              builder: (_, orderProvider, __) =>
                  orderProvider.acceptedOrRejectOrderLoading
                      ? Container(
                          color: Colors.black26,
                          alignment: Alignment.center,
                          child: Container(
                              alignment: Alignment.center,
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: PaletteColors.cardColorApp,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.8),
                                      spreadRadius: 3,
                                      blurRadius: 6,
                                      offset: Offset(0, 0))
                                ],
                              ),
                              child: LoadingIndicator()),
                        )
                      : SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}

class DetailRequestCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String icon;
  final bool isItems;
  final Order order;

  const DetailRequestCard({
    Key key,
    @required this.title,
    @required this.subTitle,
    @required this.icon,
    @required this.isItems,
    this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isItems
          ? () =>
              Navigator.pushNamed(context, '/TotalProducts', arguments: order)
          : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        height: 70,
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
        child: Stack(
          children: [
            Center(
              child: Row(
                children: [
                  SizedBox(
                    width: 65,
                  ),
                  Expanded(
                    child: ListTile(
                      trailing: isItems
                          ? Icon(Icons.arrow_forward_ios)
                          : SizedBox(width: 0),
                      title: Text(title),
                      subtitle: Container(
                        padding: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: PaletteColors.cardColorApp,
                        ))),
                        child: Text(subTitle),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                width: 70,
                height: 70,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: PaletteColors.darkRedColorApp,
                    borderRadius: BorderRadius.circular(10)),
                child: getAppIcons(
                    asset: icon, size: 20, color: PaletteColors.whiteBg))
          ],
        ),
      ),
    );
  }
}
