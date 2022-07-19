import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nawras_app/GlobalWidgets/Direction.dart';
import 'package:nawras_app/GlobalWidgets/LoadingIndicator.dart';
import 'package:nawras_app/GlobalWidgets/Responsive.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Helper/LocationService.dart';
import 'package:nawras_app/Providers/ScheduleProvider.dart';
import 'package:provider/provider.dart';
import 'Widgets/ScheduleCard.dart';

class SubScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final language = Provider.of<Language>(context, listen: false);
    final words = language.words;
    final languageCode = language.languageCode;
    final String date = ModalRoute.of(context).settings.arguments;
    final scheduleItems =
        Provider.of<ScheduleProvider>(context, listen: false).scheduleItems;
    List salePersonSchedule =
        scheduleItems.where((s) => s.day == date.toLowerCase()).toList();
    return Direction(
      child: Scaffold(
        appBar: AppBar(
          title: Text(words["sub-schedule"]),
        ),
        body: Stack(
          children: [
            GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: Responsive.isMobile(context) ? 1.05 : 1.6,
                mainAxisSpacing: Responsive.isMobile(context) ? 3.2 : 6.4,
                crossAxisSpacing: Responsive.isMobile(context) ? 3.2 : 6.4,
                crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
              ),
              itemCount: salePersonSchedule.length,
              itemBuilder: (context, index) => ScheduleCard(
                  schedule: salePersonSchedule[index],
                  shops: salePersonSchedule),
            ),
            Consumer<LocationService>(
              builder: (_, location, __) => location.locationLoading
                  ? Container(
                      color: Colors.black26,
                      alignment: Alignment.center,
                      child: LoadingIndicator())
                  : SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}
