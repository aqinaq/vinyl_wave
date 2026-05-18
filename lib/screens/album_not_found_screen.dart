import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlbumNotFoundScreen extends StatelessWidget {
  final String? albumId;

  const AlbumNotFoundScreen({
    super.key,
    this.albumId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Album Not Found'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.album_outlined, size: 80),
              const SizedBox(height: 16),
              Text(
                'Album not found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                albumId == null
                    ? 'We could not find this BTS album.'
                    : 'We could not find an album with ID: $albumId',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  context.go('/');
                },
                icon: const Icon(Icons.home),
                label: const Text('Back to Explore'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {
                  context.go('/store');
                },
                icon: const Icon(Icons.storefront),
                label: const Text('Go to Store'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}