import 'package:flutter/material.dart';
import 'appbar.dart';
import 'rq.dart';
Widget appBar(String title) {
  return AppBar(
    title: Text(title),
    backgroundColor: Colors.black,
    elevation: 0.0,
  );
}
class Login extends StatelessWidget {
  final username = TextEditingController(), password = TextEditingController();
  RequestBuilder requests;
  @override
  Widget build(BuildContext context) {
    requests= new RequestBuilder(context);
    return Scaffold(
        appBar: makeAppBar('Login'),
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
                    requests.makePostRequest(
                        'http://hall-server-master-dev.us-west-2.elasticbeanstalk.com/public/login',
                        json);
                    Navigator.pop(context);
                  },
                ),
              ],
            )));
  }
}