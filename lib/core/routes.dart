import 'package:go_router/go_router.dart';
import 'package:spotify_remix_app/data/auth_provider.dart';
import 'package:spotify_remix_app/screens/album_details_screen.dart';
import 'package:spotify_remix_app/screens/email_otp_screen.dart';
import 'package:spotify_remix_app/screens/home_screen.dart';
import 'package:spotify_remix_app/screens/library_screen.dart';
import 'package:spotify_remix_app/screens/login_screen.dart';
import 'package:spotify_remix_app/screens/playlist_details_screen%20.dart';
import 'package:spotify_remix_app/screens/premium_screen.dart';
import 'package:spotify_remix_app/screens/profile_screen.dart';
import 'package:spotify_remix_app/screens/search_screen.dart';
import 'package:spotify_remix_app/screens/settings_screen.dart';
import 'package:spotify_remix_app/screens/signup_screen.dart';
import 'package:spotify_remix_app/widgets/main_scaffold.dart';

GoRouter appRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final loggedIn = authProvider.isLoggedIn;
      final isAuthPage =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';
      if (!loggedIn && !isAuthPage) return '/login';
      if (loggedIn && isAuthPage) return '/';
      return null;
    },
    routes: [
      /// ❗️ Auth routes outside Shell
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (_, __) => const SignupScreen()),

      /// ✅ Shell for pages with nav bar
      ShellRoute(
        builder: (_, __, child) => MainScaffold(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
          GoRoute(path: '/premium', builder: (_, __) => const PremiumScreen()),
          GoRoute(path: '/library', builder: (_, __) => const LibraryScreen()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
          GoRoute(
            path: '/settings',
            builder: (_, __) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/email-login',
            builder: (_, __) => const EmailOtpScreen(),
          ),
        ],
      ),

      /// 🎯 Dynamic detail pages (optional)
      GoRoute(
        path: '/playlist/:id',
        builder: (context, state) =>
            PlaylistDetailsScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/album/:id',
        builder: (context, state) =>
            AlbumDetailsScreen(id: state.pathParameters['id']!),
      ),
    ],
  );
}
