import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/GlobalWidgets/Direction.dart';
import 'package:nawras_app/GlobalWidgets/Responsive.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Models/Authentication/SalePerson.dart';
import 'package:nawras_app/Models/Authentication/Shop.dart';
import 'package:nawras_app/Providers/AuthProvider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String firstTowLetter = "";
    final words = Provider.of<Language>(context).words;

    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);

    Map<String, int> login = {"salePersonId": 0, "marketId": 0};

    if (auth.loginTypeGlobal == "shop") {
      Shop shop = auth.shop;
      firstTowLetter = shop.name.substring(0, 2);
      login["marketId"] = shop.id;
    } else {
      SalePerson salePerson = auth.salePerson;
      firstTowLetter = salePerson.name.substring(0, 2);
      login["salePersonId"] = salePerson.id;
    }

    return Direction(
      child: Scaffold(
        backgroundColor: PaletteColors.darkRedColorApp,
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: Text(words["profile"]),
        // ),
        body: Stack(
          children: [
            Positioned(
                top: 0,
                left: 0,
                child: Container(
                  height: Responsive.isMobile(context) ? 220 : 260,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            "assets/images/bg.png",
                          ),
                          fit: BoxFit.cover,
                          scale: 1)),
                )),
            Positioned(
              top: Responsive.isMobile(context) ? 170 : 210,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                    8, Responsive.isMobile(context) ? 70 : 150, 8, 0),
                decoration: BoxDecoration(
                    color: PaletteColors.whiteBg,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40))),
                margin: EdgeInsets.only(
                    top: Responsive.isMobile(context) ? 10 : 30),
                width: MediaQuery.of(context).size.width,
                height: Responsive.isMobile(context) ? 100 : 140,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            login["marketId"] == 0
                                ? auth.salePerson.name.toUpperCase()
                                : auth.shop.name.toUpperCase(),
                            style: AppTextStyle.boldTitle24
                                .copyWith(color: PaletteColors.blackAppColor),
                          )),
                      detailRow(
                          words["full-name"],
                          login["marketId"] == 0
                              ? auth.salePerson.name
                              : auth.shop.name,
                          context),
                      detailRow(
                          words["number-phone"],
                          login["marketId"] == 0
                              ? auth.salePerson.phone
                              : auth.shop.phone,
                          context),
                      // detailRow(words["user-type"],
                      //     login["marketId"] == 0 ? "SalePerson" : "Shop"),
                      login["marketId"] == 0
                          ? detailRow(words["email"],
                              auth.salePerson.email.toString(), context)
                          : SizedBox.shrink(),
                      login["marketId"] == 0
                          ? detailRow(words["car-number"],
                              auth.salePerson.carNumber.toString(), context)
                          : SizedBox.shrink(),
                      login["marketId"] == 0
                          ? SizedBox.shrink()
                          : detailRow(words["business-class"],
                              auth.shop.priceClass.toString(), context),
                      login["marketId"] == 0
                          ? SizedBox.shrink()
                          : detailRow(words["register-by"],
                              auth.shop.registerBy.toString(), context),

                      // DetailRow(words["location"], "Erbil"),
                      // DetailRow(words["zone"], "Anikawa"),
                      // DetailRow(words["area"], "Anikawa"),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: Responsive.isMobile(context) ? 100 : 140),
              child: Align(
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  radius: Responsive.isMobile(context)
                      ? MediaQuery.of(context).size.width / 6
                      : MediaQuery.of(context).size.width / 8,
                  child: login["marketId"] == 0
                      ? auth.salePerson.image.isEmpty ||
                              auth.salePerson.image == ""
                          ? Center(
                              child: CircleAvatar(
                                radius: Responsive.isMobile(context)
                                    ? MediaQuery.of(context).size.width / 6.5
                                    : MediaQuery.of(context).size.width / 8.5,
                                backgroundColor: PaletteColors.darkRedColorApp,
                                child: Text(
                                  firstTowLetter.toUpperCase(),
                                  style: AppTextStyle.boldTitle24
                                      .copyWith(color: PaletteColors.whiteBg),
                                ),
                              ),
                            )
                          : CircleAvatar(
                              radius: Responsive.isMobile(context)
                                  ? MediaQuery.of(context).size.width / 6.5
                                  : MediaQuery.of(context).size.width / 8.5,
                              backgroundColor: PaletteColors.darkRedColorApp,
                              backgroundImage: NetworkImage(
                                  'https://dang-voip.net/nawras_portal_api_Image/sale_person/images/${auth.salePerson.image}'),
                            )
                      : auth.shop.image.isEmpty || auth.shop.image == ""
                          ? Center(
                              child: CircleAvatar(
                                radius: Responsive.isMobile(context)
                                    ? MediaQuery.of(context).size.width / 6.5
                                    : MediaQuery.of(context).size.width / 8.5,
                                backgroundColor: PaletteColors.darkRedColorApp,
                                child: Text(
                                  firstTowLetter.toUpperCase(),
                                  style: AppTextStyle.boldTitle24
                                      .copyWith(color: PaletteColors.whiteBg),
                                ),
                              ),
                            )
                          : CircleAvatar(
                              radius: Responsive.isMobile(context)
                                  ? MediaQuery.of(context).size.width / 6.5
                                  : MediaQuery.of(context).size.width / 8.5,
                              backgroundColor: PaletteColors.darkRedColorApp,
                              backgroundImage: NetworkImage(
                                  'https://dang-voip.net/nawras_portal_api_Image/customer/images/${auth.shop.image}'),
                            ),
                  backgroundColor: PaletteColors.whiteBg,
                ),
              ),
            ),
            Positioned(
                top: 0,
                left: 0,
                child: SafeArea(
                    child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: PaletteColors.whiteBg,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ))),
          ],
        ),
      ),
    );
  }

  detailRow(String title, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: Responsive.isMobile(context) ? 10 : 20,
          ),
          Text(
            title,
            style: Responsive.isMobile(context)
                ? AppTextStyle.semiBoldTitle18
                : AppTextStyle.semiBoldTitle22
                    .copyWith(color: PaletteColors.blackAppColor),
          ),
          SizedBox(
            height: Responsive.isMobile(context) ? 8 : 16,
          ),
          Text(
            value,
            style: Responsive.isMobile(context)
                ? AppTextStyle.semiBoldTitle16
                : AppTextStyle.semiBoldTitle20.copyWith(
                    color: PaletteColors.blackAppColor.withOpacity(0.8)),
          ),
          Divider(
            thickness: 0.4,
            color: PaletteColors.blackAppColor.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
