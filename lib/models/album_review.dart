import 'package:cloud_firestore/cloud_firestore.dart';

class AlbumReview {
  final String id;
  final String albumId;
  final String userId;
  final String username;
  final String comment;
  final int rating;
  final DateTime createdAt;

  const AlbumReview({
    required this.id,
    required this.albumId,
    required this.userId,
    required this.username,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  factory AlbumReview.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      ) {
    final data = snapshot.data()!;

    return AlbumReview(
      id: snapshot.id,
      albumId: data['albumId'] as String,
      userId: data['userId'] as String,
      username: data['username'] as String,
      comment: data['comment'] as String,
      rating: data['rating'] as int,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'albumId': albumId,
      'userId': userId,
      'username': username,
      'comment': comment,
      'rating': rating,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}