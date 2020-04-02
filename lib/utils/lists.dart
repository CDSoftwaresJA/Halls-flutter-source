import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hallsmusic/objects/song.dart';
import 'package:hallsmusic/utils/appbar.dart';
import 'package:hallsmusic/utils/toasts.dart';
import 'package:http/http.dart';

import 'links.dart';

class CustomList extends StatefulWidget {
  final String title;
  final List<Song> songList;
  final Function(Song song, List<Song> songList) playSong;

  CustomList({Key key, this.title, this.playSong, this.songList})
      : super(key: key);

  @override
  ListState createState() => ListState();
}

class ListState extends State<CustomList> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return oldUI();
  }

  oldUI() {
    return CupertinoPageScaffold(
      navigationBar: makeCupertinoAppBar(widget.title),
      child: Material(
        color: backGroundColor(),
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: widget.songList == null ? 0 : widget.songList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                //selected: selected,
                leading: CachedNetworkImage(
                  imageUrl: addStorage(widget.songList[index].picture),
                  placeholder: (context, url) => getSpinKit(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: 50,
                  height: 50,
                ),
                title: Text(
                  widget.songList[index].name,
                  style: textStyle(),
                ),
                onLongPress: () {},
                onTap: () {
                  //showToast(widget.songList[index].name);
                  widget.playSong(widget.songList[index], widget.songList);
                },
              );
            }),
      ),
    );
  }
}
