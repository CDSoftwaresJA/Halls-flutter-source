import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hallsmusic/utils/toasts.dart';

class MusicPlayer extends StatefulWidget {
  AudioPlayer audioPlugin;
  AudioPlayerState audioPlayerState;
  int position = 0;
  final Function(int value, int max) getCurrentPosition;
  static String song;
  MusicPlayer({this.getCurrentPosition}) {
    audioPlugin = new AudioPlayer();
    audioPlugin.onAudioPositionChanged.listen((event) {
      //getMaxPosition(audioPlugin.duration.inSeconds);
      //getCurrentPosition(event.inSeconds, audioPlugin.duration.inSeconds);
    });
    audioPlayerState = audioPlugin.state;
  }
  Future<void> play({String url}) async {
    await audioPlugin.play(url);
    song = url;
    audioPlayerState = AudioPlayerState.PLAYING;

    //setState(() => audioPlayerState = AudioPlayerState.PLAYING);
  }

  Future<void> pause() async {
    audioPlayerState = AudioPlayerState.PAUSED;
    audioPlugin.pause();
    position = audioPlugin.duration.inMilliseconds;
  }

  Future<void> stop() async {
    audioPlayerState = AudioPlayerState.STOPPED;
    audioPlugin.stop();
  }

  Future<void> resume(String song) async {
    await audioPlugin.play(song);
    //await audioPlugin.seek(position.toDouble());
  }

  Future<void> seekTo(String song, double pos) async {
    await audioPlugin.play(song);
    await audioPlugin.seek(pos);
  }

  @override
  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {
  double valueHolder = 0, maxValue = 100;
  @override
  Widget build(BuildContext context) {
    widget.audioPlugin.onAudioPositionChanged.listen((event) {
      setState(() {
        valueHolder = event.inSeconds.toDouble();
        maxValue = widget.audioPlugin.duration.inSeconds.toDouble();
      });
      if (event == widget.audioPlugin.duration) {
        widget.audioPlayerState = AudioPlayerState.COMPLETED;
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
          widget.seekTo(widget.song, newValue);
        },
      ),
    );
  }
}
