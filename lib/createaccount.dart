import 'package:flutter/material.dart';
import 'package:hallsmusic/rq.dart';
import 'package:hallsmusic/appbar.dart';
class CreateAccount extends StatelessWidget {
  final username = TextEditingController(),
      password = TextEditingController(),
      email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: makeAppBar('Create Account'),
        body: Center(
            child: new ListView(
              children: <Widget>[
                TextField(
                  obscureText: false,
                  controller: email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
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
                  child: Text('Create Account: '),
                  onPressed: () {
                    String json = '{"email": "' +
                        email.text +
                        '", "password": "' +
                        password.text +
                        '","name": "' +
                        username.text +
                        '","type": "User"}';
                    RequestBuilder request = new RequestBuilder(context);
                    request.makePostRequest(
                        'http://hall-server-master-dev.us-west-2.elasticbeanstalk.com/public/add-user',
                        json);
                    Navigator.pop(context);
                  },
                ),
              ],
            )));
  }
}