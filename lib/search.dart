import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hallsmusic/rq.dart';
import 'package:hallsmusic/song.dart';
import 'package:http/http.dart';
import 'account.dart';
import 'dialogs.dart';
import 'links.dart';
import 'main.dart';
import 'musicplayer.dart';

class SearchScreen extends StatelessWidget {
  Dialogs dialogs;
  RequestBuilder requestBuilder;
  final BuildContext context;
  final Function(Song song, String link) onSongSelected;
  final Function() onSearchDone;
  final String value;
  final MusicPlayer musicPlayer;
  List<Song> list = [];
  SearchScreen(
      {@required this.context,
      @required this.onSongSelected,
      @required this.value,
      @required this.musicPlayer,
      @required this.onSearchDone}) {
    dialogs = new Dialogs(context);
    requestBuilder = new RequestBuilder(context);
  }

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

  Widget getSearchScreen() {
    list.add(
        new Song("name", "email", "description", "genre", "picture", "song"));
    final search = TextEditingController();
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
          onSearchDone();
          list = [];
          String json = '{"field": "name", "value": "' + search.text + '"}';
          postRequest(addEndpoint('find-song'), json);
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
                    leading: Image.network(
                      addStorage(list[index].picture),
                      height: 50,
                      width: 50,
                    ),
                    title: Text(list[index].name),
                    subtitle: Text(list[index].email),
                    onTap: () {
                      onSongSelected(list[index], addStorage(list[index].song));
                      musicPlayer.stop();
                      musicPlayer.play(url: addStorage(list[index].song));
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
