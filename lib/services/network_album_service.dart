import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/album.dart';

class NetworkAlbumService {
  final String albumsUrl;

  const NetworkAlbumService({
    required this.albumsUrl,
  });

  Future<List<Album>> getAlbums() async {
    final uri = Uri.parse(albumsUrl);

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load albums. Status code: ${response.statusCode}');
    }

    final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

    return jsonList.map((jsonItem) {
      return Album.fromJson(jsonItem as Map<String, dynamic>);
    }).toList();
  }

  Future<Album?> getAlbumById(String id) async {
    final albums = await getAlbums();

    try {
      return albums.firstWhere((album) => album.id == id);
    } catch (_) {
      return null;
    }
  }
}