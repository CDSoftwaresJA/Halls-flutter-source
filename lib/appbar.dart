import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:hallsmusic/account.dart';

Widget makeAppBar(String title) {
  return AppBar(
    title: Text(title),
    backgroundColor: Colors.black,
    elevation: 0.0,
  );
}

Widget makeSearchAppBar(String title) {
  return SearchBar<Account>(
    onSearch: search,
  );
}

Future<List<Account>> search(String text) async {}
