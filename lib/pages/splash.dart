import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hallsmusic/settings/login.dart';
import 'package:hallsmusic/utils/appbar.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: makeCupertinoAppBar("Halls Music"),
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
            ),
            SpinKitCubeGrid(
              color: iconStyle(),
              size: 50,
            ),
            Spacer(),
            FlatButton(
              child: Text("Go to App", style: textStyle()),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => MyStatefulWidget()));
              },
            ),
            FlatButton(
              child: Text("Login", style: textStyle()),
              onPressed: () {
                Navigator.push(
                    context, CupertinoPageRoute(builder: (context) => Login()));
              },

            ),
          ],
        ),
      ),
    );
  }
}
