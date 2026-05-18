import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/album_review.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _reviewsCollection(String albumId) {
    return _firestore
        .collection('albums')
        .doc(albumId)
        .collection('reviews');
  }

  Stream<List<AlbumReview>> watchReviews(String albumId) {
    return _reviewsCollection(albumId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return AlbumReview.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> addReview({
    required String albumId,
    required String userId,
    required String username,
    required String comment,
    required int rating,
  }) async {
    final review = AlbumReview(
      id: '',
      albumId: albumId,
      userId: userId,
      username: username,
      comment: comment,
      rating: rating,
      createdAt: DateTime.now(),
    );

    await _reviewsCollection(albumId).add(
      review.toFirestore(),
    );
  }
}