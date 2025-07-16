import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/api_service.dart';
import '../data/auth_provider.dart';
import '../data/now_playing_provider.dart';

class AlbumDetailsScreen extends StatelessWidget {
  final String id;
  const AlbumDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: FutureBuilder(
        future: ApiService.getData('album-details/$id', auth),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final album = snapshot.data!;
          final songs = album['tracks']['items'];
          final image = album['images'][0]['url'];
          final name = album['name'];
          final artist = album['artists'][0]['name'];

          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF880E4F), Colors.black],
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
                            artist,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((_, i) {
                      final song = songs[i];
                      return ListTile(
                        leading: Image.network(
                          image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          song['name'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          song['artists'][0]['name'],
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        onTap: () {
                          final url = song['preview_url'];
                          if (url != null) {
                            final nowPlaying = Provider.of<NowPlayingProvider>(
                              context,
                              listen: false,
                            );
                            nowPlaying.playTrack(
                              song['name'],
                              url,
                              artist: song['artists'][0]['name'],
                              image: image,
                            );
                          }
                        },
                      );
                    }, childCount: songs.length),
                  ),
                ],
              ),

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
