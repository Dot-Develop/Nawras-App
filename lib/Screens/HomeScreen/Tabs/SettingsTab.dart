import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Constants/CustomIcons.dart';
import 'package:nawras_app/GlobalWidgets/Responsive.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Models/Authentication/SalePerson.dart';
import 'package:nawras_app/Models/Authentication/Shop.dart';
import 'package:nawras_app/Providers/AppSettingsProvider.dart';
import 'package:nawras_app/Providers/AuthProvider.dart';
import 'package:provider/provider.dart';

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final words = Provider.of<Language>(context).words;
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    Map<String, int> login = {"salePersonId": 0, "marketId": 0};
    if (auth.loginTypeGlobal == "shop") {
      Shop shop = auth.shop;
      login["marketId"] = shop.id;
    } else {
      SalePerson salePerson = auth.salePerson;
      login["salePersonId"] = salePerson.id;
    }
    return Stack(
      children: [
        ListView(
          children: [
            Container(
              color: PaletteColors.darkRedColorApp,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                children: [
                  login["marketId"] == 0
                      ? CircleAvatar(
                          radius: 30,
                          backgroundColor: PaletteColors.darkRedColorApp,
                          backgroundImage: NetworkImage(
                              'https://dang-voip.net/nawras_portal_api_Image/sale_person/images/${auth.salePerson.image}'),
                        )
                      : CircleAvatar(
                          radius: 30,
                          backgroundColor: PaletteColors.darkRedColorApp,
                          backgroundImage: NetworkImage(
                              'https://dang-voip.net/nawras_portal_api_Image/customer/images/${auth.shop.image}'),
                        ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        login["marketId"] == 0
                            ? auth.salePerson.name.toUpperCase()
                            : auth.shop.name.toUpperCase(),
                        style: AppTextStyle.boldTitle20
                            .copyWith(color: Colors.white),
                      ),
                      Text(
                        login["marketId"] == 0
                            ? auth.salePerson.phone
                            : auth.shop.phone,
                        style: AppTextStyle.regularTitle12
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 0),
            SettingListTile(
              title: words["view-profile"],
              icon: AppIcons.profile,
              buttonTitle: words["view"],
              onPressed: () {
                Navigator.pushNamed(context, "/profile");
              },
            ),
            Divider(height: 0),
            if (login["marketId"] == 0)
              SettingListTile(
                title: words["schedule"],
                icon: AppIcons.date,
                onPressed: () => Navigator.pushNamed(context, '/schedule'),
              ),
            Divider(height: 0),
            SettingListTile(
              title: words["feedback"],
              icon: AppIcons.feedback,
              onPressed: () {
                if (login["marketId"] == 0) {
                  Navigator.pushNamed(context, "/marketing");
                } else {
                  Navigator.pushNamed(context, "/feedback");
                }
              },
            ),
            Divider(height: 0),
            SettingListTile(
              title: words["language"],
              icon: AppIcons.language,
              buttonTitle: Provider.of<Language>(context).languageCode,
              onPressed: () {
                Navigator.pushNamed(context, "/language");
              },
            ),
            Divider(height: 0),
            SettingListTile(
              title: words["display-mode"],
              icon: AppIcons.update,
              buttonTitle: words["light"],
              onPressed: () {},
            ),
            Divider(height: 0),
            SettingListTile(
              title: words["about"],
              icon: AppIcons.about,
              onPressed: () => Navigator.pushNamed(context, "/about"),
            ),
            Divider(height: 0),
            SettingListTile(
              title: words["contact"],
              icon: AppIcons.contact,
              onPressed: () => Navigator.pushNamed(context, "/contact"),
            ),
            Divider(height: 0),
            SettingListTile(
                title: words["update"],
                icon: AppIcons.update,
                onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: PaletteColors.whiteBg,
                        elevation: 4,
                        title: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "${words["warning"]}:",
                              style: AppTextStyle.semiBoldTitle20.copyWith(
                                  color: PaletteColors.darkRedColorApp),
                            )),
                        content: Text(words["last-version-already"]),
                        actions: [
                          RaisedButton(
                              child: Text(words["close"]),
                              color: PaletteColors.darkRedColorApp,
                              onPressed: () => Navigator.pop(context)),
                        ],
                      ),
                    )),
          ],
        ),
        Positioned(
          bottom: 20,
          right: 15,
          child: FloatingActionButton(
              backgroundColor: PaletteColors.mainAppColor,
              child: getAppIcons(asset: AppIcons.logout, size: 30),
              onPressed: () async {
                Provider.of<AppSettingsProvider>(context, listen: false)
                    .setHomeTab(0);
                await Provider.of<AuthProvider>(context, listen: false)
                    .logout();
                Provider.of<AppSettingsProvider>(context, listen: false)
                    .setHomeTab(0);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              }),
        ),
      ],
    );
  }
}

class SettingListTile extends StatelessWidget {
  final String title;
  final String buttonTitle;
  final String icon;
  final Function onPressed;

  const SettingListTile({
    Key key,
    @required this.title,
    this.buttonTitle = '',
    @required this.onPressed,
    @required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
          vertical: Responsive.isMobile(context) ? 1 : 20, horizontal: 10),
      title: Text(
        title,
        style: Responsive.isMobile(context)
            ? AppTextStyle.regularTitle16.copyWith(
                color: PaletteColors.blackIconAppBar,
              )
            : AppTextStyle.regularTitle24.copyWith(
                color: PaletteColors.blackIconAppBar,
              ),
      ),
      leading: getAppIcons(
          asset: icon,
          size: Responsive.isMobile(context) ? 40 : 90,
          color: PaletteColors.blackAppColor),
      trailing: buttonTitle.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                buttonTitle,
                style: Responsive.isMobile(context)
                    ? AppTextStyle.regularTitle12.copyWith(
                        color: Colors.grey,
                      )
                    : AppTextStyle.regularTitle22.copyWith(
                        color: Colors.grey,
                      ),
              ),
            ),
      onTap: onPressed,
    );
  }
}
