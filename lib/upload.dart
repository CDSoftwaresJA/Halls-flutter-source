import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hallsmusic/appbar.dart';
import 'package:hallsmusic/rq.dart';
import 'package:hallsmusic/toasts.dart';
import 'package:hallsmusic/links.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class UploadSong extends StatefulWidget {
  @override
  _UploadSongState createState() => _UploadSongState();
}

class _UploadSongState extends State<UploadSong> {
  File img, song;

  final name = TextEditingController();

  final description = TextEditingController();

  Color colorPicture = Colors.grey, colorSong = Colors.grey;

  String genre = '';

  RequestBuilder requestBuilder;

  @override
  Widget build(BuildContext context) {
    requestBuilder = new RequestBuilder(context);
    return Scaffold(
        appBar: makeAppBar('Upload Song', true),
        body: ListView(children: [
          TextField(
            obscureText: false,
            controller: name,
            maxLength: 30,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name of Song',
            ),
          ),
          Container(
            child: TextField(
              maxLines: 5,
              obscureText: false,
              controller: description,
              maxLength: 100,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description of Song (100 Words)',
              ),
            ),
          ),
          new DropdownButton<String>(
            hint: Text('Genre'),
            items: <String>[
              'Hip-Hop',
              'Pop',
              'RnB',
              'Reggae',
              'Soca',
              'Dancehall',
              'Rock'
            ].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (String value) {
              showToast(value);
              genre = value;
            },
          ),
          RaisedButton(
            child: Text('Choose Picture'),
            color: colorPicture,
            onPressed: () async {
              img = await FilePicker.getFile(type: FileType.image);
              setState(() {
                if (img.path.length > 1) colorPicture = Colors.blue;
              });

              showToast('Picture Selected');
            },
          ),
          RaisedButton(
            child: Text('Choose Song File'),
            color: colorSong,
            onPressed: () async {
              song = await FilePicker.getFile(type: FileType.audio);
              setState(() {
                if (song.path.length > 1) colorSong = Colors.blue;
              });

              showToast('Song Selected');
            },
          ),
          RaisedButton(
            child: Text('Upload'),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String json = '{"name":"' +
                  name.text +
                  '","description":"' +
                  description.text +
                  '","genre":"' +
                  genre +
                  '","email":"' +
                  prefs.getString('username') +
                  '"}';
              requestBuilder.makePostRequest(addEndpoint("add-song"), json);
              uploadFile(addEndpoint("upload-song"), song.path, 'song');
              uploadFile(addEndpoint("upload-img"), img.path, 'image');
              Navigator.pop(context);
            },
          )
        ]));
  }

  uploadFile(String url, String path, String query) async {
    final postUri = Uri.parse(url);
    MultipartRequest request = MultipartRequest('POST', postUri);
    MultipartFile multipartFile = await MultipartFile.fromPath(
        query, path); //returns a Future<MultipartFile>
    request.fields['name'] = name.text;
    request.files.add(multipartFile);
    StreamedResponse response = await request.send();
    if (response.statusCode == 200) showToast("Uploaded " + query);
  }
}
