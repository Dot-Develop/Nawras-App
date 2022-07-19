import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GlobalAppBar extends AppBar implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) => AppBar(
        title: Image.asset(
          'assets/app_logo/Logo Zaman.png',
          height: 70,
          width: 200,
        ),
        elevation: 11,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          )
        ],
      );
}
