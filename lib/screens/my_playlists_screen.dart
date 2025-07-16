import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_remix_app/screens/playlist_songs_screen.dart';
import '../data/supabase_service.dart';
import '../data/auth_provider.dart';

class MyPlaylistsScreen extends StatelessWidget {
  const MyPlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('My Playlists')),
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: SupabaseService.getUserPlaylists(auth.userId!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final playlists = snapshot.data!;
          if (playlists.isEmpty) {
            return const Center(
              child: Text(
                'No playlists yet',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return ListView.builder(
            itemCount: playlists.length,
            itemBuilder: (_, index) {
              final playlist = playlists[index];
              return ListTile(
                title: Text(
                  playlist['name'],
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.white),
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
    );
  }
}
