import 'package:flutter/material.dart';
import 'package:nawras_app/Constants/AppTextStyle.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';
import 'package:nawras_app/Constants/CustomIcons.dart';
import 'package:nawras_app/GlobalWidgets/Direction.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:provider/provider.dart';

class ShopMapCard extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color color;

  const ShopMapCard({
    Key key,
    @required this.title,
    @required this.onPressed,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isActive = PaletteColors.redColorApp == color;
    String languageDir = Provider.of<Language>(context).languageDirection;
    return Direction(
      child: Padding(
        padding: languageDir == 'ltr'
            ? EdgeInsets.fromLTRB(10, 10, isActive ? 10 : 40, 10)
            : EdgeInsets.fromLTRB(isActive ? 10 : 40, 10, 10, 10),
        child: Material(
          elevation: 3,
          shadowColor: isActive
              ? PaletteColors.redColorApp.withOpacity(0.2)
              : PaletteColors.whiteBg.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              contentPadding: isActive
                  ? EdgeInsets.all(7)
                  : EdgeInsets.fromLTRB(8, 0, 8, 0),
              leading: CircleAvatar(
                radius: isActive ? 25 : 22,
                child: CircleAvatar(
                  radius: isActive ? 24 : 21,
                  backgroundImage: NetworkImage(
                    'https://www.vmcdn.ca/f/files/shared/food/adobe-stock-food-market.jpeg',
                  ),
                ),
              ),
              onTap: onPressed,
              title: Text(
                title,
                style: AppTextStyle.boldTitle16.copyWith(
                    color: PaletteColors.blackAppColor,
                    fontSize: isActive ? 18 : 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: getAppIcons(
                asset: AppIcons.map,
                color: PaletteColors.redColorApp,
                size: isActive ? 28 : 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
