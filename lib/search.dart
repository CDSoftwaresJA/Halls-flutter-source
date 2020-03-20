import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hallsmusic/rq.dart';
import 'package:hallsmusic/song.dart';
import 'package:http/http.dart';
import 'account.dart';
import 'dialogs.dart';
import 'main.dart';
import 'musicplayer.dart';

class SearchScreen extends StatelessWidget {
  Dialogs dialogs;
  RequestBuilder requestBuilder;
  final BuildContext context;
  final Function(String name) onSearchDone;
  final String value;
  final MusicPlayer musicPlayer;
  SearchScreen(
      {@required this.context,
      @required this.onSearchDone,
      @required this.value,
      @required this.musicPlayer}) {
    dialogs = new Dialogs(context);
    requestBuilder = new RequestBuilder(context);
  }

  Widget getSearchScreen() {
    List<Song> list = [];
    final search = TextEditingController();
    @override
    postRequest(String url, String jsonFile) async {
      Map<String, String> headers = {"Content-type": "application/json"};
      Response response = await post(url,
          headers: headers,
          body: jsonFile); // check the status code for the result
      int statusCode = response
          .statusCode; // this API passes back the id of the new item added to the body
      var body = json.decode(response.body);
      body = body['items'];
      for (var item in body) {
        list.add(new Song.fromJson(item));
        print(item['name']);
      }
      ShowDLV("Search Results", list);
      //_showDialog("JSON POST", getPrettyJSONString(body));
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
        child: Text("Search Song"),
        onPressed: () {
          list = [];
          String json = '{"field": "name", "value": "' + search.text + '"}';
          postRequest(
              'http://hall-server-master-dev.us-west-2.elasticbeanstalk.com/public/find-song',
              json);
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return getSearchScreen();
  }

  ShowDLV(String title, List<Song> list) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new SingleChildScrollView(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: list == null ? 0 : list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(list[index].name),
                    onTap: () {
                      onSearchDone(list[index].name);
                      musicPlayer.stop();
                      musicPlayer.play(
                          "https://storage-halls.s3-us-west-2.amazonaws.com/" +
                              list[index].song);
                    },
                  );
                }),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
