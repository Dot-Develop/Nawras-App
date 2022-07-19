import 'package:flutter/cupertino.dart';
import 'package:nawras_app/Helper/Language.dart';
import 'package:provider/provider.dart';

class Direction extends StatelessWidget {
  final Widget child;

  Direction({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Provider.of<Language>(context).languageDirection == 'rtl'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: child,
    );
  }
}
