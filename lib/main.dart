import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hallsmusic/pages/search.dart';
import 'package:hallsmusic/pages/splash.dart';
import 'package:hallsmusic/panel.dart';
import 'package:hallsmusic/settings/settings.dart';
import 'package:hallsmusic/utils/database.dart';
import 'package:hallsmusic/utils/links.dart';
import 'package:hallsmusic/utils/toasts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/collections.dart';
import 'objects/song.dart';
import 'utils/appbar.dart';
import 'details.dart';
import 'pages/explore.dart';
import 'utils/musicplayer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: new CupertinoThemeData(
          brightness: brightness(),
          primaryColor: iconStyle(),
          textTheme: CupertinoTextThemeData(primaryColor: iconStyle()),
          scaffoldBackgroundColor: backGroundColor(),
          barBackgroundColor: backGroundColor()),
      home: SplashScreen(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static MusicPlayer musicPlayer;
  static Panel panel ;
  String songState = "Paused";
  List<Widget> _widgetOptions;
  static DB db;
  List<Song> favList = [];
  Song currentSong = new Song("name", "email", "description", "genre",
      "upload/abott%40adorable.png", "song");




  @override
  Widget build(BuildContext context) {
    _widgetOptions = <Widget>[];
    _widgetOptions.add(Explore());
    _widgetOptions.add(SearchScreen(
      openProfile: (String email) {
        openProfile(email);
      },
      addToFavourite: (Song song) {
        showToast("Added to Favourites", context);
        if (mounted)
          setState(() {
            db.addSong(song, 'song');
          });
        //db.getSongList();
      },
      playSong: (Song song, List<Song> searchList) {
        playSong(song, searchList);
      },
    ));
    _widgetOptions.add(new Collections(
      db: db,
      openProfile: (String email) {
        return toProfile(email);
      },
      playSong: (Song song, List<Song> slist) {
        playSong(song, slist);
      },
    ));
    _widgetOptions.add(SettingsList(
      logOut: () {
        logout();
      },
      toProfile: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        openProfile(prefs.getString('username'));
        //showToast(prefs.getString('username'));
      },
    ));

    return loadUI2();
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

  logout() {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => SplashScreen()),
    );
  }

  openProfile(String name) async {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => Details(
                  title: name,
                  playSong: (Song song, List<Song> slist) {
                    playSong(song, slist);
                  },
                  addToFavourite: (Song song) {
                    showToast("Added to Favourites", context);
                  },
                )));
  }

  addToList(String list, String json) async {}

  loadUI2() {
    return Stack(
      children: <Widget>[
        CupertinoTabScaffold(
          resizeToAvoidBottomInset: false,
          tabBar: CupertinoTabBar(
            onTap: (int index) {
              if (mounted) setState(() {});
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                title: Text('Explore'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                title: Text('Search'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music),
                title: Text('Collection'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                title: Text('Settings'),
              ),
            ],
          ),
          tabBuilder: (BuildContext context, int index) {
            return CupertinoTabView(
              builder: (BuildContext context) {
                return Stack(
                  children: <Widget>[
                    _widgetOptions[index],
                  ],
                );
              },
            );
          },
        ),
        panel
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    db = DB();
    db.initDB();
    musicPlayer = new MusicPlayer();
    Panel.playing=false;
    panel= Panel();
  }

  playSong(Song song, List<Song> list) async {
    songState = 'Playing';
    MusicPlayer.play(url: addStorage(song.song));

    if (mounted)
      setState(() {
        //db.addSong(song, 'recent');
        currentSong = song;
        Panel.playing=true;
        panel = Panel(
          openProfile: (String email) {
            openProfile(email);
          },
          songState: songState,
          musicPlayer: musicPlayer,
          btnList: list,
          icon: Icon(Icons.pause),
          playSong: (Song song) {
            playSong(song, list);
          },
        );
        Panel.currentSong=currentSong;
      });

  }
}
