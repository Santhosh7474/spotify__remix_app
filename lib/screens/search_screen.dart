import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_remix_app/screens/album_details_screen.dart';
import 'package:spotify_remix_app/screens/playlist_details_screen%20.dart';
import 'package:spotify_remix_app/widgets/now_playing_widget.dart';
import '../data/api_service.dart';
import '../data/auth_provider.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  List _results = [];
  bool _isLoading = false;

  Future<void> _search(String query, AuthProvider auth) async {
    setState(() => _isLoading = true);
    final data = await ApiService.searchData(query, auth);
    setState(() {
      _results = [...data['albums']['items'], ...data['playlists']['items']];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Search',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: ApiService.getData('categories', auth),
            builder: (context, snapshot) {
              final categories = snapshot.data?['categories']['items'] ?? [];

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      onSubmitted: (query) => _search(query, auth),
                      decoration: InputDecoration(
                        hintText: 'What do you want to listen to?',
                        hintStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white10,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_controller.text.isNotEmpty && _results.isNotEmpty)
                      _buildSearchResults()
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Browse all",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: categories.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 1.8,
                                ),
                            itemBuilder: (_, i) {
                              final item = categories[i];
                              final title = item['name'];
                              final imageUrl = item['icons'][0]['url'];
                              final id = item['id'];

                              return GestureDetector(
                                onTap: () =>
                                    context.push('/category/$id/playlists'),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _randomTileColor(i),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Stack(
                                    children: [
                                      Text(
                                        title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            imageUrl,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
          const NowPlayingWidget(),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: _results.length,
      itemBuilder: (_, i) {
        final item = _results[i];
        final isAlbum = item.containsKey('album_type');
        final image = item['images']?[0]?['url'] ?? '';
        final name = item['name'];
        final id = item['id'];

        return GestureDetector(
          onTap: () {
            if (isAlbum) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AlbumDetailsScreen(id: id)),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlaylistDetailsScreen(id: id),
                ),
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  image,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  // Spotify-style tile coloring
  Color _randomTileColor(int index) {
    const colors = [
      Color(0xFF8D67AB),
      Color(0xFFBA5D07),
      Color(0xFF1E3264),
      Color(0xFF148A08),
      Color(0xFFE13300),
      Color(0xFF7358FF),
      Color(0xFFB49BC8),
      Color(0xFFD84000),
    ];
    return colors[index % colors.length];
  }
}
