import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/supabase_service.dart';
import '../data/auth_provider.dart';

class AddToPlaylistSheet extends StatefulWidget {
  final Map<String, dynamic> track;
  const AddToPlaylistSheet({super.key, required this.track});

  @override
  State<AddToPlaylistSheet> createState() => _AddToPlaylistSheetState();
}

class _AddToPlaylistSheetState extends State<AddToPlaylistSheet> {
  late Future<List<Map<String, dynamic>>> _playlistsFuture;
  final _controller = TextEditingController();

  @override
  void initState() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    _playlistsFuture = SupabaseService.getUserPlaylists(auth.userId!);
    super.initState();
  }

  void _createPlaylistAndAdd(String name) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final newPlaylistId = await SupabaseService.createPlaylist(
      name: name,
      userId: auth.userId!,
    );
    await SupabaseService.addSongToPlaylist(
      playlistId: newPlaylistId,
      song: widget.track,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Add to Playlist',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          /// Inline "Create New Playlist"
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'New playlist name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  if (_controller.text.trim().isNotEmpty) {
                    _createPlaylistAndAdd(_controller.text.trim());
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),

          const SizedBox(height: 24),
          FutureBuilder(
            future: _playlistsFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              final playlists = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: playlists.map((playlist) {
                  return ListTile(
                    title: Text(playlist['name']),
                    onTap: () async {
                      await SupabaseService.addSongToPlaylist(
                        playlistId: playlist['id'],
                        song: widget.track,
                      );
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
