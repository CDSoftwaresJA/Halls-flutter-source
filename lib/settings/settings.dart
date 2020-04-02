import 'package:flutter/material.dart';
import 'package:hallsmusic/main.dart';
import 'package:hallsmusic/settings/profile.dart';
import 'package:hallsmusic/settings/upload.dart';
import 'package:hallsmusic/utils/appbar.dart';
import 'package:hallsmusic/utils/toasts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/splash.dart';
import 'createaccount.dart';
import 'package:flutter/cupertino.dart';
import 'login.dart';
import '../utils/musicplayer.dart';

class SettingsList extends StatefulWidget {
  final Function toProfile;
  final Function logOut;

  const SettingsList({Key key, this.toProfile, this.logOut}) : super(key: key);
  @override
  _SettingsListState createState() => _SettingsListState();
}

class _SettingsListState extends State<SettingsList> {
  bool loggedIn = true;
  SharedPreferences sharedPreferences;
  Widget getSettingsList() {
    var listView = ListView(
      children: <Widget>[
        ListTile(
          title: Text(
            "View/Edit Profile",
            style: textStyle(),
          ),
          leading: Icon(
            Icons.perm_identity,
            color: iconStyle(),
          ),
          onTap: () async {
            if (sharedPreferences.getString("username") != null) {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (context) => Profile()));
            } else {
              showToast("Please login to edit profile.", context);
            }
          },
        ),
        ListTile(
          title: Text(
            "My Music",
            style: textStyle(),
          ),
          leading: Icon(
            Icons.music_video,
            color: iconStyle(),
          ),
          onTap: () async {
            if (sharedPreferences.getString("username") != null) {
              widget.toProfile();
            } else {
              showToast("Please login to view your songs.", context);
            }
          },
        ),
        ListTile(
          title: Text(
            "Upload Song",
            style: textStyle(),
          ),
          leading: Icon(
            Icons.file_upload,
            color: iconStyle(),
          ),
          onTap: () async {
            if (sharedPreferences.getString("username") != null) {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => UploadSong()),
              );
            } else {
              showToast("Please login to upload songs.", context);
            }
          },
        ),
        ListTile(
          title: Text(
            "Profile Statistics",
            style: textStyle(),
          ),
          leading: Icon(
            Icons.info,
            color: iconStyle(),
          ),
          onTap: () {
            showToast("Not Implemented", context);
          },
        ),
        ListTile(
          title: Text(
            "Log out",
            style: textStyle(),
          ),
          leading: Icon(
            Icons.exit_to_app,
            color: iconStyle(),
          ),
          onTap: () {
            widget.logOut();
          },
        ),
      ],
    );
    return Material(
      color: backGroundColor(),
      child: listView,
    );
  }

  makeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    makeSharedPreferences();
    return CupertinoPageScaffold(
      navigationBar: makeCupertinoAppBar("Settings"),
      child: getSettingsList(),
    );
  }
}
