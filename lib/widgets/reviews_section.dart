import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/album_review.dart';
import '../services/review_service.dart';
import '../state/auth_controller.dart';

class ReviewsSection extends StatefulWidget {
  final String albumId;

  const ReviewsSection({
    super.key,
    required this.albumId,
  });

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  final ReviewService reviewService = ReviewService();
  final TextEditingController commentController = TextEditingController();

  int selectedRating = 5;
  bool isSubmitting = false;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> submitReview() async {
    final authController = context.read<AuthController>();
    final user = authController.user;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in from Profile first.'),
        ),
      );
      return;
    }

    final comment = commentController.text.trim();

    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Write a review first.'),
        ),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    await reviewService.addReview(
      albumId: widget.albumId,
      userId: user.uid,
      username: 'BTS Vinyl Collector',
      comment: comment,
      rating: selectedRating,
    );

    commentController.clear();

    if (!mounted) {
      return;
    }

    setState(() {
      selectedRating = 5;
      isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Review added.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reviews',
          style: Theme.of(context).textTheme.titleLarge,
        ),

        const SizedBox(height: 12),

        if (!authController.isSignedIn)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Sign in anonymously from the Profile tab to write a review.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<int>(
                    value: selectedRating,
                    decoration: const InputDecoration(
                      labelText: 'Rating',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 5, child: Text('5 stars')),
                      DropdownMenuItem(value: 4, child: Text('4 stars')),
                      DropdownMenuItem(value: 3, child: Text('3 stars')),
                      DropdownMenuItem(value: 2, child: Text('2 stars')),
                      DropdownMenuItem(value: 1, child: Text('1 star')),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        selectedRating = value;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Write your review',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isSubmitting ? null : submitReview,
                      icon: const Icon(Icons.send),
                      label: Text(
                        isSubmitting ? 'Posting...' : 'Post Review',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: 12),

        StreamBuilder<List<AlbumReview>>(
          stream: reviewService.watchReviews(widget.albumId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Could not load reviews.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }

            final reviews = snapshot.data ?? [];

            if (reviews.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'No reviews yet. Be the first to review this album.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }

            return Column(
              children: [
                for (final review in reviews)
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${review.rating}★'),
                      ),
                      title: Text(review.username),
                      subtitle: Text(review.comment),
                      trailing: const Icon(Icons.cloud_done),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}