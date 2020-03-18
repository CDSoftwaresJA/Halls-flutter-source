import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
//void main() => runApp(new MyApp());
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
  }

  void showShortToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIos: 1);
  }
  _makePostRequest() async {
    // set up POST request arguments
    String url = 'http://hall-server-master-dev.us-west-2.elasticbeanstalk.com/public/add-user';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"email": "eduncan@konnexx.net", "password": "password123","name": "eduncan","type": "Admin"}'; // make POST request
    Response response = await post(url, headers: headers,body:json); // check the status code for the result
    int statusCode = response.statusCode; // this API passes back the id of the new item added to the body
    String body = response.body;
    showShortToast('Posted');
    // {
    //   "title": "Hello",
    //   "body": "body text",
    //   "userId": 1,
    //   "id": 101
    // }}

  }
  _makeGetRequest() async {  // make GET request
    String url = 'http://hall-server-master-dev.us-west-2.elasticbeanstalk.com/public/get-user';
    Response response = await get(url);  // sample info available in response
    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String contentType = headers['content-type'];
    String json = response.body;  // TODO convert json to object...
    showShortToast(json);
  }

  void getJson(){
    _makeGetRequest();
  }
  void postJson(){
    _makePostRequest();
  }


  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('HALL Music'),
        ),
        body: new Center(

          child:
          new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new RaisedButton(
                    child: new Text('GET'),
                    onPressed: getJson),
              ),

              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new RaisedButton(
                    child: new Text('POST'),
                    onPressed: postJson),
              ),

            ],
          ),
        ),
      ),
    );
  }
}