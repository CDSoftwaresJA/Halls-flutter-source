import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hallsmusic/utils/appbar.dart';
import 'package:hallsmusic/utils/toasts.dart';
import 'package:http/http.dart';
import 'objects/song.dart';
import 'utils/links.dart';

class Details extends StatefulWidget {
  final String title;
  final Function(Song song, List<Song> songList) playSong;
  final Function(Song song) addToFavourite;
  Details({Key key, this.title, this.playSong, this.addToFavourite})
      : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  List<Song> songList = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getSongListRequest();
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        getSpinKit(),
        AnimatedOpacity(
          opacity: loaded ? 1.0 : 0.0,
          duration: animationDuration(),
          child: oldUI(),
        )
      ],
    );
  }

  getSongListRequest() async {
    Map<String, String> headers = {"Content-type": "application/json"};
    List<Song> list = [];
    String jsonDetails = '{"field": "email", "value": "' + widget.title + '"}';
    Response response = await post(addEndpoint("find-song"),
        headers: headers,
        body: jsonDetails); // check the status code for the result
// this API passes back the id of the new item added to the body
    var body = json.decode(response.body);
    body = body['items'];
    for (var item in body) {
      list.add(new Song.fromJson(item));
    }
    if (mounted) {
      setState(() {
        songList = list;
        loaded = true;
      });
    }

    //showToast("Songs found");
  }

  oldUI() {
    return CupertinoPageScaffold(
      navigationBar: makeCupertinoAppBar(widget.title),
      child: Material(
        color: backGroundColor(),
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: songList == null ? 0 : songList.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                //selected: selected,
                leading: CachedNetworkImage(
                  imageUrl: addStorage(songList[index].picture),
                  placeholder: (context, url) => getSpinKit(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: 50,
                  height: 50,
                ),

                title: Text(
                  songList[index].name,
                  style: textStyle(),
                ),
                onLongPress: () {
                  widget.addToFavourite(songList[index]);
                  showToast("Added to Favorites", context);
                },
                onTap: () {
                  widget.playSong(songList[index], songList);
                },
              );
            }),
      ),
    );
  }
}
