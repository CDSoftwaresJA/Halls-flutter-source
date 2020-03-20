import 'package:flutter/material.dart';
import 'package:hallsmusic/rq.dart';
import 'package:hallsmusic/upload.dart';
import 'createaccount.dart';
import 'dialogs.dart';
import 'login.dart';
import 'musicplayer.dart';

class SettingsList {
  BuildContext context;
  RequestBuilder requests;
  Dialogs dialogs;
  SettingsList(this.context) {
    requests = new RequestBuilder(context);
    dialogs = new Dialogs(context);
  }
  Widget getSettingsList() {
    var listview = ListView(
      children: <Widget>[
        ListTile(
          title: Text("Create new Account"),
          subtitle: Text("-Create Account-"),
          leading: Icon(Icons.person_outline),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateAccount()),
            );
          },
        ),
        ListTile(
          title: Text("Upload Song"),
          subtitle: Text("-Upload Song-"),
          leading: Icon(Icons.file_upload),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UploadSong()),
            );
          },
        ),
        ListTile(
          title: Text("Login"),
          subtitle: Text("-Login-"),
          leading: Icon(Icons.account_circle),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          },
        ),
      ],
    );
    return listview;
  }
}
