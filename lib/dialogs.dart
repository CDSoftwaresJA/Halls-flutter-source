import 'package:flutter/material.dart';
import 'package:hallsmusic/song.dart';
import 'package:hallsmusic/toasts.dart';

import 'account.dart';
import 'musicplayer.dart';

class Dialogs {
  BuildContext context;
  Dialogs(this.context);

  ShowD(String title, String body) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new SingleChildScrollView(child: new Text(body)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
