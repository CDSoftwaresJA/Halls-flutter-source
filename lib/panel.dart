import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hallsmusic/utils/appbar.dart';
import 'package:hallsmusic/utils/links.dart';
import 'package:hallsmusic/utils/musicplayer.dart';
import 'package:hallsmusic/utils/slider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'objects/song.dart';

class Panel extends StatefulWidget {
  static Song currentSong;
  final List<Song> btnList;
  final Function(Song song) playSong;
  final MusicPlayer musicPlayer;
  static bool playing;
  static FixedExtentScrollController controller;
  Icon icon = Icon(Icons.pause);
  String songState;
  final Function(String email) openProfile;

  Panel(
      {Key key,
      this.songState,
      this.btnList,
      this.playSong,
      this.musicPlayer,
      this.icon,
      this.openProfile})
      : super(key: key);

  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  SlidingUpPanel slidingUpPanel;
  MaterialColor color = Colors.grey;
  MaterialColor color2 = Colors.grey;
  double barHeight = 50;

  bool fav = false, loop = false;
  List<CachedNetworkImage> itemList;
  static Timer timer;
  @override
  Widget build(BuildContext context) {
    itemList = new List<CachedNetworkImage>();
    return getSlidingPanel();
  }

  loadPanel() {

    return Scaffold(
      body: Material(
        textStyle: textStyle(),
        color: backGroundColor(),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text(Panel.currentSong.name),
            SizedBox(
              height: 10,
            ),
            CupertinoPicker(
              magnification: 1,
              backgroundColor: backGroundColor(),
              itemExtent: 350,
              looping: true,
              onSelectedItemChanged: (int index) {
                if (timer!=null){
                  timer.cancel();
                }
                timer = Timer(const Duration(milliseconds: 700),(){
                  widget.playSong(widget.btnList[index]);
                });
                //
              },
              children: itemList,
            ),
            Slide(),
            toProfile(Panel.currentSong.email),
            Text(Panel.currentSong.genre),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                makeBackBtn(),
                makePlayBtn(),
                makeNextBtn(),
              ],
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                makeFavouriteBtn(),
                Spacer(),
                makeLoopBtn(),
              ],
            )
          ],
        ),
      ),
    );
  }

  loadCollapsed() {
    return Material(
        textStyle: textStyle(),
        color: panelColor(),
        child: Row(
          children: <Widget>[
            SizedBox(width: 10),
//                animation,
            SizedBox(width: 10),
            Text(Panel.currentSong.name),
            Spacer(),
            makePlayBtn(),
            makeNextBtn(),
          ],
        ));
  }

  makePlayBtn() {
    return IconButton(
      icon: widget.icon,
      onPressed: () {
        if (widget.songState == 'Playing') {
          setState(() {
            widget.icon = new Icon(Icons.play_arrow);
            widget.songState = 'Paused';
          });
          MusicPlayer.pause();
        } else if (widget.songState == 'Paused') {
          setState(() {
            if (Panel.currentSong.song != null) {
              widget.songState = 'Playing';
              widget.icon = new Icon(Icons.pause);
             MusicPlayer.resume(Panel.currentSong.song);
            }
          });
        }
      },
    );
  }

  makeNextBtn() {
    return IconButton(
      icon: Icon(Icons.skip_next),
      onPressed: () {
        widget.icon = new Icon(Icons.pause);
        try {
          if (widget.btnList[widget.btnList.indexOf(Panel.currentSong) + 1] !=
              null)
            widget.playSong(
                widget.btnList[widget.btnList.indexOf(Panel.currentSong) + 1]);
          if (mounted) setState(() {});
        } catch (RangeError) {
          if (widget.btnList[0] != null) widget.playSong(widget.btnList[0]);
          if (mounted) setState(() {});
        }
      },
    );
  }

  makeBackBtn() {
    return IconButton(
      icon: Icon(Icons.skip_previous),
      onPressed: () {
        widget.icon = new Icon(Icons.pause);
         MusicPlayer.seekTo(addStorage(Panel.currentSong.song), 0);
      },
    );
  }

  makeLoopBtn() {
    return IconButton(
      icon: Icon(Icons.loop),
      color: color2,
      onPressed: () {
        setState(() {
          if (!loop) {
            this.color2 = Colors.red;
            loop = true;
          } else {
            this.color2 = Colors.grey;
            loop = false;
          }
        });
      },
    );
  }

  makeFavouriteBtn() {
    return IconButton(
      icon: Icon(
        Icons.favorite,
        color: color,
      ),
      onPressed: () {
        setState(() {
          if (!fav) {
            color = Colors.red;
            fav = true;
          } else {
            color = Colors.grey;
            fav = false;
          }
        });
      },
    );
  }


  getSlidingPanel() {
    if (Panel.playing) {
      for (Song song in widget.btnList) {
        itemList.add(CachedNetworkImage(
          imageUrl: addStorage(song.picture),
          placeholder: (context, url) => getSpinKit(),
          errorWidget: (context, url, error) => Icon(Icons.error),
          width: 300,
          height: 300,
        ));
      }
      slidingUpPanel = SlidingUpPanel(
        minHeight: barHeight,
        maxHeight: 600,
        panel: loadPanel(),
        parallaxEnabled: true,
        collapsed: loadCollapsed(),
      );
      return Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: slidingUpPanel,
      );
    }
    return Container(
      height: 0,
      width: 0,
      child: Placeholder(),
    );
  }

  toProfile(String name) {
    return GestureDetector(
        child: Text(
          name,
          style: textStyle(),
        ),
        onTap: () {
          widget.openProfile(name);
        });
  }
}
