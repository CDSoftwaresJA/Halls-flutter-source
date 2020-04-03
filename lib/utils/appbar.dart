import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget makeAppBar(String title, bool showBack) {
  return PreferredSize(
    preferredSize: Size.fromHeight(40),
    child: AppBar(
      automaticallyImplyLeading: showBack,
      centerTitle: true,
      title: Text(title),
      backgroundColor: backGroundColor(),
      elevation: 0.0,
    ),
  );
}

makeCupertinoAppBar(String title) {
  return CupertinoNavigationBar(
    backgroundColor: Colors.black.withOpacity(0),
    middle: Text(title),
  );
}

textFieldStyle() {
  return BoxDecoration(
    color: Colors.white,
  );
}

textInFieldStyle() {
  return TextStyle(color: Colors.black);
}

textStyle() {
  return TextStyle(color: Colors.white);
}

iconStyle() {
  return Colors.white;
}

backGroundColor() {
  return Colors.black;
}

brightness() {
  return Brightness.dark;
}

animationDuration() {
  return Duration(milliseconds: 500);
}

getSpinKit() {
  return CircularProgressIndicator(
    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
  );
}

panelColor() {
  return Colors.black;
}
