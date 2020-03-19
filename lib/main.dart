import 'package:flutter/material.dart';
import 'package:hallandroidsource/search.dart';
import 'package:hallandroidsource/settings.dart';
import 'appbar.dart';
import 'dialogs.dart';

void main() => runApp(MyApp());

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
  Dialogs dialogs;
  SearchScreen searchScreen;
  SettingsList settingsList;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions;

  @override
  Widget build(BuildContext context) {
    dialogs = new Dialogs(context);
    searchScreen = new SearchScreen(context);
    settingsList = new SettingsList(context);
    _widgetOptions = <Widget>[];
    _widgetOptions.add(message('Explore'));
    _widgetOptions.add(searchScreen.getSearchScreen());
    _widgetOptions.add(message('My Collection'));
    _widgetOptions.add(settingsList.getSettingsList());
    return Scaffold(
      appBar: makeAppBar('Halls Music'),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: createNavBar(),
    );
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
