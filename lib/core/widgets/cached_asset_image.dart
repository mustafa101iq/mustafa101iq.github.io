import 'package:flutter/material.dart';

class CachedAssetImage extends StatelessWidget {
  const CachedAssetImage(
    this.path, {
    super.key,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.displayWidth,
    this.displayHeight,
  });

  final String path;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final double? displayWidth;
  final double? displayHeight;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cacheW = displayWidth != null
        ? (displayWidth! * dpr).round()
        : null;
    final cacheH = displayHeight != null
        ? (displayHeight! * dpr).round()
        : null;

    return Image.asset(
      path,
      fit: fit,
      alignment: alignment,
      cacheWidth: cacheW,
      cacheHeight: cacheH,
      filterQuality: FilterQuality.medium,
      gaplessPlayback: true,
    );
  }
}
