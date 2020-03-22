import 'package:flutter/material.dart';
import 'package:hallsmusic/rq.dart';
import 'package:hallsmusic/appbar.dart';

import 'links.dart';

class CreateAccount extends StatelessWidget {
  final username = TextEditingController(),
      password = TextEditingController(),
      email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: makeAppBar('Create Account', true),
        body: Center(
            child: new ListView(
          children: <Widget>[
            TextField(
              obscureText: false,
              controller: email,
              maxLength: 30,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            TextField(
              obscureText: false,
              controller: username,
              maxLength: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            TextField(
              obscureText: true,
              controller: password,
              maxLength: 10,
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
                request.makePostRequest(addEndpoint("add-user"), json);
                Navigator.pop(context);
              },
            ),
          ],
        )));
  }
}
