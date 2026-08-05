import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_website/app/theme/app_colors.dart';

class AppLoader extends StatefulWidget {
  const AppLoader({super.key, this.isDark = true});

  final bool isDark;

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.isDark ? AppColors.red : AppColors.lightAccent;
    final bg = widget.isDark ? AppColors.voidBg : AppColors.lightBg;
    final muted = widget.isDark ? AppColors.mutedDim : AppColors.lightMuted;

    return ColoredBox(
      color: bg,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _ArcLoaderPainter(
                      progress: _controller.value,
                      color: accent,
                    ),
                    child: child,
                  );
                },
                child: Center(
                  child: Text(
                    'MQ',
                    style: GoogleFonts.orbitron(
                      color: accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'LOADING',
              style: GoogleFonts.rajdhani(
                color: muted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArcLoaderPainter extends CustomPainter {
  _ArcLoaderPainter({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, track);

    final sweep = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final start = progress * math.pi * 2;
    canvas.drawArc(rect, start, math.pi * 0.7, false, sweep);
  }

  @override
  bool shouldRepaint(covariant _ArcLoaderPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
