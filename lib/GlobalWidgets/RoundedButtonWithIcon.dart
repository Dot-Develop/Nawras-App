import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Constants/CustomIcons.dart';

class RoundedButtonWithIcon extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color bgColor;
  final Color textColor;
  final String icon;
  final double border;

  const RoundedButtonWithIcon({
    Key key,
    @required this.title,
    @required this.onPressed,
    @required this.icon,
    @required this.border,
    @required this.bgColor,
    @required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(border),
          side: BorderSide(
            color: Colors.grey[500],
          )),
      onPressed: onPressed,
      color: bgColor,
      textColor: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getAppIcons(asset: icon, color: PaletteColors.whiteBg, size: 25),
          SizedBox(
            width: 6,
          ),
          Text(title, style: TextStyle(fontSize: 14, color: textColor)),
        ],
      ),
    );
  }
}
