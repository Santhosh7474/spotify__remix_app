import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_remix_app/widgets/add_to_playlist_sheet.dart';
import '../data/api_service.dart';
import '../data/auth_provider.dart';
import '../data/now_playing_provider.dart';

class PlaylistDetailsScreen extends StatelessWidget {
  final String id;
  const PlaylistDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: FutureBuilder(
        future: ApiService.getData('playlists-details/$id', auth),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final data = snapshot.data!;
          final items = data['tracks']['items'];
          final playlist = data;

          final image = playlist['images'][0]['url'];
          final name = playlist['name'];
          final artists = (items as List)
              .take(3)
              .map((e) => e['track']['artists'][0]['name'])
              .toSet()
              .toList()
              .join(', ');

          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7B1FA2), Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    expandedHeight: 300,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(image, width: 180),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            artists,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((_, i) {
                      final track = items[i]['track'];
                      return ListTile(
                        leading: Image.network(
                          track['album']['images'][0]['url'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          track['name'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          track['artists'][0]['name'],
                          style: const TextStyle(color: Colors.white70),
                        ),
                        onTap: () {
                          final previewUrl = track['preview_url'];
                          if (previewUrl == null || previewUrl.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No preview available'),
                              ),
                            );
                            return;
                          }

                          final nowPlaying = Provider.of<NowPlayingProvider>(
                            context,
                            listen: false,
                          );
                          nowPlaying.playTrack(
                            track['name'],
                            previewUrl,
                            artist: track['artists'][0]['name'],
                            image: track['album']['images'][0]['url'],
                          );
                        },

                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'add_to_playlist') {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (_) =>
                                    AddToPlaylistSheet(track: track),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'add_to_playlist',
                              child: Text('Add to Playlist'),
                            ),
                          ],
                        ),
                      );
                    }, childCount: items.length),
                  ),
                ],
              ),

              // Floating FAB
              Positioned(
                bottom: 30,
                right: 30,
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.play_arrow),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
