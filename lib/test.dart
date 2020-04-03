import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hallsmusic/utils/appbar.dart';
import 'package:hallsmusic/utils/toasts.dart';

class Test extends StatefulWidget{
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
   FirebaseAuth _auth = FirebaseAuth.instance;
   GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
   _auth = FirebaseAuth.instance;
   googleSignIn = GoogleSignIn();
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: makeCupertinoAppBar("Experiments"),
      child: SafeArea(child: Material(
          color: backGroundColor(),
          child: Column(children: <Widget>[
            RaisedButton(
              child: Text('Create Account'),
              onPressed: () async {
                createAccountEmailAndPassword('cduncan@konnexx.net','Damdog101');

              },
            ),
            RaisedButton(
              child: Text('Email Verification'),
              onPressed: () async {
                sendEmailVerification('cduncan@konnexx.net','Damdog101');

              },
            ),
            RaisedButton(
              child: Text('Password Reset'),
              onPressed: () async {
                resetPassword('cduncan@konnexx.net');

              },
            ),
            RaisedButton(
              child: Text('Google Sign in'),
              onPressed: () async {
               handleSignIn();
              },
            ),
            RaisedButton(
              child: Text('Add Song'),
              onPressed: () async {
                Firestore.instance.collection('songs').document()
                    .setData({ 'email': 'email', 'genre': 'genre','name': 'name','picture': 'picture','song': 'song' });
              },
            ),
            RaisedButton(
              child: Text('Get Songs'),
              onPressed: () async {
                Firestore.instance
                    .collection('songs')
                    .where("name", isEqualTo: "name")
                    .snapshots()
                    .listen((data) =>
                    data.documents.forEach((doc) => print(doc["email"])));
              },
            ),
            RaisedButton(
              child: Text('Get Users'),
              onPressed: () async {
                Firestore.instance
                    .collection('users')
                    .snapshots()
                    .listen((data) =>
                    data.documents.forEach((doc) => print(doc["username"])));
              },
            ),

          ],)
      ),),
    );
  }

  resetPassword(String email) async {
    _auth.sendPasswordResetEmail(email: email);
  }

  createAccountEmailAndPassword(String email,String password) async {
    try {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
    email:email,
    password: password,
    ))
    .user;
    user.sendEmailVerification();
  } catch (error){
  showToast(error.toString(), context);
  }
  }

  sendEmailVerification(String email,String password) async {
    try {
      final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
        email:email,
        password: password,
      ))
          .user;
      user.sendEmailVerification();

    } catch (error){
      showToast(error.toString(), context);
    }
  }

  Future<FirebaseUser> handleSignIn() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }
}