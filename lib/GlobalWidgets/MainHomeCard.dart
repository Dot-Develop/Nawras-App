// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:zamann/Constants/ColorConstants.dart';
// import 'package:zamann/Constants/TextStyleConstants.dart';
// import 'package:zamann/GlobalWidgets/Responsive.dart';
//
// class MainCategoryCard extends StatelessWidget {
//   final String text;
//   final Widget SvgIcon;
//   final Function onPressed;
//
//   MainCategoryCard(
//       {@required this.text, @required this.SvgIcon, @required this.onPressed});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialButton(
//       padding: EdgeInsets.all(6),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
//       height: 200,
//       elevation: 1,
//       highlightColor: PaletteColors.mainAppColor.withOpacity(0.3),
//       color: Colors.white,
//       onPressed: onPressed,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SvgIcon,
//           SizedBox(height: 8),
//           Text(
//             text,
//             style: AppTextStyle.mainCategoryTextStyle,
//             overflow: TextOverflow.ellipsis,
//           )
//         ],
//       ),
//     );
//   }
// }
