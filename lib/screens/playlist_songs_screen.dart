import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/now_playing_provider.dart';

class PlaylistSongsScreen extends StatefulWidget {
  final String playlistId;
  final String playlistName;

  const PlaylistSongsScreen({
    super.key,
    required this.playlistId,
    required this.playlistName,
  });

  @override
  State<PlaylistSongsScreen> createState() => _PlaylistSongsScreenState();
}

class _PlaylistSongsScreenState extends State<PlaylistSongsScreen> {
  Future<List<Map<String, dynamic>>> fetchSongs() async {
    final res = await Supabase.instance.client
        .from('playlist_songs')
        .select()
        .eq('playlist_id', widget.playlistId);

    return List<Map<String, dynamic>>.from(res);
  }

  @override
  Widget build(BuildContext context) {
    final nowPlaying = Provider.of<NowPlayingProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.playlistName),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchSongs(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final songs = snapshot.data!;
          if (songs.isEmpty) {
            return const Center(
              child: Text(
                "No songs in this playlist.",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: songs.length,
            separatorBuilder: (_, __) => const Divider(color: Colors.white10),
            itemBuilder: (_, i) {
              final song = songs[i];
              return ListTile(
                leading: Image.network(
                  song['image_url'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  song['name'],
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  song['artist'],
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: const Icon(Icons.play_arrow, color: Colors.white),
                onTap: () {
                  if (song['preview_url'] == null ||
                      song['preview_url'].isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No preview available')),
                    );
                    return;
                  }

                  nowPlaying.setQueue(songs, startAt: i); // full queue
                },
              );
            },
          );
        },
      ),
    );
  }
}
