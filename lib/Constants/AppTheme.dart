// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class AppTheme {
//   //Colors of the whole application
//   static const Color button = Colors.lightBlueAccent;
//   static const Color secondaryBg = Colors.lightBlueAccent;
//   static const Color primary = Colors.black54;
//   static Color secondary = Color(0xFFeeeee).withOpacity(0.3);
//   static const Color headlineTextColor = Colors.black;
//   static const Color subTitleTextColor = Color(0xFF242424);
//   static const Color bg = Color(0xFFeeeeee);
//   static const Color secondaryBg2 = Colors.white;
//   static Color shadow = Colors.white;
//   static const deleteButton = Colors.red;
//   static const editButton = Colors.blue;
//
//   //light theme of the application
//   static final ThemeData lightTheme = ThemeData(
//     scaffoldBackgroundColor: AppTheme.bg,
//     backgroundColor: AppTheme.bg,
//     brightness: Brightness.light,
//     primaryColor: AppTheme.headlineTextColor,
//     textTheme: lightTextTheme,
//     appBarTheme: AppBarTheme(
//       brightness: Brightness.light,
//       color: Color(0xffeeeeee),
//       textTheme: TextTheme(title: _headline2),
//       elevation: 5,
//       // shadowColor: Colors.transparent,
//       iconTheme: IconThemeData(color: Colors.black),
//     ),
//   );
//
//   //dark theme of the whole application
//   static final ThemeData darkTheme = ThemeData(
//     scaffoldBackgroundColor: Colors.black12,
//     shadowColor: Colors.black,
//     brightness: Brightness.dark,
//     primaryColor: AppTheme.bg,
//     textTheme: darkTextTheme,
//     accentColorBrightness: Brightness.dark,
//     appBarTheme: AppBarTheme(
//       elevation: 1,
//       iconTheme: IconThemeData(color: Colors.white),
//       color: Colors.white10,
//       textTheme: TextTheme(
//         title: _headline2.copyWith(color: Colors.white),
//       ),
//     ),
//   );
//
//   //Dark Text theme of the application
//   static final TextTheme darkTextTheme = TextTheme(
//     headline1: _headline1.copyWith(color: Colors.white),
//     headline2: _headline2.copyWith(color: Colors.white),
//     headline3: _headline3.copyWith(color: Colors.white),
//     headline4: _headline4.copyWith(color: Colors.white),
//     headline5: _headline5.copyWith(color: Colors.white),
//     headline6: _headline6.copyWith(color: Colors.white),
//     button: _button.copyWith(color: AppTheme.headlineTextColor),
//     subtitle1: _subtitle1.copyWith(color: Colors.white),
//     subtitle2: _subtitle2.copyWith(color: Colors.white),
//     bodyText1: _bodyText1.copyWith(color: AppTheme.primary),
//     bodyText2: _bodyText2.copyWith(color: AppTheme.secondaryBg),
//   );
//
//   //Light dark theme of the application
//   static final TextTheme lightTextTheme = TextTheme(
//     headline1: _headline1,
//     headline2: _headline2,
//     headline3: _headline3,
//     headline4: _headline4,
//     headline5: _headline5,
//     headline6: _headline6,
//     button: _button,
//     subtitle1: _subtitle1,
//     subtitle2: _subtitle2,
//     bodyText1: _bodyText1,
//     bodyText2: _bodyText2,
//   );
//
//   static final TextStyle _headline1 = TextStyle(
//     color: AppTheme.headlineTextColor,
//     fontWeight: FontWeight.w900,
//     fontFamily: "Oriya-MN",
//     fontSize: 35,
//   );
//   static final TextStyle _headline2 = TextStyle(
//     fontFamily: "Oriya-MN",
//     color: AppTheme.headlineTextColor,
//     fontWeight: FontWeight.w900,
//     fontSize: 20,
//   );
//   static final TextStyle _headline3 = TextStyle(
//     fontFamily: "Oriya-MN",
//     color: AppTheme.headlineTextColor,
//     fontWeight: FontWeight.w900,
//     fontSize: 16,
//   );
//   static final TextStyle _headline4 = TextStyle(
//     fontFamily: "Oriya-MN",
//     color: AppTheme.headlineTextColor,
//     fontSize: 16,
//   );
//   static final TextStyle _headline5 = TextStyle(
//     fontFamily: "Oriya-MN",
//     color: AppTheme.subTitleTextColor,
//     fontWeight: FontWeight.w900,
//     fontSize: 14,
//   );
//   static final TextStyle _headline6 = TextStyle(
//     fontFamily: "Oriya-MN",
//     color: AppTheme.subTitleTextColor,
//     fontWeight: FontWeight.w900,
//     fontSize: 12,
//   );
//
//   static final TextStyle _button = TextStyle();
//
//   static final TextStyle _subtitle1 = TextStyle(
//     fontFamily: "Oriya-MN",
//     color: AppTheme.subTitleTextColor,
//     fontSize: 18,
//   );
//   static final TextStyle _subtitle2 = TextStyle(
//     fontFamily: "Oriya-MN",
//     color: AppTheme.subTitleTextColor.withOpacity(0.5),
//     fontSize: 14,
//   );
//
//   static final TextStyle _bodyText1 = TextStyle(
//     fontFamily: "Oriya-MN",
//     color: AppTheme.subTitleTextColor,
//     fontWeight: FontWeight.w900,
//     fontSize: 9,
//   );
//
//   static final TextStyle _bodyText2 = TextStyle();
// }
