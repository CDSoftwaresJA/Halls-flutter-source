import 'package:audioplayer/audioplayer.dart';

class MusicPlayer {
  AudioPlayer audioPlugin;
  AudioPlayerState audioPlayerState;
  double current = 0;
  MusicPlayer() {
    audioPlugin = new AudioPlayer();
    audioPlayerState = audioPlugin.state;
  }

  Future<void> play(String url) async {
    await audioPlugin.play(url);
    //setState(() => audioPlayerState = AudioPlayerState.PLAYING);
  }

  Future<void> pause() async {
    audioPlugin.pause();
    current = audioPlugin.duration.inSeconds as double;
  }

  Future<void> stop() async {
    audioPlugin.stop();
  }

  Future<void> seek() async {
    audioPlugin.seek(current);
  }
}
