import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hallsmusic/appbar.dart';
import 'package:hallsmusic/rq.dart';
import 'package:hallsmusic/toasts.dart';
import 'package:http/http.dart';

import 'login.dart';

class UploadSong extends StatelessWidget {
  File img, song;
  final name = TextEditingController();
  final email = TextEditingController();
  final description = TextEditingController();
  final genre = TextEditingController();
  RequestBuilder requestBuilder;
  @override
  Widget build(BuildContext context) {
    requestBuilder = new RequestBuilder(context);
    return Scaffold(
        appBar: makeAppBar('Upload Song'),
        body: ListView(children: [
          TextField(
            obscureText: false,
            controller: name,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'name',
            ),
          ),
          TextField(
            obscureText: false,
            controller: email,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'email',
            ),
          ),
          TextField(
            obscureText: false,
            controller: description,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'description',
            ),
          ),
          TextField(
            obscureText: false,
            controller: genre,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'genre',
            ),
          ),
          RaisedButton(
            child: Text('Choose Picture'),
            onPressed: () async {
              img = await FilePicker.getFile(type: FileType.image);
              requestBuilder.uploadFile(
                  "http://hall-server-master-dev.us-west-2.elasticbeanstalk.com/public/upload-image",
                  img.path,
                  'image');
              //showToast(img.path);
            },
          ),
          RaisedButton(
            child: Text('Choose Song'),
            onPressed: () async {
              song = await FilePicker.getFile(type: FileType.audio);
              uploadFile(
                  "http://hall-server-master-dev.us-west-2.elasticbeanstalk.com/public/upload-song",
                  song.path,
                  'song');
              //showToast(song.path);
            },
          ),
          RaisedButton(
            child: Text('Upload'),
            onPressed: () {
              String json = '{"name":"' +
                  name.text +
                  '","description":"' +
                  description.text +
                  '","genre":"' +
                  genre.text +
                  '","email":"' +
                  email.text +
                  '"}';
              requestBuilder.makePostRequest(
                  "http://hall-server-master-dev.us-west-2.elasticbeanstalk.com/public/add-song",
                  json);
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
    if (response.statusCode == 200) showToast("Uploaded!");
  }
}
