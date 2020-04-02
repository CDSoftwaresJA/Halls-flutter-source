import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showToast(String message, BuildContext context) {
  Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    message: message,
    animationDuration: Duration(milliseconds: 300),
    icon: Icon(
      Icons.info_outline,
      size: 28.0,
      color: Colors.blue[300],
    ),
    duration: Duration(seconds: 3),
  )..show(context);
}
