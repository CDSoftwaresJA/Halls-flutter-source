import 'package:flutter/material.dart';
import 'package:hallandroidsource/rq.dart';
import 'package:hallandroidsource/upload.dart';
import 'createaccount.dart';
import 'dialogs.dart';
import 'login.dart';
import 'musicplayer.dart';

class SettingsList {
  BuildContext context;
  RequestBuilder requests;
  Dialogs dialogs;
  SettingsList(this.context){
   requests=new RequestBuilder(context);
   dialogs= new Dialogs(context);

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
        ListTile(
          title: Text("Create Dialog"),
          subtitle: Text("-Create Dialog-"),
          leading: Icon(Icons.desktop_windows),
          onTap: () {
            dialogs.ShowD("Test", "Body");
          },
        ),
        ListTile(
          title: Text("Play Song"),
          subtitle: Text("-Play Song -"),
          leading: Icon(Icons.play_arrow),
          onTap: () {
            play();
          },
        ),
        ListTile(
          title: Text("Show users"),
          subtitle: Text("-Show users -"),
          leading: Icon(Icons.account_circle),
          onTap: () {
            requests.makeGetRequest(
                "http://hall-server-master-dev.us-west-2.elasticbeanstalk.com/public/get-user");
          },
        ),
        ListTile(
          title: Text("Show songs"),
          subtitle: Text("-Show songs -"),
          leading: Icon(Icons.queue_music),
          onTap: () {
            requests.makeGetRequest(
                "http://hall-server-master-dev.us-west-2.elasticbeanstalk.com/public/get-song");
          },
        ),
      ],
    );
    return listview;
  }
}
