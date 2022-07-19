import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Constants/CustomIcons.dart';
import 'package:nawras_app/GlobalWidgets/LoadingIndicator.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Models/Orders/Order.dart';
import 'package:nawras_app/Providers/AuthProvider.dart';
import 'package:nawras_app/Providers/OrderProvider.dart';
import 'package:provider/provider.dart';
import 'package:delayed_display/delayed_display.dart';

class ActivityTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final token =
        Provider.of<AuthProvider>(context, listen: false).session.mainToken;
    final words = Provider.of<Language>(context).words;
    return FutureBuilder(
      future: Provider.of<OrderProvider>(context, listen: false)
          .getAllMarketOrders(token: token),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? LoadingIndicator()
          : Consumer<OrderProvider>(
              builder: (_, order, __) {
                if (order.allMarketOrders.length == 0)
                  return Center(
                      child: Column(
                    children: [
                      getAppIcons(
                          asset: AppIcons.noActivity,
                          size: 110,
                          color: PaletteColors.blackAppColor.withOpacity(0.5)),
                      SizedBox(
                        height: 6,
                      ),
                      Text(words["no-requests"],
                          style: AppTextStyle.boldTitle16.copyWith(
                              color: PaletteColors.blackAppColor
                                  .withOpacity(0.5))),
                    ],
                  ));
                return ListView.builder(
                  itemCount: order.allMarketOrders.length,
                  itemBuilder: (context, index) => requestContainer(
                      context: context,
                      index: (index + 1).toString(),
                      order: order.allMarketOrders[index]),
                );
              },
            ),
    );
  }

  Widget requestContainer(
      {@required BuildContext context,
      @required String index,
      @required Order order}) {
    final words = Provider.of<Language>(context).words;

    return DelayedDisplay(
      delay: Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/marketHistoryOrderItemList",
              arguments: order);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(12),
                topRight: Radius.circular(12)),
            elevation: 4,
            shadowColor: Colors.white,
            child: Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 8,
                  width: 32,
                  decoration: BoxDecoration(
                    color: order.status == 'new'
                        ? PaletteColors.yellowColorApp
                        : order.status == 'accepted'
                            ? PaletteColors.greenColorApp
                            : PaletteColors.redColorApp,
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(8), right: Radius.circular(8)),
                  ),
                ),
                Expanded(
                  child: Container(
                    // margin: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                    padding: EdgeInsets.all(15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: PaletteColors.cardColorApp,
                    ),
                    height: MediaQuery.of(context).size.height / 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              order.status == 'new'
                                  ? words["new-filter"].toString().toUpperCase()
                                  : order.status == 'accepted'
                                      ? words["accept-filter"]
                                          .toString()
                                          .toUpperCase()
                                      : words["reject-filter"]
                                          .toString()
                                          .toUpperCase(),
                              style: AppTextStyle.boldTitle20
                                  .copyWith(color: PaletteColors.blackAppColor),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${words["order-count"]} ${order.items.length}',
                              style: AppTextStyle.regularTitle14
                                  .copyWith(color: PaletteColors.blackAppColor),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat.yMd().format(order.createdAt),
                              style: AppTextStyle.regularTitle14
                                  .copyWith(color: PaletteColors.blackAppColor),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              order.createdAt.hour.toString() +
                                  " : " +
                                  order.createdAt.minute.toString(),
                              style: AppTextStyle.regularTitle14
                                  .copyWith(color: PaletteColors.blackAppColor),
                            ),
                          ],
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
    );
  }
}
