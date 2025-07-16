import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/now_playing_provider.dart';
import '../widgets/add_to_playlist_sheet.dart';

class FullPlayerScreen extends StatelessWidget {
  const FullPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nowPlaying = Provider.of<NowPlayingProvider>(context);
    final song = nowPlaying.currentSong;

    if (song == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF6C1313),
        body: Center(
          child: Text('No song playing', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('PLAYING FROM ALBUM', style: TextStyle(fontSize: 12)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => _SongOptions(song: song),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C1313), Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    song['image_url'],
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  song['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  song['artist'],
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Slider(
                  value: nowPlaying.currentPosition.inSeconds.toDouble(),
                  max: nowPlaying.totalDuration.inSeconds.toDouble().clamp(
                    1,
                    double.infinity,
                  ),
                  onChanged: (value) {
                    nowPlaying.seek(Duration(seconds: value.toInt()));
                  },
                  activeColor: Colors.green,
                  inactiveColor: Colors.white30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatTime(nowPlaying.currentPosition),
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        _formatTime(nowPlaying.totalDuration),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.loop, color: Colors.white),
                      onPressed: () {}, // Optional: Add looping logic
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.skip_previous,
                        size: 32,
                        color: Colors.white,
                      ),
                      onPressed: nowPlaying.playPrevious,
                    ),
                    IconButton(
                      icon: Icon(
                        nowPlaying.isPlaying
                            ? Icons.pause_circle
                            : Icons.play_circle,
                        size: 50,
                        color: Colors.white,
                      ),
                      onPressed: nowPlaying.togglePlayPause,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.skip_next,
                        size: 32,
                        color: Colors.white,
                      ),
                      onPressed: nowPlaying.playNext,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.timer_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {}, // Optional: sleep timer
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _SongOptions extends StatelessWidget {
  final Map<String, dynamic> song;
  const _SongOptions({required this.song});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          leading: Image.network(song['image_url'], width: 50, height: 50),
          title: Text(song['name']),
          subtitle: Text(song['artist']),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text('Share'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.favorite_border),
          title: const Text('Add to Liked Songs'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.playlist_add),
          title: const Text('Add to playlist'),
          onTap: () {
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => AddToPlaylistSheet(
                track: {
                  'name': song['name'],
                  'preview_url': song['preview_url'],
                  'artists': [
                    {'name': song['artist']},
                  ],
                  'album': {
                    'images': [
                      {'url': song['image_url']},
                    ],
                  },
                },
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.hide_source),
          title: const Text('Hide in this album'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.album),
          title: const Text('Go to album'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Go to artist'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.timer),
          title: const Text('Sleep timer'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.rss_feed),
          title: const Text('Go to song radio'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.music_note),
          title: const Text('View song credits'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.qr_code),
          title: const Text('Show Spotify Code'),
          onTap: () {},
        ),
      ],
    );
  }
}
