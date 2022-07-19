import 'package:flutter/material.dart';
import 'package:nawras_app/Constants/ColorConstants.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/anims/loading.gif",
        color: PaletteColors.darkRedColorApp,
        scale: 6,
      ),
    );
  }
}

class ImageLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/anims/loading.gif",
        color: PaletteColors.darkRedColorApp,
        scale: 6,
        width: 50,
        height: 50,
      ),
    );
  }
}
