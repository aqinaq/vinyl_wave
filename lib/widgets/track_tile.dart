import 'package:flutter/material.dart';

import '../models/track.dart';

class TrackTile extends StatelessWidget {
  final Track track;
  final int trackNumber;
  final VoidCallback? onTap;

  const TrackTile({
    super.key,
    required this.track,
    required this.trackNumber,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        child: Text('$trackNumber'),
      ),
      title: Text(track.title),
      trailing: const Icon(Icons.play_circle_outline),
    );
  }
}