import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_provider.dart';

class ApiService {
  static const base = 'https://apis2.ccbp.in/spotify-clone';

  static Future<Map<String, dynamic>> searchData(
    String query,
    AuthProvider auth,
  ) async {
    final url =
        'https://api.spotify.com/v1/search?q=$query&type=album,playlist&limit=20';
    final response = await http.get(Uri.parse(url), headers: auth.authHeader);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to search: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> getData(
    String endpoint,
    AuthProvider auth,
  ) async {
    final url = Uri.parse('$base/$endpoint');

    print("📡 Hitting API: $url");
    print("🔑 Token in header: ${auth.token}");

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${auth.token}',
        'Content-Type': 'application/json',
      },
    );

    print("📩 Response Code: ${response.statusCode}");
    print("📩 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load $endpoint');
    }
  }
}
