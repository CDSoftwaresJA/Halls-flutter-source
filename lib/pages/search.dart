import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hallsmusic/utils/appbar.dart';
import 'package:hallsmusic/utils/toasts.dart';
import 'package:http/http.dart';
import '../objects/account.dart';
import '../objects/song.dart';
import '../utils/links.dart';
import '../main.dart';
import '../utils/musicplayer.dart';

class SearchScreen extends StatefulWidget {
  final Function(String email) openProfile;
  final Function(Song song) addToFavourite;
  final Function(Song song, List<Song> slist) playSong;

  SearchScreen({Key key, this.openProfile, this.addToFavourite, this.playSong})
      : super(key: key);
  @override
  SearchScreenState createState() =>
      SearchScreenState(this.openProfile, this.addToFavourite, this.playSong);
}

class SearchScreenState extends State<SearchScreen> {
  final Function(String email) openProfile;
  final Function(Song song) addtoFavourite;
  final Function(Song song, List<Song> slist) playSong;

  List<Song> list = [];

  SearchScreenState(this.openProfile, this.addtoFavourite, this.playSong);
  postRequest(String url, String jsonFile) async {
    List<Song> tempList = [];
    Map<String, String> headers = {"Content-type": "application/json"};
    Response response = await post(url,
        headers: headers,
        body: jsonFile); // check the status code for the result
    int statusCode = response
        .statusCode; // this API passes back the id of the new item added to the body
    var body = json.decode(response.body);
    body = body['items'];
    for (var item in body) {
      tempList.add(new Song.fromJson(item));
      //print(item['name']);
    }
    setState(() {
      list = tempList;
    });
  }

  Widget getSearchScreen() {
    final search = TextEditingController();
    final style = TextStyle(color: backGroundColor());
    return Container(
      width: 310,
      child: CupertinoTextField(
        controller: search,
        obscureText: false,
        style: style,
        decoration: textFieldStyle(),
        placeholderStyle: style,
        placeholder: "Search Song",
        onSubmitted: (String str) {
          list = [];
          String json = '{"field": "name", "value": "' + str + '"}';
          postRequest(addEndpoint('find-song'), json);
        },
      ),
    );
  }

  SliverList getList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Material(
            color: backGroundColor(),
            child: ListTile(
              //selected: selected,
              leading: CachedNetworkImage(
                imageUrl: addStorage(list[index].picture),
                placeholder: (context, url) => getSpinKit(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: 50,
                height: 50,
              ),
              trailing: IconButton(
                icon: Icon(Icons.more_vert),
                color: iconStyle(),
                onPressed: () {
                  showActionDialog(list[index]);
                },
              ),
              title: Text(
                list[index].name,
                style: textStyle(),
              ),
              subtitle: toProfile(list[index].email),

              onTap: () {
                playSong(list[index], list);
              },
            ),
          );
        },
        childCount: list == null ? 0 : list.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          new CupertinoSliverNavigationBar(
            actionsForegroundColor: Colors.white,
            largeTitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[getSearchScreen()],
            ),
            backgroundColor: Colors.black,
          ),
          new SliverPadding(
            padding: MediaQuery.of(context)
                .removePadding(
                  removeTop: true,
                  removeLeft: true,
                  removeRight: true,
                )
                .padding,
          ),
          getList(),
        ],
      ),
    );
  }

  toProfile(String name) {
    return GestureDetector(
        child: Text(
          name,
          style: textStyle(),
        ),
        onTap: () {
          openProfile(name);
        });
  }

  showActionDialog(Song song) {
    final action = CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text(
            "Add to Favourites",
            style: TextStyle(fontSize: 15),
          ),
          isDefaultAction: true,
          onPressed: () {
            addtoFavourite(song);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(
            "Add to Playlist",
            style: TextStyle(fontSize: 15),
          ),
          isDefaultAction: true,
          onPressed: () {
            print("Action 2 is been clicked");
          },
        ),
        CupertinoActionSheetAction(
          child: Text(
            "Download",
            style: TextStyle(fontSize: 15),
          ),
          isDefaultAction: true,
          onPressed: () {
            print("Action 3 is been clicked");
          },
        ),
      ],
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }
}
