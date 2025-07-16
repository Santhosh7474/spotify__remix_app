import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<List<Map<String, dynamic>>> getSongsInPlaylist(
    String playlistId,
  ) async {
    final res = await Supabase.instance.client
        .from('playlist_songs')
        .select()
        .eq('playlist_id', playlistId);
    return List<Map<String, dynamic>>.from(res);
  }

  static Future<String> createPlaylist({
    required String name,
    required String userId,
  }) async {
    final result = await Supabase.instance.client
        .from('playlists')
        .insert({'name': name, 'user_id': userId})
        .select('id')
        .single();

    return result['id']; // returns new playlist ID
  }

  static Future<List<Map<String, dynamic>>> getUserPlaylists(
    String userId,
  ) async {
    final res = await Supabase.instance.client
        .from('playlists')
        .select()
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(res);
  }

  static Future<void> addSongToPlaylist({
    required String playlistId,
    required Map<String, dynamic> song,
  }) async {
    await Supabase.instance.client.from('playlist_songs').insert({
      'playlist_id': playlistId,
      'song_id': song['id'],
      'song_name': song['name'],
      'preview_url': song['preview_url'],
    });
  }
}
