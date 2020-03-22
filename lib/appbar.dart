import 'package:flutter/material.dart';
import 'package:hallsmusic/account.dart';

Widget makeAppBar(String title, bool showBack) {
  return AppBar(
    automaticallyImplyLeading: showBack,
    centerTitle: true,
    title: Text(title),
    backgroundColor: Colors.black,
    elevation: 0.0,
  );
}

Future<List<Account>> search(String text) async {}
