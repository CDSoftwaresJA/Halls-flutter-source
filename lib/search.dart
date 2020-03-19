import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hallandroidsource/rq.dart';
import 'account.dart';
import 'dialogs.dart';

class SearchScreen {
  Dialogs dialogs;
  RequestBuilder requestBuilder;
  SearchScreen(BuildContext context){
    dialogs = new Dialogs(context);
    requestBuilder = new RequestBuilder(context);
  }
  Widget getSearchScreen() {
    List<Account> list = [];
    final search = TextEditingController();
    @override
    _makePostRequest(String url, String jsonFile) async {
//      Map<String, String> headers = {"Content-type": "application/json"};
//      Response response = await post(url,
//          headers: headers,
//          body: jsonFile); // check the status code for the result
//      int statusCode = response
//          .statusCode; // this API passes back the id of the new item added to the body
//      var body = json.decode(response.body);
//      body = body['items'];
//      for (var item in body) {
//        list.add(new Account.fromJson(item));
//        print(item['email']);
//      }
//      dialogs.ShowDLV("Search Results", list);
//      //_showDialog("JSON POST", getPrettyJSONString(body));
    }

    return Column(children: <Widget>[
      TextField(
        controller: search,
        obscureText: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Search',
        ),
      ),
      RaisedButton(
        child: Text('Search Users'),
        onPressed: () {
          list = [];
          String json = '{"field": "name", "value": "' + search.text + '"}';
          requestBuilder.makePostRequest(
              'http://hall-server-master-dev.us-west-2.elasticbeanstalk.com/public/find-user',
              json);
        },
      ),
      RaisedButton(
        child: Text('Search Songs'),
        onPressed: () {
          list = [];
          String json = '{"field": "name", "value": "' + search.text + '"}';
          requestBuilder.makePostRequest(
              'http://hall-server-master-dev.us-west-2.elasticbeanstalk.com/public/find-song',
              json);
        },
      ),
    ]);
  }
}
