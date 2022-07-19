import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Constants/CustomIcons.dart';
import 'package:nawras_app/GlobalWidgets/Direction.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:provider/provider.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final words = Provider.of<Language>(context).words;

    return Direction(
      child: Scaffold(
        backgroundColor: PaletteColors.mainAppColor,
        // appBar: AppBar(title:Text(words["about"]) ,),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                AppIcons.bgg,
              ),
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.1), BlendMode.dstATop),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      title: Text(
                        words["contact"],
                        style: AppTextStyle.boldTitle20
                            .copyWith(color: PaletteColors.whiteBg),
                      ),
                      leading: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Provider.of<Language>(context).languageCode ==
                                  "en"
                              ? getAppIcons(
                                  asset: AppIcons.back,
                                  size: 40,
                                  color: PaletteColors.whiteBg)
                              : Icon(Icons.arrow_back_ios,
                                  size: 40, color: PaletteColors.whiteBg)),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            words["contact-us"],
                            style: AppTextStyle.boldTitle34
                                .copyWith(color: PaletteColors.whiteBg),
                          ),
                          Container(
                            margin: EdgeInsets.all(4),
                            height: 3,
                            width: 200,
                            color: PaletteColors.whiteBg,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(30.0),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: PaletteColors.darkRedColorApp,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            ListTile(
                              leading: getAppIcons(
                                  asset: AppIcons.language,
                                  color: PaletteColors.whiteBg),
                              title: Text(
                                "INFO@Dot-Develop.Com",
                                style: AppTextStyle.regularTitle20
                                    .copyWith(color: PaletteColors.whiteBg),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            ListTile(
                              leading: getAppIcons(
                                  asset: AppIcons.language,
                                  color: PaletteColors.whiteBg),
                              title: Text(
                                "WWW.Dot-Develop.Com",
                                style: AppTextStyle.regularTitle20
                                    .copyWith(color: PaletteColors.whiteBg),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            ListTile(
                              leading: getAppIcons(
                                  asset: AppIcons.language,
                                  color: PaletteColors.whiteBg),
                              title: Text(
                                "Bhirka Road - Erbil",
                                style: AppTextStyle.regularTitle20
                                    .copyWith(color: PaletteColors.whiteBg),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            ListTile(
                              leading: getAppIcons(
                                  asset: AppIcons.language,
                                  color: PaletteColors.whiteBg),
                              title: Text(
                                "+9647500000000",
                                style: AppTextStyle.regularTitle20
                                    .copyWith(color: PaletteColors.whiteBg),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                right: -6,
                left: 0,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationX(pi),
                  child: CustomPaint(
                    child: Container(
                      height: 500.0,
                    ),
                    painter: CurvePainter(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = new Path();
    Paint paint = Paint();

    path.lineTo(0, size.height / 4.25);
    var firstControlPoint = new Offset(size.width / 4, size.height / 3);
    var firstEndPoint = new Offset(size.width / 2, size.height / 3 - 60);
    var secondControlPoint =
        new Offset(size.width - (size.width / 4), size.height / 4 - 65);
    var secondEndPoint = new Offset(size.width, size.height / 3 - 40);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 3);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = PaletteColors.whiteBg;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
