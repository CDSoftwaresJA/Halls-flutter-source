import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hallsmusic/objects/song.dart';
import 'package:hallsmusic/utils/appbar.dart';
import 'package:hallsmusic/utils/links.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List<Song> topReleases = [], newReleases = [], suggestedTracks = [];
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          new CupertinoSliverNavigationBar(
            actionsForegroundColor: Colors.white,
            largeTitle: Text("Explore"),
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
          createExplore()
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //getRandom();
    //getRandom1();
    // getRandom2();
  }

  createExplore() {
    return SliverList(
      // This next line does the trick.
      delegate: SliverChildListDelegate([
        SizedBox(
          height: 20,
        ),
        Text("Top Artists"),
        placeHolder(),
        Text("Top Releases"),
        placeHolder(),
        Text("New Releases"),
        placeHolder(),
        Text("New Artists"),
        placeHolder(),
        Text(
          "Suggested Tracks",
          style: textStyle(),
        ),
        placeHolder(),
        SizedBox(
          height: 100,
        )
      ]),
    );
  }

  getRandom() async {
    List<Song> tempList = [];
    final response = await get(addEndpoint("random-song"));
    var body = json.decode(response.body);
    body = body['items'];
    for (var item in body) {
      tempList.add(new Song.fromJson(item));
      //print(item['name']);
    }
    setState(() {
      topReleases = tempList;
    });
  }

  getRandom1() async {
    List<Song> tempList = [];
    final response = await get(addEndpoint("random-song"));
    var body = json.decode(response.body);
    body = body['items'];
    for (var item in body) {
      tempList.add(new Song.fromJson(item));
      //print(item['name']);
    }
    setState(() {
      newReleases = tempList;
    });
  }

  getRandom2() async {
    List<Song> tempList = [];
    final response = await get(addEndpoint("random-song"));
    var body = json.decode(response.body);
    body = body['items'];
    for (var item in body) {
      tempList.add(new Song.fromJson(item));
      //print(item['name']);
    }
    setState(() {
      suggestedTracks = tempList;
    });
  }

  makeList(List<Song> list) {
    return Container(
      width: 160.0,
      height: 200,
      color: Colors.black,
      child: Material(
        color: backGroundColor(),
        child: new ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: list == null ? 0 : list.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: 160,
                height: 200,
                child: Column(
                  children: <Widget>[
                    Image.network(
                      addStorage(
                        list[index].picture,
                      ),
                      height: 180,
                      width: 160,
                    ),
                    Text(
                      list[index].name,
                      style: textStyle(),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }

  placeHolder() {
    return Container(
      width: 160.0,
      height: 200,
      color: Colors.red,
      child: ListView(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            width: 160.0,
            height: 100,
            color: Colors.red,
          ),
          Container(
            width: 160.0,
            height: 100,
            color: Colors.blue,
          ),
          Container(
            width: 160.0,
            height: 100,
            color: Colors.green,
          ),
          Container(
            width: 160.0,
            height: 100,
            color: Colors.yellow,
          ),
          Container(
            width: 160.0,
            height: 100,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}
