import 'track.dart';

class Album {
  final String id;
  final String title;
  final String artist;
  final String coverUrl;
  final String genre;
  final double vinylPrice;
  final List<Track> tracks;

  const Album({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverUrl,
    required this.genre,
    required this.vinylPrice,
    required this.tracks,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      coverUrl: json['coverUrl'] as String,
      genre: json['genre'] as String,
      vinylPrice: (json['vinylPrice'] as num).toDouble(),
      tracks: (json['tracks'] as List<dynamic>).map((trackJson) {
        return Track.fromJson(trackJson as Map<String, dynamic>);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'coverUrl': coverUrl,
      'genre': genre,
      'vinylPrice': vinylPrice,
      'tracks': tracks.map((track) => track.toJson()).toList(),
    };
  }
}