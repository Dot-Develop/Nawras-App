import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Constants/CustomIcons.dart';
import 'package:nawras_app/GlobalWidgets/Responsive.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Helper/LocationService.dart';
import 'package:nawras_app/Models/Other/Schedule.dart';
import 'package:nawras_app/Screens/AndroidMapScreen/AndroidMapScreen.dart';
import 'package:nawras_app/Screens/MapIOSScreen/MapIOSScreen.dart';
import 'package:provider/provider.dart';
import 'package:latlong/latlong.dart';
import 'package:apple_maps_flutter/apple_maps_flutter.dart' as appleMap;

class ScheduleCard extends StatelessWidget {
  final Schedule schedule;
  final dynamic shops;

  const ScheduleCard({
    Key key,
    @required this.schedule,
    @required this.shops,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final words = Provider.of<Language>(context).words;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        children: [
          Container(
            // height: Responsive.isMobile(context) ? 140 : 210,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: PaletteColors.darkRedColorApp.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0.0, 0.0))
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      getARow(words["market"] + ":", schedule.name, context),
                      getARow(words["zone"] + ":", schedule.zoneName, context),
                      getARow(words["phone"] + ":", schedule.phone, context),
                    ],
                  ),
                ),
                Consumer<LocationService>(
                  builder: (_, location, __) => MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      ),
                    ),
                    padding: EdgeInsets.zero,
                    color: PaletteColors.darkRedColorApp,
                    onPressed: () async {
                      if (location.lat == null) {
                        await location.getLocation();
                        if (location.lat == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Enable location')));
                          return;
                        }
                      }
                      Platform.isAndroid
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AndroidMapScreen(
                                  currentShop: schedule,
                                  shops: shops,
                                  salePersonLocation:
                                      LatLng(location.lat, location.lng),
                                ),
                              ),
                            )
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapIOSScreen(
                                  currentShop: schedule,
                                  shops: shops,
                                  salePersonLocation: appleMap.LatLng(
                                      location.lat, location.lng),
                                ),
                              ),
                            );
                    },
                    child: Text(
                      words["get-location"],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppTextStyle.boldTitle14
                          .copyWith(color: PaletteColors.whiteBg),
                    ),
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Provider.of<Language>(context).languageDirection == "rtl"
                ? Alignment(-1.03, -1.03)
                : Alignment(1.03, -1.03),
            child: Container(
              alignment: Alignment.center,
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10)),
              child: getAppIcons(asset: AppIcons.date, size: 90),
            ),
          )
        ],
      ),
    );
  }

  Widget getARow(String title, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(title,
              style: !Responsive.isMobile(context)
                  ? AppTextStyle.boldTitle22
                  : AppTextStyle.boldTitle14),
          Text(value,
              style: !Responsive.isMobile(context)
                  ? AppTextStyle.boldTitle16
                  : AppTextStyle.boldTitle12),
        ],
      ),
    );
  }
}
