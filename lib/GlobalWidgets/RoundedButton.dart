import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color color;
  final double width;
  final double radius;

  final bool isThikHeight;

  const RoundedButton({
    Key key,
    @required this.title,
    @required this.onPressed,
    this.color,
    this.width = double.infinity,
    this.isThikHeight = false,
    this.radius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: Container(
        height: isThikHeight ? height / 25 : height / 16,
        child: MaterialButton(
          color: color == null ? PaletteColors.mainAppColor : color,
          elevation: 12,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: BorderSide(
                  color: PaletteColors.blackAppColor.withOpacity(0.3))),
          onPressed: onPressed,
          textColor: Colors.white,
          child: Text(
            title,
            style: AppTextStyle.semiBoldTitle16,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class RoundedButtonDD extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color color;
  final double height;
  final double radius;

  const RoundedButtonDD({
    Key key,
    @required this.title,
    @required this.onPressed,
    this.color,
    this.height = 50,
    this.radius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
      child: MaterialButton(
        color: color == null ? PaletteColors.mainAppColor : color,
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(
                color: PaletteColors.blackAppColor.withOpacity(0.3))),
        onPressed: onPressed,
        textColor: Colors.white,
        child: Text(title, style: TextStyle(fontSize: 14)),
      ),
    );
  }
}
