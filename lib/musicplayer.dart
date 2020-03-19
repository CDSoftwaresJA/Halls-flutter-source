import 'package:audioplayer/audioplayer.dart';

Future<void> play() async {
  String url =
      "https://storage-halls.s3-us-west-2.amazonaws.com/upload/1584536514.mp3";
  AudioPlayer audioPlugin = new AudioPlayer();
  AudioPlayerState audioPlayerState = audioPlugin.state;
  await audioPlugin.play(url);
  //setState(() => audioPlayerState = AudioPlayerState.PLAYING);
}