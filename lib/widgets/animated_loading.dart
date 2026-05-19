import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedLoading extends StatelessWidget {
  final String message;
  final double size;

  const AnimatedLoading({
    super.key,
    this.message = 'Loading...',
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/music_loading.json',
              width: size,
              height: size,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}