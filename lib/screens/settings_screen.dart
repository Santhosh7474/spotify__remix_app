import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final name = user?.userMetadata?['full_name'] ?? 'User';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Settings'),
      ),
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
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
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const Text(
                  'Free account',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _settingItem(Icons.account_circle, 'Account'),
          _settingItem(Icons.language, 'Content and display'),
          _settingItem(Icons.play_circle, 'Playback'),
          _settingItem(Icons.lock, 'Privacy and social'),
          _settingItem(Icons.notifications, 'Notifications'),
          _settingItem(Icons.devices, 'Apps and devices'),
          _settingItem(Icons.download, 'Data-saving and offline'),
          _settingItem(Icons.equalizer, 'Media quality'),
          _settingItem(Icons.ad_units, 'Advertisements'),
          _settingItem(Icons.info_outline, 'About'),
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
