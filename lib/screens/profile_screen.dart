import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final name = user?.userMetadata?['full_name'] ?? 'User';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Settings'),
        centerTitle: true,
      ),
      drawer: const _ProfileDrawer(),
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Text(
                    name[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Free account',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {},
                  child: const Text('Go Premium'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          _settingItem(Icons.account_circle, 'Account'),
          _settingItem(Icons.music_note, 'Content and display'),
          _settingItem(Icons.play_circle, 'Playback'),
          _settingItem(Icons.lock, 'Privacy and social'),
          _settingItem(Icons.notifications, 'Notifications'),
          _settingItem(Icons.devices, 'Apps and devices'),
          _settingItem(Icons.download, 'Data-saving and offline'),
          _settingItem(Icons.equalizer, 'Media quality'),
          _settingItem(Icons.ad_units, 'Advertisements'),
          _settingItem(Icons.info, 'About'),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }

  Widget _settingItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {},
    );
  }
}

class _ProfileDrawer extends StatelessWidget {
  const _ProfileDrawer();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final name = user?.userMetadata?['full_name'] ?? 'User';

    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  name[0].toUpperCase(),
                  style: const TextStyle(color: Colors.black, fontSize: 24),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
          const Divider(color: Colors.white24),
          _drawerItem(Icons.person_add, 'Add account'),
          _drawerItem(Icons.star, 'What’s New'),
          _drawerItem(Icons.history, 'Recents'),
          _drawerItem(Icons.update, 'Your Updates'),
          _drawerItem(Icons.privacy_tip, 'Settings and Privacy'),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {},
    );
  }
}
