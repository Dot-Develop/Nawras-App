import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Constants/CustomIcons.dart';
import 'package:nawras_app/GlobalWidgets/LoadingIndicator.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Models/Other/LocalNotification.dart';
import 'package:nawras_app/Providers/AppSettingsProvider.dart';
import 'package:nawras_app/Providers/OtherProvider.dart';
import 'package:nawras_app/Providers/ProductProvider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as Lunch;

class NotificationDrawer extends StatelessWidget {
  final BuildContext mContext;

  const NotificationDrawer({Key key, this.mContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final words = Provider.of<Language>(context).words;
    // OtherProvider provider = Provider.of<OtherProvider>(context, listen: false);

    return FutureBuilder(
        future: Provider.of<OtherProvider>(context, listen: false)
            .getAllNotificationsSharedPreferences(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? LoadingIndicator()
            : Consumer<OtherProvider>(
                builder: (_, other, __) {
                  // other.listNotification.add(new LocalNotification(id: "3rr3rerwr13", title: "nfsfsfull", body: "nulfsfsfl", type: "all", time: DateTime.now()));
                  // other.listNotification.add(new LocalNotification(id: "3rr3rerddwr13", title: "nusfsfsfll", body: "nfsfsfull", type: "accepted", time: DateTime.now()));
                  // other.listNotification.add(new LocalNotification(id: "3rr3rerddwr13", title: "dwdsdfsds", body: "nfsfsfull", type: "rejected", time: DateTime.now()));
                  if (other.isNotificationShown) {
                    Fluttertoast.showToast(
                      textColor: PaletteColors.darkRedColorApp,
                      backgroundColor: PaletteColors.whiteBg,
                      msg: words["notification-status"],
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                    other.hideNotificationSnackbar();
                  }
                  return Drawer(
                    child: Column(
                      children: [
                        AppBar(
                          centerTitle: false,
                          title: Text(
                            words["notifications"],
                            style: AppTextStyle.boldTitle18
                                .copyWith(color: PaletteColors.whiteBg),
                          ),
                          automaticallyImplyLeading: false,
                          actions: [
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (other.listNotification.isNotEmpty)
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              backgroundColor:
                                                  PaletteColors.whiteBg,
                                              elevation: 4,
                                              title: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    "Warning !".toString(),
                                                    style: AppTextStyle
                                                        .boldTitle24
                                                        .copyWith(
                                                            color: PaletteColors
                                                                .darkRedColorApp),
                                                  )),
                                              content: Text(
                                                  "Are you Sure Delete All Notifications ?"),
                                              actions: [
                                                RaisedButton(
                                                    child: Text("Delete"),
                                                    color: PaletteColors
                                                        .darkRedColorApp,
                                                    onPressed: () {
                                                      other
                                                          .clearAllNotifications();
                                                      Navigator.pop(context);
                                                    }),
                                                RaisedButton(
                                                    child: Text(words["close"]),
                                                    onPressed: () =>
                                                        Navigator.pop(context)),
                                              ],
                                            ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(words["clear-all"],
                                      style: AppTextStyle.regularTitle14
                                          .copyWith(
                                              color: PaletteColors.whiteBg)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: other.listNotification.isEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    getAppIcons(
                                        asset: AppIcons.noNotification,
                                        color: PaletteColors.blackIconAppBar
                                            .withOpacity(0.4),
                                        size: 90),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      words["no-notifications"],
                                      style: AppTextStyle.boldTitle16.copyWith(
                                          color: PaletteColors.blackIconAppBar
                                              .withOpacity(0.4)),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: other.listNotification.length,
                                  itemBuilder: (context, index) =>
                                      NotificationCard(
                                    localNotification:
                                        other.listNotification[index],
                                    context: mContext,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ));
  }
}

class NotificationCard extends StatelessWidget {
  final LocalNotification localNotification;
  final BuildContext context;

  const NotificationCard({
    Key key,
    @required this.localNotification,
    this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OtherProvider provider = Provider.of<OtherProvider>(context, listen: false);
    final words = Provider.of<Language>(context, listen: false).words;
    final listProducts =
        Provider.of<ProductProvider>(context, listen: false).allProductsList;

    return Container(
      decoration: BoxDecoration(
          color: localNotification.type == "rejected"
              ? PaletteColors.redColorApp.withOpacity(0.2)
              : localNotification.type == "accepted"
                  ? PaletteColors.greenColorApp.withOpacity(0.2)
                  : PaletteColors.whiteBg,
          border:
              Border(bottom: BorderSide(color: PaletteColors.cardColorApp))),
      child: ListTile(
        leading: getAppIcons(
            asset: AppIcons.notifivations,
            color: PaletteColors.darkRedColorApp),
        title: Text(localNotification.title),
        subtitle: Text(
          localNotification.body,
          style: AppTextStyle.regularTitle12,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              timeAgo(localNotification.time, context),
              style: AppTextStyle.regularTitle10,
            ),
            SizedBox(height: 4),
            GestureDetector(
              child: getAppIcons(
                  asset: AppIcons.bin,
                  size: 24,
                  color: PaletteColors.darkRedColorApp),
              onTap: () => provider.removeLocalNotification(
                  localNotification: localNotification),
            )
          ],
        ),
        onTap: () {
          if (localNotification.type == "all" ||
              localNotification.type == "deleting_product") {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      backgroundColor: PaletteColors.whiteBg,
                      elevation: 4,
                      title: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            localNotification.title.toString(),
                            style: AppTextStyle.boldTitle24
                                .copyWith(color: PaletteColors.darkRedColorApp),
                          )),
                      content: Text(localNotification.body),
                      actions: [
                        RaisedButton(
                            child: Text(words["call"]),
                            color: PaletteColors.darkRedColorApp,
                            onPressed: () => Lunch.launch("tel://07503600525")),
                        RaisedButton(
                            child: Text(words["close"]),
                            onPressed: () => Navigator.pop(context)),
                      ],
                    ));
          } else if (localNotification.type == "rejected" ||
              localNotification.type == "accepted") {
            final appSettings =
                Provider.of<AppSettingsProvider>(context, listen: false);
            appSettings.setHomeTab(1);
            Navigator.pop(context);
          } else {
            print("Hereeee before Productttt");
            print(localNotification.productId);
            var product = listProducts.where((product) {
              // print(product.id);
              // print(localNotification.productId);
              return product.id.toString() == localNotification.productId;
            }).first;
            Navigator.pushNamed(context, "/detailsProduct", arguments: product);
          }
        },
      ),
    );
  }
}

String timeAgo(DateTime d, BuildContext context) {
  final words = Provider.of<Language>(context).words;
  Duration diff = DateTime.now().difference(d);
  if (diff.inDays > 365)
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "${words["year"]}" : "${words["years"]}"} ${words["ago"]}";
  if (diff.inDays > 30)
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "${words["month"]}" : "${words["months"]}"} ${words["ago"]} ";
  if (diff.inDays > 7)
    return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "${words["week"]}" : "${words["weeks"]}"} ${words["ago"]} ";
  if (diff.inDays > 0)
    return "${diff.inDays} ${diff.inDays == 1 ? "${words["day"]}" : "${words["days"]}"} ${words["ago"]} ";
  if (diff.inHours > 0)
    return "${diff.inHours} ${diff.inHours == 1 ? "${words["hour"]}" : "${words["hours"]}"} ${words["ago"]} ";
  if (diff.inMinutes > 0)
    return "${diff.inMinutes} ${diff.inMinutes == 1 ? "${words["minute"]}" : "${words["minutes"]}"} ${words["ago"]} ";
  return "${words["just-now"]}";
}
