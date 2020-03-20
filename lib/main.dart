import 'package:flutter/material.dart';
import 'package:hallsmusic/musicplayer.dart';
import 'package:hallsmusic/rq.dart';
import 'package:hallsmusic/search.dart';
import 'package:hallsmusic/settings.dart';
import 'package:hallsmusic/song.dart';
import 'package:hallsmusic/toasts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'appbar.dart';
import 'dialogs.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(brightness: Brightness.dark),
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  MusicPlayer musicPlayer;
  Text text = Text("-"),
      text2 = Text("SONG DETAIL"),
      songState = Text("Paused");
  int _selectedIndex = 0;
  Dialogs dialogs;

  SettingsList settingsList;
  RequestBuilder requestBuilder;
  var decodedJson;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions;
  SharedPreferences sharedPreferences;
  List<Song> songlist = [];

  updateSongText(String value) {
    setState(() {
      text = Text(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    musicPlayer = new MusicPlayer();
    requestBuilder = new RequestBuilder(context);
    dialogs = new Dialogs(context);
    String value = '';
    SearchScreen searchScreen = new SearchScreen(
      context: context,
      value: value,
      musicPlayer: musicPlayer,
      onSearchDone: (String val) => setState(() {
        text = Text(val);
        songState = Text('Playing');
      }),
    );
    settingsList = new SettingsList(context);
    _widgetOptions = <Widget>[];
    _widgetOptions.add(createExplore());
    _widgetOptions.add(searchScreen.build(context));
    _widgetOptions
        .add(createSongList('{"field": "name", "value": "' + '' + '"}'));
    _widgetOptions.add(settingsList.getSettingsList());

    return Scaffold(
      appBar: makeAppBar('Halls Music'),
      body: SlidingUpPanel(
        minHeight: 50,
        panel: Center(
          child: text2,
        ),
        collapsed: Container(
            color: Colors.black,
            child: Row(
              children: <Widget>[
                SizedBox(width: 30),
                text,
                SizedBox(width: 150),
                RaisedButton(
                  child: songState,
                  onPressed: () {
                    if (songState.data == 'Playing') {
                      setState(() {
                        songState = Text('Paused');
                      });

                      musicPlayer.pause();
                    } else if (songState.data == 'Paused') {
                      songState = Text('Playing');
                    }
                  },
                )
              ],
            )),
        body: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: createNavBar(),
    );
  }

  createSongList(String json) {
    List<Song> list = [];
    var decodedJson = requestBuilder.makeGetRequest(
        "http://hall-server-master-dev.us-west-2.elasticbeanstalk.com/public/get-song");
    return Text("Collection");
  }

  createExplore() {
    return Text("Explore");
  }

  Widget createNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 0.5,
      items: const <BottomNavigationBarItem>[
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
          title: Text('My Collection'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text('Settings'),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black,
      onTap: _onItemTapped,
    );
  }

  static Widget message(String msg) {
    return Text(
      msg,
      style: optionStyle,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      //play();
    });
  }
}
