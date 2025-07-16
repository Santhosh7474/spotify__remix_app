import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routes.dart';
import 'data/auth_provider.dart';
import 'data/now_playing_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lnudknalymbdchwowvbv.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxudWRrbmFseW1iZGNod293dmJ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTIwMDgwNTMsImV4cCI6MjA2NzU4NDA1M30.yyTVMtx8y5v8QW_FvV29iS3WVXPZ3KsxalNc09w1yuY',
  );

  runApp(const SpotifyRemixApp());
}

class SpotifyRemixApp extends StatelessWidget {
  const SpotifyRemixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..checkLoginStatus(),
        ),
        ChangeNotifierProvider(create: (_) => NowPlayingProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp.router(
            routerConfig: appRouter(auth),
            theme: ThemeData.dark(useMaterial3: true),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
