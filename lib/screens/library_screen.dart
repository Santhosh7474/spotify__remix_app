import 'package:flutter/material.dart';
import 'package:spotify_remix_app/screens/playlist_songs_screen.dart';
import 'package:spotify_remix_app/widgets/now_playing_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late final String userId;

  @override
  void initState() {
    super.initState();
    final user = Supabase.instance.client.auth.currentUser;
    userId = user?.id ?? '';
  }

  Future<List<Map<String, dynamic>>> _getPlaylists() async {
    final response = await Supabase.instance.client
        .from('playlists')
        .select()
        .eq('user_id', userId);

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Your Library'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _getPlaylists(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final playlists = snapshot.data!;
              if (playlists.isEmpty) {
                return const Center(
                  child: Text(
                    'No playlists created yet.',
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  final playlist = playlists[index];

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    leading: const Icon(
                      Icons.queue_music_rounded,
                      color: Colors.green,
                    ),
                    title: Text(
                      playlist['name'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlaylistSongsScreen(
                            playlistId: playlist['id'],
                            playlistName: playlist['name'],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          const NowPlayingWidget(),
        ],
      ),
    );
  }
}
