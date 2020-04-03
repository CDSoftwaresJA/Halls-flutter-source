import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'musicplayer.dart';

class Slide extends StatefulWidget{
  @override
  _SlideState createState() => _SlideState();
}

class _SlideState extends State<Slide> {
  double valueHolder = 0, maxValue = 100;

  @override
  Widget build(BuildContext context) {
    MusicPlayer.audioPlugin.onAudioPositionChanged.listen((event) {
      setState(() {
        valueHolder = event.inSeconds.toDouble();
        maxValue = MusicPlayer.audioPlugin.duration.inSeconds.toDouble();
      });
      if (event == MusicPlayer.audioPlugin.duration) {
        MusicPlayer.audioPlayerState = AudioPlayerState.COMPLETED;
      }
    });
      return generateSlider();
  }

  generateSlider() {
    return Container(
      width: 300,
      child: CupertinoSlider(
        value: valueHolder,
        min: 0,
        max: maxValue,
        divisions: 100,
        activeColor: Colors.blue,
        onChanged: (double newValue) {
          MusicPlayer.seekTo(MusicPlayer.song, newValue);
        },
      ),
    );
  }
}