import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hallsmusic/utils/appbar.dart';
import 'package:hallsmusic/utils/links.dart';
import 'package:hallsmusic/utils/musicplayer.dart';
import 'package:hallsmusic/utils/toasts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'objects/song.dart';

class Panel extends StatefulWidget {
  final Song currentSong;
  final List<Song> btnList;
  final Function(Song song) playSong;
  final MusicPlayer musicPlayer;
  final bool playing;
  Icon icon = Icon(Icons.pause);
  String songState;
  final Function(String email) openProfile;

  Panel(
      {Key key,
      this.currentSong,
      this.songState,
      this.btnList,
      this.playSong,
      this.musicPlayer,
      this.playing,
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
  @override
  Widget build(BuildContext context) {
    itemList = new List<CachedNetworkImage>();
    FixedExtentScrollController controller = new FixedExtentScrollController();
    for (Song song in widget.btnList) {
      itemList.add(CachedNetworkImage(
        imageUrl: addStorage(song.picture),
        placeholder: (context, url) => getSpinKit(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        width: 200,
        height: 200,
      ));
    }

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
            Text(widget.currentSong.name),
            SizedBox(
              height: 10,
            ),
            CupertinoPicker(
              magnification: 1,
              //scrollController: ,
              backgroundColor: backGroundColor(),
              itemExtent: 250,
              looping: true,
              onSelectedItemChanged: (int index) {
                //widget.playSong(widget.btnList[index]);
              },
              children: itemList,
            ),
            toProfile(widget.currentSong.email),
            Text(widget.currentSong.genre),
            MusicPlayer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                makeBackBtn(),
                makePlayBtn(),
                makeNextBtn(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                makeFavouriteBtn(),
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
            Text(widget.currentSong.name),
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
          widget.musicPlayer.pause();
        } else if (widget.songState == 'Paused') {
          setState(() {
            if (widget.currentSong.song != null) {
              widget.songState = 'Playing';
              widget.icon = new Icon(Icons.pause);
              widget.musicPlayer.resume(widget.currentSong.song);
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
          if (widget.btnList[widget.btnList.indexOf(widget.currentSong) + 1] !=
              null)
            widget.playSong(
                widget.btnList[widget.btnList.indexOf(widget.currentSong) + 1]);
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
        widget.musicPlayer.seekTo(addStorage(widget.currentSong.song), 0);
        if (mounted) setState(() {});
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
    if (widget.playing) {
      slidingUpPanel = SlidingUpPanel(
        minHeight: barHeight,
        maxHeight: 500,
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
