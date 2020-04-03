import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hallsmusic/utils/appbar.dart';
import 'package:hallsmusic/utils/links.dart';
import 'package:hallsmusic/utils/toasts.dart';
import 'package:http/http.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Color colorPicture = Colors.grey;

  File img;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.black,
      navigationBar: makeCupertinoAppBar('View/Edit Profile'),
      child: ListView(
        children: <Widget>[
          RaisedButton(
            child: Text('Choose Profile Picture'),
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
            color: colorPicture,
            child: Text('Save'),
            onPressed: () async {
              await uploadFile(
                  addEndpoint("upload-picture"), img.path, 'image');
            },
          ),
        ],
      ),
    );
  }

  uploadFile(String url, String path, String query) async {
    final postUri = Uri.parse(url);
    MultipartRequest request = MultipartRequest('POST', postUri);
    MultipartFile multipartFile = await MultipartFile.fromPath(
        query, path); //returns a Future<MultipartFile>
    request.fields['name'] = "cduncan";
    request.files.add(multipartFile);
    StreamedResponse response = await request.send();
    if (response.statusCode == 200) showToast("Uploaded " + query, context);
  }
}
