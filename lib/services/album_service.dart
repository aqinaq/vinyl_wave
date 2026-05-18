import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/album.dart';

class AlbumService {
  Future<List<Album>> getAlbums() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/albums.json',
    );

    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;

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