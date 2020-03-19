import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hallandroidsource/appbar.dart';

import 'login.dart';

class UploadSong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: makeAppBar('Upload Song'),
        body: ListView(children: [
          Text('Upload Song'),
          RaisedButton(
            child: Text('Submit'),
            onPressed: () async {
              File file = await FilePicker.getFile(type: FileType.audio);
            },
          )
        ]));
  }
}