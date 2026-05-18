import 'package:flutter/material.dart';

class AlbumCoverImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final double padding;
  final double fallbackIconSize;
  final Color? backgroundColor;

  const AlbumCoverImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.borderRadius = 18,
    this.padding = 10,
    this.fallbackIconSize = 42,
    this.backgroundColor,
  });

  bool get isAssetImage => imagePath.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    final bgColor =
        backgroundColor ?? Theme.of(context).colorScheme.surfaceVariant;

    Widget imageWidget;

    if (isAssetImage) {
      imageWidget = Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: _errorBuilder,
      );
    } else {
      imageWidget = Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: _errorBuilder,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        color: bgColor,
        padding: EdgeInsets.all(padding),
        child: imageWidget,
      ),
    );
  }

  Widget _errorBuilder(
      BuildContext context,
      Object error,
      StackTrace? stackTrace,
      ) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: Icon(
        Icons.album,
        size: fallbackIconSize,
      ),
    );
  }
}