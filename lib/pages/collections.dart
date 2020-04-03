import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hallsmusic/objects/song.dart';
import 'package:hallsmusic/utils/appbar.dart';
import 'package:hallsmusic/utils/database.dart';
import 'package:hallsmusic/utils/links.dart';
import 'package:hallsmusic/utils/lists.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Collections extends StatefulWidget {
  final Function(Song song, List<Song> songList) playSong;
  final Function(Song song) removeFromFavorite;
  final Function(String email) openProfile;
  final DB db;
  Collections(
      {Key key,
      this.playSong,
      this.removeFromFavorite,
      this.openProfile,
      this.db})
      : super(key: key);

  @override
  _CollectionsState createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections> {
  List<Song> favSongs = [];
  List<Song> recentSongs = [];
  List<Song> suggestedSongs = [];
  List<Song> downloadedSongs = [];
  List<List<Song>> playlists = [];
  @override
  Widget build(BuildContext context) {
    getSongsList();
    return createCollections();
  }

  getSongsList() async {
    if (mounted) {
      favSongs = widget.db.getSongList('song');
      recentSongs = widget.db.getSongList('recent');
      getRandom();
    }
  }

  getList() {
    return SliverList(
      // This next line does the trick.
      delegate: SliverChildListDelegate([
        Material(
          color: backGroundColor(),
          child: ListTile(
            title: Text(
              "Suggested Tracks",
              style: textStyle(),
            ),
            leading: Icon(
              Icons.audiotrack,
              color: iconStyle(),
            ),
            onTap: () {
              display("Suggested", suggestedSongs);
            },
          ),
        ),
        Material(
          color: backGroundColor(),
          child: ListTile(
            title: Text(
              "Playlists",
              style: textStyle(),
            ),
            leading: Icon(
              Icons.playlist_play,
              color: iconStyle(),
            ),
            onTap: () {
              //widget.displayCollection("Playlists", suggestedSongs);
            },
          ),
        ),
        Material(
          color: backGroundColor(),
          child: ListTile(
            title: Text(
              "Favourites",
              style: textStyle(),
            ),
            leading: Icon(
              Icons.favorite,
              color: iconStyle(),
            ),
            onTap: () {
              display("Favourites", favSongs);
            },
          ),
        ),
        Material(
          color: backGroundColor(),
          child: ListTile(
            title: Text(
              "Downloaded",
              style: textStyle(),
            ),
            leading: Icon(
              Icons.file_download,
              color: iconStyle(),
            ),
            onTap: () {
              display("Downloaded", downloadedSongs);
            },
          ),
        ),
        Material(
          color: backGroundColor(),
          child: ListTile(
            title: Text(
              "Recently Played",
              style: textStyle(),
            ),
            leading: Icon(
              Icons.replay,
              color: iconStyle(),
            ),
            onTap: () {
              display("Recently Played", recentSongs);
            },
          ),
        )
      ]),
    );
  }

  createCollections() {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          new CupertinoSliverNavigationBar(
            actionsForegroundColor: Colors.white,
            largeTitle: Text("Collection"),
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
          getList()
        ],
      ),
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
    if (mounted) {
      setState(() {
        suggestedSongs = tempList;
      });
    }
  }

  display(String title, List<Song> displayList) {
    if (mounted) setState(() {});
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => CustomList(
                  title: title,
                  songList: displayList,
                  playSong: (Song song, List<Song> list) {
                    widget.playSong(song, list);
                  },
                )));
  }
}
