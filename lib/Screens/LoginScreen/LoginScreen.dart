import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Constants/CustomIcons.dart';
import 'package:nawras_app/GlobalWidgets/Direction.dart';
import 'package:nawras_app/GlobalWidgets/LoadingIndicator.dart';
import 'package:nawras_app/GlobalWidgets/Responsive.dart';
import 'package:nawras_app/GlobalWidgets/RoundedButton.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:nawras_app/Providers/AuthProvider.dart';
import 'package:provider/provider.dart';

OutlineInputBorder outlineBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8),
  borderSide: BorderSide(color: PaletteColors.darkRedColorApp, width: 1),
);

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double _width = 140;
  String current = "sale_person";

  Map<String, String> authMap = {"phone": "", "password": ""};

  final _formKey = GlobalKey<FormState>();

  void onSubmit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    final auth = Provider.of<AuthProvider>(context, listen: false);
    var status = await auth.login(
        loginType: current,
        phone: authMap["phone"],
        password: authMap["password"]);

    if (status) {
      Navigator.pushNamed(context, "/home");
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: PaletteColors.whiteBg,
          elevation: 4,
          title: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Warning:",
                style: AppTextStyle.boldTitle24
                    .copyWith(color: PaletteColors.darkRedColorApp),
              )),
          content: Text("Password or Phone number not valid...."),
          actions: [
            RoundedButton(
                title: "Cancel",
                isThikHeight: true,
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final words = Provider.of<Language>(context, listen: false).words;
    return Direction(
      child: WillPopScope(
        onWillPop: () async => showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(title: Text(words["sure-exit"]), actions: <Widget>[
            RaisedButton(
                child: Text(words["exit"]),
                color: PaletteColors.darkRedColorApp,
                onPressed: () => exit(0)),
            RaisedButton(
                child: Text(words["close"]),
                onPressed: () => Navigator.of(context).pop(false)),
          ]),
        ),
        child: Scaffold(
          backgroundColor: PaletteColors.whiteBg,
          body: Stack(
            children: [
              Container(
                alignment: Responsive.isTablet(context)
                    ? Alignment.center
                    : Alignment.topLeft,
                margin: EdgeInsets.symmetric(
                    horizontal: Responsive.isMobile(context) ? 15 : 150),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Text(
                          words["login"],
                          style: AppTextStyle.regularTitle22.copyWith(
                              color:
                                  PaletteColors.blackAppColor.withAlpha(900)),
                        ),
                        SizedBox(height: 15),
                        Text(
                          words["nawras"].toUpperCase(),
                          style: TextStyle(
                              fontSize: 34,
                              color: PaletteColors.mainAppColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          words["welcome"],
                          style: AppTextStyle.regularTitle24.copyWith(
                              color:
                                  PaletteColors.blackAppColor.withAlpha(900)),
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Spacer(),
                            SideContainer(
                              width: _width,
                              mContext: context,
                              mIcon: getAppIcons(
                                  asset: AppIcons.salesPerson,
                                  color: PaletteColors.whiteBg,
                                  size: 40),
                              isActivited: current == "sale_person",
                              title: words["sale-person"],
                              value: current,
                              onPressed: () {
                                setState(() {
                                  current = "sale_person";
                                  _width = 140;
                                });
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Spacer(),
                            SideContainer(
                              width: _width,
                              mContext: context,
                              mIcon: getAppIcons(
                                  asset: AppIcons.shop,
                                  color: PaletteColors.whiteBg,
                                  size: 40),
                              isActivited: current == "shop",
                              title: words["shop"],
                              value: current,
                              onPressed: () {
                                setState(() {
                                  current = "shop";
                                  _width = 140;
                                });
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                labelText: words["phone number"],
                                focusedBorder: outlineBorder,
                                errorBorder: outlineBorder,
                                border: outlineBorder),
                            onChanged: (text) {
                              authMap["phone"] = text;
                            },
                            validator: (text) {
                              if (text.length < 7) {
                                return words["number-not-valid"];
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: words["password"],
                                focusedBorder: outlineBorder,
                                errorBorder: outlineBorder,
                                border: outlineBorder),
                            onChanged: (text) {
                              authMap["password"] = text;
                            },
                            validator: (text) {
                              if (text.length < 3) {
                                return words["password-short"];
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RoundedButton(
                              title: words["login"].toString().toUpperCase(),
                              onPressed: onSubmit),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: PaletteColors.whiteBg,
                                  elevation: 4,
                                  title: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        words["note"].toString().toUpperCase(),
                                        style: AppTextStyle.boldTitle24
                                            .copyWith(
                                                color: PaletteColors
                                                    .darkRedColorApp),
                                      )),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          words["forget-password-warning"],
                                          style: AppTextStyle.regularTitle16
                                              .copyWith(
                                                  color: PaletteColors
                                                      .blackAppColor),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        RoundedButton(
                                          title: words["cancel"],
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          isThikHeight: true,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              words["forget something"],
                              style: AppTextStyle.regularTitle18.copyWith(
                                  color: PaletteColors.blackAppColor
                                      .withAlpha(900)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Consumer<AuthProvider>(
                builder: (_, auth, __) => auth.isLoading
                    ? Container(
                        color: Colors.black26,
                        alignment: Alignment.center,
                        child: LoadingIndicator())
                    : SizedBox(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SideContainer extends StatelessWidget {
  final BuildContext mContext;
  final SvgPicture mIcon;
  final bool isActivited;
  final String value;
  final String title;
  final Function onPressed;
  final double width;

  const SideContainer({
    Key key,
    @required this.mContext,
    @required this.mIcon,
    @required this.isActivited,
    @required this.value,
    @required this.width,
    this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        width: isActivited ? width : 50,
        height: 50,
        decoration: BoxDecoration(
          color: isActivited
              ? PaletteColors.mainAppColor
              : PaletteColors.blackAppColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: isActivited
            ? Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    mIcon,
                    Expanded(
                      child: Text(
                        title.split(" ").isEmpty
                            ? title.split(" ")[0] + "\n" + title.split(" ")[1]
                            : title,
                        style: AppTextStyle.semiBoldTitle16.copyWith(
                          color: PaletteColors.whiteBg,
                        ),
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ))
            : mIcon,
        duration: Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn,
      ),
    );
  }
}
