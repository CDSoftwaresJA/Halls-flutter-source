import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/cupertino.dart';

class MusicPlayer {
  AudioPlayer audioPlugin;
  AudioPlayerState audioPlayerState;
  int position;
  final String song;
  MusicPlayer({@required this.song, @required this.position}) {
    audioPlugin = new AudioPlayer();
    audioPlayerState = audioPlugin.state;
  }

  Future<void> play({String url}) async {
    stop();
    if (url == null) {
      await audioPlugin.play(song);
    } else {
      await audioPlugin.play(url);
    }
    //setState(() => audioPlayerState = AudioPlayerState.PLAYING);
  }

  Future<void> pause() async {
    audioPlugin.pause();
    position = audioPlugin.duration.inMilliseconds;
  }

  Future<void> stop() async {
    audioPlugin.stop();
  }

  Future<void> seek(String song) async {
    await audioPlugin.play(song);
    await audioPlugin.seek(position.toDouble());
  }
}
