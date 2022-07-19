import 'package:flutter/material.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:provider/provider.dart';

class TextLang extends StatelessWidget {
  final String krLabel;
  final String enLabel;
  final String arLabel;
  final TextStyle style;

  const TextLang(
      {Key key,
      @required this.krLabel,
      @required this.enLabel,
      @required this.arLabel,
      this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageCode =
        Provider.of<Language>(context, listen: false).languageCode;
    return Text(
      languageCode == 'kr'
          ? krLabel
          : languageCode == 'en'
              ? enLabel
              : arLabel,
      style: style == null ? TextStyle() : style,
    );
  }
}
