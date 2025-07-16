import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/auth_provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final name = user?.userMetadata?['full_name'] ?? 'User';

    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  name[0].toUpperCase(),
                  style: const TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          const Divider(color: Colors.white24),
          _drawerItem(context, Icons.person_add, 'Add account'),
          _drawerItem(context, Icons.star, 'What’s New'),
          _drawerItem(context, Icons.history, 'Recents'),
          _drawerItem(context, Icons.update, 'Your Updates'),
          _drawerItem(
            context,
            Icons.privacy_tip,
            'Settings and Privacy',
            route: '/settings',
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title, {
    String? route,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        if (route != null) context.push(route);
        Navigator.pop(context);
      },
    );
  }
}
