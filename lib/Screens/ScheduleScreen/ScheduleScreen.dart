import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/GlobalWidgets/Direction.dart';
import 'package:nawras_app/GlobalWidgets/LoadingIndicator.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Providers/AuthProvider.dart';
import 'package:nawras_app/Providers/ScheduleProvider.dart';
import 'package:provider/provider.dart';
import 'package:nawras_app/GlobalWidgets/network_sensitive .dart';

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final words = Provider.of<Language>(context).words;

    final List<Map<String, String>> dateLabel = [
      {
        "title": words['Saturday'],
        "value": "Sat",
      },
      {
        "title": words['Sunday'],
        "value": "Sun",
      },
      {
        "title": words['Monday'],
        "value": "Mon",
      },
      {
        "title": words['Tuesday'],
        "value": "Tue",
      },
      {
        "title": words['Wednesday'],
        "value": "Wed",
      },
      {
        "title": words['Thursday'],
        "value": "Thu",
      },
      {
        "title": words['Friday'],
        "value": "Fri",
      },
    ];
    List date = List.generate(
        7,
        (index) => {
              'title': dateLabel[index]['title'],
              'date': DateTime.now().add(Duration(days: index)),
              "value": dateLabel[index]['value'],
            });
    final token =
        Provider.of<AuthProvider>(context, listen: false).session.mainToken;
    return NetworkSensitive(
      child: Direction(
        child: Scaffold(
          backgroundColor: PaletteColors.whiteBg,
          appBar: AppBar(
            title: Text(words["schedule"]),
          ),
          body: FutureBuilder(
            future: Provider.of<ScheduleProvider>(context, listen: false)
                .getScheduleData(token: token),
            builder: (context, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? LoadingIndicator()
                : ListView.builder(
                    itemCount: date.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/subSchedule",
                              arguments: date[index]['value']);
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(12),
                          elevation: 3,
                          shadowColor: PaletteColors.whiteBg.withOpacity(0.4),
                          child: ListTile(
                            trailing: Text(
                              DateFormat.yMd().format(date[index]['date']),
                              style: AppTextStyle.regularTitle14.copyWith(
                                color: PaletteColors.darkRedColorApp,
                              ),
                            ),
                            leading: Text(
                              date[index]['title'],
                              style: AppTextStyle.regularTitle20.copyWith(
                                color: PaletteColors.blackAppColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
