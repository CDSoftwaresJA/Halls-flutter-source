import 'dart:convert';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:hallsmusic/links.dart';
import 'package:hallsmusic/musicplayer.dart';
import 'package:hallsmusic/rq.dart';
import 'package:hallsmusic/search.dart';
import 'package:hallsmusic/settings.dart';
import 'package:hallsmusic/song.dart';
import 'package:hallsmusic/toasts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_animation_set/widget/transition_animations.dart';
import 'package:flutter_animation_set/widget/behavior_animations.dart';
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
  List<Song> songList = [];
  MusicPlayer musicPlayer;
  bool isVisible = false;
  Icon icon = Icon(Icons.pause);
  String songState = "Paused";
  bool selected = false;
  bool songAnimation = false;
  int _selectedIndex = 0;
  Dialogs dialogs;
  SettingsList settingsList;
  RequestBuilder requestBuilder;
  List<Widget> _widgetOptions;
  SharedPreferences sharedPreferences;
  Song currentSong =
      new Song("name", "email", "description", "genre", "picture", "song");
  TextStyle textStyle = TextStyle(fontSize: 30.0);

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
      onSearchDone: () => setState(() {
        print('Search Done');
      }),
      onSongSelected: (Song song, link) => setState(() {
        updateSong(song);
        songState = 'Playing';
        songAnimation = true;
        icon = new Icon(Icons.pause);
        currentSong.song = link;
        musicPlayer.audioPlayerState = AudioPlayerState.PLAYING;
      }),
    );
    settingsList = new SettingsList(context);
    _widgetOptions = <Widget>[];
    _widgetOptions.add(createExplore());
    _widgetOptions.add(searchScreen.build(context));
    _widgetOptions
        .add(createCollections('{"field": "name", "value": "' + '' + '"}'));
    _widgetOptions.add(settingsList.getSettingsList());
    //return loadUI();
    return loadUI();
  }

  updateSong(Song value) {
    setState(() {
      currentSong = value;
      isVisible = true;
    });
  }

  loadUI() {
    return Scaffold(
      appBar: makeAppBar('Halls Music', false),
      body: SlidingUpPanel(
        minHeight: 50,
        color: Colors.black.withOpacity(1),
        panel: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Text(currentSong.name),
              Text(currentSong.description),
              Text(currentSong.email),
              Text(currentSong.genre),
              IconButton(
                icon: icon,
                onPressed: () {
                  if (songState == 'Playing') {
                    setState(() {
                      musicPlayer.audioPlayerState = AudioPlayerState.PAUSED;
                      songAnimation = false;
                      icon = new Icon(Icons.play_arrow);

                      songState = 'Paused';
                    });

                    musicPlayer.pause();
                  } else if (songState == 'Paused') {
                    setState(() {
                      songState = 'Playing';
                      songAnimation = true;
                      showToast(musicPlayer.song);
                      icon = new Icon(Icons.pause);
                      musicPlayer.audioPlayerState = AudioPlayerState.PLAYING;
                      musicPlayer.seek(addStorage(currentSong.song));
                    });
                  }
                },
              ),
            ],
          ),
        ),
        collapsed: Container(
            color: Colors.black.withOpacity(1),
            child: Row(
              children: <Widget>[
                SizedBox(width: 10),
                Visibility(
                  visible: songAnimation,
                  child: YYBlinkGrid(),
                ),
                SizedBox(width: 10),
                Text(currentSong.name),
                Spacer(),
                IconButton(
                  icon: icon,
                  onPressed: () {
                    if (songState == 'Playing') {
                      setState(() {
                        musicPlayer.audioPlayerState = AudioPlayerState.PAUSED;
                        icon = new Icon(Icons.play_arrow);
                        songAnimation = false;

                        songState = 'Paused';
                      });

                      musicPlayer.pause();
                    } else if (songState == 'Paused') {
                      setState(() {
                        songState = 'Playing';
                        songAnimation = true;
                        showToast(musicPlayer.song);
                        icon = new Icon(Icons.pause);
                        musicPlayer.audioPlayerState = AudioPlayerState.PLAYING;
                        musicPlayer.seek(addStorage(currentSong.song));
                      });
                    }
                  },
                ),
              ],
            )),
        body: Container(
          margin: const EdgeInsets.only(bottom: 200),
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: createNavBar(),
    );
  }

  createCollections(String json) {
    getSongListRequest();

    return new ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: songList == null ? 0 : songList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            //selected: selected,
            leading: Image.network(
              addStorage(songList[index].picture),
              height: 50,
              width: 50,
            ),
            subtitle: Text(songList[index].email),
            title: Text(songList[index].name),
            onLongPress: () {
              showToast(songList[index].description);
            },
            onTap: () {
              selected = true;
              updateSong(songList[index]);
              songState = 'Playing';
              songAnimation = true;
              icon = new Icon(Icons.pause);
              musicPlayer.stop();
              musicPlayer.play(url: addStorage(songList[index].song));
            },
          );
        });
  }

  createExplore() {
    return ListView(
      // This next line does the trick.
      scrollDirection: Axis.vertical,
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
    );
  }

  Widget createNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 0.0,
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.white,
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
          title: Text('Collection'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text('Settings'),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.lightBlueAccent,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getSongListRequest() async {
    // make GET request
    List<Song> slist = [];
    Response response =
        await get(addEndpoint("get-song")); // sample info available in response
    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String contentType = headers['content-type'];
    var body = json.decode(response.body);
    body = body['items'];
    for (var item in body) {
      slist.add(new Song.fromJson(item));
    }
    songList = slist;
  }
}
