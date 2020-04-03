import 'package:audioplayer/audioplayer.dart';

class MusicPlayer{
  static AudioPlayer audioPlugin;
  static AudioPlayerState audioPlayerState;
  final Function(int value, int max) getCurrentPosition;
  static String song;
  static int position=0;
  static int max=0;

  MusicPlayer({this.getCurrentPosition}) {
    audioPlugin = new AudioPlayer();
    audioPlugin.onAudioPositionChanged.listen((event) {
      position = event.inMilliseconds;
    });
    audioPlayerState = audioPlugin.state;
  }

  static play({String url}) async {
    stop();
    await audioPlugin.play(url);
    song = url;
    audioPlayerState = AudioPlayerState.PLAYING;
    max=audioPlugin.duration.inMilliseconds;
    //setState(() => audioPlayerState = AudioPlayerState.PLAYING);
  }

  static pause() async {
    audioPlayerState = AudioPlayerState.PAUSED;
    audioPlugin.pause();
  }

  static stop() async {
    audioPlayerState = AudioPlayerState.STOPPED;
    audioPlugin.stop();
  }

  static resume(String song) async {
    audioPlayerState = AudioPlayerState.PLAYING;
    await audioPlugin.play(song);
  }

   static seekTo(String song, double pos) async {
    await audioPlugin.play(song);
    await audioPlugin.seek(pos);
  }

}

