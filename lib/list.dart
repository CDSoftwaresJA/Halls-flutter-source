import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListViews',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('ListViews')),
        body: BodyLayout(),
      ),
    );
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

Widget _myListView(BuildContext context) {
  return getListView();
}

Widget getListView() {
  var listview = ListView(
    children: <Widget>[
      ListTile(
        leading: Icon(Icons.landscape),
        title: Text("LandScape"),
        subtitle: Text("Beautiful View..!"),
        trailing: Icon(Icons.wb_sunny),
      ),
      ListTile(
        leading: Icon(Icons.access_alarm),
        title: Text("Alarm"),
        subtitle: Text("Good morning.!"),
        trailing: Icon(Icons.cloud_circle),
      ),
      ListTile(
        leading: Icon(Icons.beach_access),
        title: Text("Beach"),
        subtitle: Text("Beach View..!"),
        trailing: Icon(Icons.beach_access),
      ),
      ListTile(
        leading: Icon(Icons.satellite),
        title: Text("Satellite"),
        subtitle: Text("Satellite Signal..!"),
        trailing: Icon(Icons.scatter_plot),
      ),
      ListTile(
        leading: Icon(Icons.save),
        title: Text("Save Data"),
        subtitle: Text("Save File..!"),
        trailing: Icon(Icons.gps_fixed),
      ),
      ListTile(
        leading: Icon(Icons.phone),
        title: Text("Call"),
        subtitle: Text("856848***11..!"),
        trailing: Icon(Icons.cached),
      ),
      ListTile(
        leading: Icon(Icons.print),
        title: Text("Printer"),
        subtitle: Text("Print Page..!"),
        trailing: Icon(Icons.pages),
      ),
      ListTile(
        leading: Icon(Icons.gamepad),
        title: Text("Game Pad"),
        subtitle: Text("Game Lover..!"),
        trailing: Icon(Icons.games),
      )
    ],
  );
  return listview;
}