import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());
BuildContext _buildContext;
/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    message('Test'),
    message('Explore'),
    message('Search'),
    message('My Collection'),
    getSettingsList()
  ];


  @override
  Widget build(BuildContext context) {
    _buildContext=context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Halls Music'),
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar:createNavBar(),
    );
  }
  Widget createNavBar(){
    return  BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 0.5,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.accessibility),
          title: Text('Test'),
        ),
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
  Future<void> play() async {
    String url= "http://www.hochmuth.com/mp3/Haydn_Cello_Concerto_D-1.mp3";
    AudioPlayer audioPlugin = new AudioPlayer();
    AudioPlayerState audioPlayerState = audioPlugin.state;
    await audioPlugin.play(url);
    setState(() => audioPlayerState = AudioPlayerState.PLAYING);
  }
  void playMusic(String url){
    AudioPlayer audioPlugin = new AudioPlayer();
    audioPlugin.play(url);
  }
}



class CreateAccount extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Text('Create Account')
        )

    );
  }

}
class UploadSong extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Text('Upload Song')
        )
    );
  }

}
class Login extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Text('Login')
        )
    );
  }

}
Widget getSettingsList() {
  var listview = ListView(
    children: <Widget>[
      ListTile(
        title: Text("Create new Account"),
        subtitle: Text("-Create Account-"),
        leading: Icon(Icons.person_outline),
        onTap: () {
          Navigator.push(
            _buildContext,
            MaterialPageRoute(builder: (context) => CreateAccount()),
          );
        },
      ),
      ListTile(
        title: Text("Upload Song"),
        subtitle: Text("-Upload Song-"),
        leading: Icon(Icons.file_upload),
        onTap: () {
          Navigator.push(
            _buildContext,
            MaterialPageRoute(builder: (context) => UploadSong()),
          );
        },
      ),
      ListTile(
        title: Text("Login"),
        subtitle: Text("-Login-"),
        leading: Icon(Icons.account_circle),
        onTap: () {
          Navigator.push(
            _buildContext,
            MaterialPageRoute(builder: (context) => Login()),
          );
        },
      ),

    ],
  );
  return listview;
}
