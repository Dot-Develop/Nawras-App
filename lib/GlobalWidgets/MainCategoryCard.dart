import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'LoadingIndicator.dart';

class MainCategoryCard extends StatelessWidget {
  final String image;
  final String title;
  final Function onPressed;

  const MainCategoryCard({
    Key key,
    @required this.image,
    @required this.title,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              image,
              width: double.infinity,
              height: 150,
              fit: BoxFit.contain,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return ImageLoadingIndicator();
              },
            ),
            SizedBox(height: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
