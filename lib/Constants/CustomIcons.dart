import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';

SvgPicture getAppIcons({
  @required String asset,
  double size = 40,
  color,
}) {
  return SvgPicture.asset(
    asset,
    width: size,
    height: size,
    color: color == null ? PaletteColors.whiteBg : color,
    fit: BoxFit.contain,
  );
}

class AppIcons {
  static String favoritePng = 'assets/icons/favorite.png';
  static String favorite = 'assets/images/favorite.svg';
  static String favoriteItem = 'assets/images/favorite_Item.svg';
  static String about = 'assets/images/About.svg';
  static String back = 'assets/images/Back.svg';
  static String darkMode = 'assets/images/darkmode.svg';
  static String date = 'assets/images/Date.svg';
  static String feedback = 'assets/images/Feedback.svg';
  static String filter = 'assets/images/Filter.svg';
  static String home = 'assets/images/Home.svg';
  static String language = 'assets/images/Language.svg';
  static String logout = 'assets/images/logout.svg';
  static String manager = 'assets/images/Manager.svg';
  static String market = 'assets/images/Market.svg';
  static String noCard = 'assets/images/nocard.svg';
  static String noNotification = 'assets/images/noNotification.svg';
  static String noFavorite = 'assets/images/no_favorite.svg';
  static String bin = 'assets/images/bin.svg';
  static String notifivations = 'assets/images/Notifivations.svg';
  static String phone = 'assets/images/Phone.svg';
  static String plus = 'assets/images/Plus.svg';
  static String price = 'assets/images/Price.svg';
  static String profile = 'assets/images/Profile.svg';
  static String salesPerson = 'assets/images/Salesperson.svg';
  static String search = 'assets/images/Search.svg';
  static String settings = 'assets/images/Setting.svg';
  static String shop = 'assets/images/Shop.svg';
  static String shop1 = 'assets/images/Shop_1.svg';
  static String shop2 = 'assets/images/Shop_2.svg';
  static String supervisor = 'assets/images/SuperVisor.svg';
  static String update = 'assets/images/Update.svg';
  static String upload = 'assets/icons/upload.svg';
  static String settingsOutline = 'assets/icons/settingoutline.svg';
  static String map = 'assets/icons/map.svg';
  static String homeOutline = 'assets/icons/homeoutline.svg';
  static String favoriteOutline = 'assets/icons/favoriteoutline.svg';
  static String emptyShopCart = 'assets/icons/emptyshopcart.svg';
  static String shopEmpty = 'assets/icons/shopempty.svg';
  static String logoDotDev = 'assets/images/logo.svg';
  static String pattern = 'assets/images/pattern.svg';
  static String pattern2 = 'assets/images/pattern2.svg';
  static String kurdishFlag = 'assets/flags/kurdish.png';
  static String arabicFlag = 'assets/flags/arabic.png';
  static String englishFlag = 'assets/flags/english.png';
  static String bgg = 'assets/images/bgg.png';
  static String noActivity = 'assets/icons/noactivity.svg';
  static String activity = 'assets/icons/activity.svg';
  static String activityOutline = 'assets/icons/activityoutline.svg';
  static String noRequest = 'assets/icons/norequest.svg';
  static String request = 'assets/icons/request.svg';
  static String requestOutline = 'assets/icons/requestoutline.svg';
  static String contact = 'assets/icons/contact.svg';
}
