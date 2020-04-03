import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hallsmusic/utils/appbar.dart';
import 'package:hallsmusic/utils/rq.dart';
import '../utils/links.dart';

class CreateAccount extends StatelessWidget {
  final username = TextEditingController(),
      password = TextEditingController(),
      email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int chosen = 0;
    List<Text> list = <Text>[
      Text("User"),
      Text("Artiste"),
      Text("Producer"),

    ];
    final style = TextStyle(color: Colors.black);
    return CupertinoPageScaffold(
        navigationBar: makeCupertinoAppBar('Create Account'),
        child: Material(
            color: backGroundColor(),
            child: new ListView(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                CupertinoTextField(
                  obscureText: false,
                  controller: email,
                  style: style,
                  decoration: textFieldStyle(),
                  placeholderStyle: style,
                  placeholder: "Email Address",
                  maxLength: 30,
                ),
                SizedBox(
                  height: 20,
                ),
                CupertinoTextField(
                  obscureText: false,
                  style: style,
                  decoration: textFieldStyle(),
                  placeholderStyle: style,
                  placeholder: "Username",
                  controller: username,
                  maxLength: 10,
                ),
                SizedBox(
                  height: 20,
                ),
                CupertinoTextField(
                  obscureText: true,
                  style: style,
                  decoration: textFieldStyle(),
                  placeholderStyle: style,
                  placeholder: "Password",
                  controller: password,
                  maxLength: 10,
                ),
                SizedBox(
                  height: 20,
                ),
                CupertinoPicker(
                  magnification: 1,
                  backgroundColor: backGroundColor(),
                  itemExtent: 50,
                  looping: true,
                  onSelectedItemChanged: (int index) {
                    chosen = index;
                  },
                  children: list,
                ),
                RaisedButton(
                  child: Text('Create Account: '),
                  onPressed: () {
                    String email = this.email.text;
                    String password = this.password.text;
                    String username = this.username.text;
                    String json = '{"email": "' +
                        email +
                        '", "password": "' +
                        password +
                        '","name": "' +
                        username +
                        '","type": "'+list[chosen].data+'"}';

                    String jsonEmail = '{'
                        '"message":"Your account has been created!",'
                        '"to":"$email",'
                        '"subject":"Halls Music Registration"}';
                    RequestBuilder request = new RequestBuilder(context);
                    request.makePostRequest(addEndpoint("add-user"), json);
                    request.makePostRequest(
                        addEndpoint("send-email"), jsonEmail);
                    Navigator.pop(context);
                  },
                ),
              ],
            )));
  }
}
