import 'package:flutter/material.dart';
import 'package:hallsmusic/utils/toasts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/appbar.dart';
import '../utils/links.dart';
import '../utils/rq.dart';
import 'createaccount.dart';
import 'package:flutter/cupertino.dart';

class Login extends StatelessWidget {
  TextEditingController username = TextEditingController(),
      password = TextEditingController();

  BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    final style = TextStyle(color: Colors.black);
    return CupertinoPageScaffold(
      backgroundColor: Colors.black,
      navigationBar: makeCupertinoAppBar('Login'),
      child: SafeArea(
          child: Material(
              color: backGroundColor(),
              child: new Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  CupertinoTextField(
                    obscureText: false,
                    controller: username,
                    style: style,
                    decoration: textFieldStyle(),
                    placeholderStyle: style,
                    placeholder: "Username",
                    maxLength: 10,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CupertinoTextField(
                    obscureText: true,
                    controller: password,
                    style: style,
                    decoration: textFieldStyle(),
                    placeholderStyle: style,
                    placeholder: "Password",
                    maxLength: 30,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    child: Text('Login'),
                    onPressed: () {
                      String json = '{"password":"' +
                          password.text +
                          '","username":"' +
                          username.text +
                          '"}';

                      makePostRequest(addEndpoint("login"), json);
                    },
                  ),
                  RaisedButton(
                    child: Text('Create Account'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => CreateAccount()));
                    },
                  ),
                ],
              ))),
    );
  }

  makePostRequest(String url, String jsonFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {"Content-type": "application/json"};
    Response response = await post(url,
        headers: headers,
        body: jsonFile); // check the status code for the result
    int statusCode = response
        .statusCode; // this API passes back the id of the new item added to the body
    //showToast(response.body);
    if (response.body == 'success') {
      prefs.setString('username', username.text);
      prefs.setString('password', password.text);
      showToast('Login Successful', context);
      //Navigator.pop(context);
    } else {
      showToast('Login Failed', context);
    }
    //var body = json.decode(response.body);
    //body = body['items'];
    print(response.body);
  }
}
