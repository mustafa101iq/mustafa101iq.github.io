import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:portfolio_website/app/theme/app_colors.dart';

class NetworkBackground extends StatefulWidget {
  const NetworkBackground({super.key, this.isDark = true});

  final bool isDark;

  @override
  State<NetworkBackground> createState() => _NetworkBackgroundState();
}

class _NetworkBackgroundState extends State<NetworkBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late List<_Node> _nodes;
  Offset? _pointer;

  @override
  void initState() {
    super.initState();
    _nodes = List.generate(48, (_) => _Node.random());
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => setState(() => _pointer = event.localPosition),
      onExit: (_) => setState(() => _pointer = null),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _NetworkPainter(
              nodes: _nodes,
              progress: _controller.value,
              pointer: _pointer,
              isDark: widget.isDark,
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _Node {
  _Node({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
  });

  double x;
  double y;
  double vx;
  double vy;
  final double radius;

  factory _Node.random() {
    final random = math.Random();
    return _Node(
      x: random.nextDouble(),
      y: random.nextDouble(),
      vx: (random.nextDouble() - 0.5) * 0.00035,
      vy: (random.nextDouble() - 0.5) * 0.00035,
      radius: 1.2 + random.nextDouble() * 1.8,
    );
  }
}

class _NetworkPainter extends CustomPainter {
  _NetworkPainter({
    required this.nodes,
    required this.progress,
    required this.pointer,
    required this.isDark,
  });

  final List<_Node> nodes;
  final double progress;
  final Offset? pointer;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final nodePaint = Paint()..style = PaintingStyle.fill;
    final accent = isDark ? AppColors.red : AppColors.lightAccent;

    for (final node in nodes) {
      node.x = (node.x + node.vx) % 1;
      node.y = (node.y + node.vy) % 1;
      if (node.x < 0) node.x += 1;
      if (node.y < 0) node.y += 1;
    }

    for (var i = 0; i < nodes.length; i++) {
      final a = Offset(nodes[i].x * size.width, nodes[i].y * size.height);
      for (var j = i + 1; j < nodes.length; j++) {
        final b = Offset(nodes[j].x * size.width, nodes[j].y * size.height);
        final distance = (a - b).distance;
        if (distance > 160) continue;
        final opacity = (1 - distance / 160) * (isDark ? 0.28 : 0.18);
        linePaint.color = accent.withValues(alpha: opacity);
        canvas.drawLine(a, b, linePaint);
      }

      if (pointer != null) {
        final toPointer = (a - pointer!).distance;
        if (toPointer < 180) {
          linePaint.color = accent.withValues(alpha: (1 - toPointer / 180) * 0.45);
          canvas.drawLine(a, pointer!, linePaint);
        }
      }

      nodePaint.color = accent.withValues(alpha: isDark ? 0.55 : 0.4);
      canvas.drawCircle(a, nodes[i].radius, nodePaint);
      nodePaint.color = accent.withValues(alpha: 0.12);
      canvas.drawCircle(a, nodes[i].radius + 4, nodePaint);
    }

    final glow = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width * 0.5, size.height * 0.2),
        size.width * 0.55,
        [
          accent.withValues(alpha: isDark ? 0.08 : 0.05),
          Colors.transparent,
        ],
      );
    canvas.drawRect(Offset.zero & size, glow);
  }

  @override
  bool shouldRepaint(covariant _NetworkPainter oldDelegate) => true;
}
