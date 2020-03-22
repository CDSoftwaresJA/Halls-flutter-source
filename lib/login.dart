import 'package:flutter/material.dart';
import 'package:hallsmusic/createaccount.dart';
import 'package:hallsmusic/toasts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appbar.dart';
import 'links.dart';
import 'rq.dart';

class Login extends StatelessWidget {
  TextEditingController username = TextEditingController(),
      password = TextEditingController();
  RequestBuilder requests;
  @override
  Widget build(BuildContext context) {
    requests = new RequestBuilder(context);
    return Scaffold(
        appBar: makeAppBar('Login', false),
        body: Center(
            child: new ListView(
          children: <Widget>[
            TextField(
              obscureText: false,
              controller: username,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            TextField(
              obscureText: true,
              controller: password,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
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
                Navigator.pop(context);
              },
            ),
            RaisedButton(
              child: Text('Create Account'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CreateAccount()),
                );
              },
            ),
          ],
        )));
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
      showToast('Login Successful');
    } else {
      showToast('Login Failed');
    }
    //var body = json.decode(response.body);
    //body = body['items'];
    print(response.body);
  }
}
