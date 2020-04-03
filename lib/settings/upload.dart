import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hallsmusic/utils/appbar.dart';
import 'package:hallsmusic/utils/links.dart';
import 'package:hallsmusic/utils/rq.dart';
import 'package:hallsmusic/utils/toasts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UploadSong extends StatefulWidget {
  @override
  _UploadSongState createState() => _UploadSongState();
}

class _UploadSongState extends State<UploadSong> {
  File img, song;

  final name = TextEditingController();

  final description = TextEditingController();

  Color colorPicture = Colors.grey, colorSong = Colors.grey;

  bool isLoading = false;

  String genre = '';

  RequestBuilder requestBuilder;

  @override
  Widget build(BuildContext context) {
    int chosen = 0;
    List<Text> genreList = <Text>[
      Text("Hip-Hop"),
      Text("Pop"),
      Text("RnB"),
      Text("Reggae"),
      Text("Soca"),
      Text("Dancehall"),
      Text("Rock")
    ];
    requestBuilder = new RequestBuilder(context);
    return AbsorbPointer(child:  CupertinoPageScaffold(
      backgroundColor: backGroundColor(),
      navigationBar: makeCupertinoAppBar('Upload Song'),
      child: Material(
          color: backGroundColor(),
          child: ListView(children: [
            SizedBox(
              height: 20,
            ),
            CupertinoTextField(
              obscureText: false,
              controller: name,
              placeholder: "Name of Song",
              placeholderStyle: textInFieldStyle(),
              style: textInFieldStyle(),
              decoration: textFieldStyle(),
              maxLength: 30,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: CupertinoTextField(
                maxLines: 5,
                decoration: textFieldStyle(),
                style: textInFieldStyle(),
                obscureText: false,
                placeholder: "Description of Song",
                placeholderStyle: textInFieldStyle(),
                controller: description,
                maxLength: 100,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CupertinoPicker(
              magnification: 1,
              backgroundColor: backGroundColor(),
              itemExtent: 50,
              looping: true,
              onSelectedItemChanged: (int index) {
                chosen = index;
              },
              children: genreList,
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text('Choose Picture'),
              color: colorPicture,
              onPressed: () async {
                img = await FilePicker.getFile(type: FileType.image);
                setState(() {
                  if (img.path.length > 1) colorPicture = Colors.blue;
                });

                showToast('Picture Selected', context);
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

                showToast('Song Selected', context);
              },
            ),
            RaisedButton(
              child: Text('Upload'),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String json = '{"name":"' +
                    name.text +
                    '","description":"' +
                    description.text +
                    '","genre":"' +
                    genreList[chosen].data +
                    '","email":"' +
                    prefs.getString('username') +
                    '"}';
                requestBuilder.makePostRequest(addEndpoint("add-song"), json);
                await uploadFile(addEndpoint("upload-song"), song.path, 'song');
                await uploadFile(addEndpoint("upload-img"), img.path, 'image');
                //Navigator.pop(context);
                setState(() {
                  isLoading = false;
                });
              },
            ),
            Visibility(
              visible: isLoading,
              child: SpinKitFadingCircle(
                color: Colors.blue,
                size: 30.0,
              ),
            ),
          ])),
    ),
    absorbing: isLoading,);
  }

  uploadFile(String url, String path, String query) async {
    final postUri = Uri.parse(url);
    MultipartRequest request = MultipartRequest('POST', postUri);
    MultipartFile multipartFile = await MultipartFile.fromPath(
        query, path); //returns a Future<MultipartFile>
    request.fields['name'] = name.text;
    request.files.add(multipartFile);
    StreamedResponse response = await request.send();
    if (response.statusCode == 200) showToast("Uploaded " + query, context);
  }
}
