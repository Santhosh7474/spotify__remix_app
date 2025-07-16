import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spotify_remix_app/screens/category_playlist_screen.dart';
import 'package:spotify_remix_app/screens/playlist_details_screen%20.dart';
import 'package:spotify_remix_app/widgets/now_playing_widget.dart';
import '../data/api_service.dart';
import '../data/auth_provider.dart';
import '../data/now_playing_provider.dart';
import 'album_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final nowPlaying = Provider.of<NowPlayingProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.black),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white24,
                child: Text(
                  auth.user?.email?[0].toUpperCase() ?? "U",
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              accountName: Text(auth.user?.email ?? "User"),
              accountEmail: const Text('View profile'),
            ),
            _drawerItem(Icons.person_add_alt, 'Add account'),
            _drawerItem(Icons.bolt, 'What\'s new'),
            _drawerItem(Icons.history, 'Recents'),
            _drawerItem(Icons.campaign, 'Your Updates', hasDot: true),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text(
                'Settings and privacy',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                context.push('/profile');
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Spotify Remix'),

        // leading: IconButton(
        //   icon: const Icon(Icons.account_circle_outlined),
        //   onPressed: () {
        //     _scaffoldKey.currentState?.openDrawer();
        //   },
        // ),
        actions: [
          IconButton(
            onPressed: () {
              auth.logout();
              context.go('/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: Future.wait([
              ApiService.getData('featured-playlists', auth),
              ApiService.getData('categories', auth),
              ApiService.getData('new-releases', auth),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Failed to load content',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final featured = snapshot.data![0]['playlists']['items'];
              final categories = snapshot.data![1]['categories']['items'];
              final releases = snapshot.data![2]['albums']['items'];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Editor's Picks"),
                    _horizontalList(featured, context, type: 'playlist'),
                    _sectionTitle("Genres & Moods"),
                    _horizontalList(categories, context, type: 'category'),
                    _sectionTitle("New Releases"),
                    _horizontalList(releases, context, type: 'album'),
                    const SizedBox(height: 100),
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

  Widget _drawerItem(IconData icon, String title, {bool hasDot = false}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Row(
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          if (hasDot)
            const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Icon(Icons.brightness_1, color: Colors.blue, size: 8),
            ),
        ],
      ),
      onTap: () {},
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _horizontalList(
    List items,
    BuildContext context, {
    required String type,
  }) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i];
          final id = item['id'];
          final name = item['name'];
          final image =
              item['images']?[0]?['url'] ?? item['icons']?[0]?['url'] ?? '';

          return GestureDetector(
            onTap: () {
              switch (type) {
                case 'playlist':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlaylistDetailsScreen(id: id),
                    ),
                  );
                  break;
                case 'album':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AlbumDetailsScreen(id: id),
                    ),
                  );
                  break;
                case 'category':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryPlaylistsScreen(id: id),
                    ),
                  );
                  break;
              }
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      image,
                      height: 140,
                      width: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 140,
                    child: Text(
                      name,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
