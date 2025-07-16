import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class NowPlayingProvider with ChangeNotifier {
  final _player = AudioPlayer();

  Map<String, dynamic>? _currentSong;
  List<Map<String, dynamic>> _queue = [];
  int _currentIndex = -1;

  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;

  Map<String, dynamic>? get currentSong => _currentSong;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  bool get isPlaying => _isPlaying;

  NowPlayingProvider() {
    _player.positionStream.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });

    _player.durationStream.listen((duration) {
      if (duration != null) {
        _totalDuration = duration;
        notifyListeners();
      }
    });

    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });

    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        playNext(); // Auto-play next when current ends
      }
    });
  }

  Future<void> playTrack(
    String name,
    String url, {
    required String artist,
    required String image,
  }) async {
    _currentSong = {
      'name': name,
      'preview_url': url,
      'artist': artist,
      'image_url': image,
    };

    await _player.setUrl(url);
    await _player.play();
    notifyListeners();
  }

  void togglePlayPause() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void seek(Duration position) {
    _player.seek(position);
  }

  void stop() {
    _player.stop();
    _currentSong = null;
    _queue.clear();
    _currentIndex = -1;
    notifyListeners();
  }

  // 🟢 QUEUE SYSTEM
  void setQueue(List<Map<String, dynamic>> queue, {int startAt = 0}) {
    _queue = queue;
    _currentIndex = startAt;
    if (_queue.isNotEmpty) {
      final song = _queue[startAt];
      playTrack(
        song['name'],
        song['preview_url'],
        artist: song['artist'],
        image: song['image_url'],
      );
    }
  }

  void playNext() {
    if (_queue.isEmpty || _currentIndex + 1 >= _queue.length) return;
    _currentIndex++;
    final song = _queue[_currentIndex];
    playTrack(
      song['name'],
      song['preview_url'],
      artist: song['artist'],
      image: song['image_url'],
    );
  }

  void playPrevious() {
    if (_queue.isEmpty || _currentIndex - 1 < 0) return;
    _currentIndex--;
    final song = _queue[_currentIndex];
    playTrack(
      song['name'],
      song['preview_url'],
      artist: song['artist'],
      image: song['image_url'],
    );
  }

  void addToQueue(Map<String, dynamic> song) {
    _queue.add(song);
    notifyListeners();
  }

  List<Map<String, dynamic>> get queue => _queue;
}
