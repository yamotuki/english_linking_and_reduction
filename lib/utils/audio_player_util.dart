import 'package:audioplayers/audioplayers.dart';

/// 音声再生を管理するユーティリティクラス
class AudioPlayerUtil {
  static final AudioPlayerUtil _instance = AudioPlayerUtil._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  // シングルトンパターン
  factory AudioPlayerUtil() {
    return _instance;
  }

  AudioPlayerUtil._internal();

  /// 音声を再生
  Future<void> play(String audioPath) async {
    if (_isPlaying) {
      await stop();
    }
    
    await _audioPlayer.play(AssetSource(audioPath));
    _isPlaying = true;
  }

  /// 音声を遅く再生（0.5倍速）
  Future<void> playSlowly(String audioPath) async {
    if (_isPlaying) {
      await stop();
    }
    
    await _audioPlayer.setPlaybackRate(0.5);
    await _audioPlayer.play(AssetSource(audioPath));
    _isPlaying = true;
  }

  /// 音声を停止
  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
  }

  /// リソースを解放
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
