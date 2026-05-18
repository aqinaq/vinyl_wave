import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/album.dart';
import 'compact_album_card.dart';

class HorizontalAlbumList extends StatelessWidget {
  final List<Album> albums;

  const HorizontalAlbumList({
    super.key,
    required this.albums,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 245,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];

          return CompactAlbumCard(
            album: album,
            onTap: () {
              context.push('/album/${album.id}');
            },
          );
        },
      ),
    );
  }
}