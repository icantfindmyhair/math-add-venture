import 'package:just_audio/just_audio.dart';

class AudioController {
  static final AudioPlayer bgmPlayer = AudioPlayer();
  static final AudioPlayer sfxPlayer = AudioPlayer();
  static String? _currentTrack;

  static Future<void> playBGM(String track) async {
    if (_currentTrack == track) return; /// Prevent reloading the same track
    await stopBGM(); /// Stop any currently playing BGM
    _currentTrack = track;

    try {
      await bgmPlayer.stop();
      await bgmPlayer.setAsset(track);
      await bgmPlayer.setLoopMode(LoopMode.one);
      await bgmPlayer.play();
    } catch (e) {
      print("Error playing BGM: $e");
    }
  }

  static Future<void> stopBGM() async {
    await bgmPlayer.stop();
    _currentTrack = null;
  }

  static void dispose() {
    bgmPlayer.dispose();
  }

  static Future<void> playSFX(String sfxPath) async {
    try {
      await sfxPlayer.setAudioSource(AudioSource.asset(sfxPath));
      await sfxPlayer.play();
    } catch (e) {
      print("Error playing SFX: $e");
    }
  }
}