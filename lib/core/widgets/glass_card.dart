import 'package:flutter/material.dart';
import 'package:portfolio_website/app/theme/app_colors.dart';

class GlassCard extends StatefulWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.borderRadius = 22,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double borderRadius;

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.08),
              blurRadius: 40,
              offset: const Offset(0, 18),
            ),
            if (_hovered)
              BoxShadow(
                color: (isDark ? AppColors.red : AppColors.lightAccent)
                    .withValues(alpha: 0.18),
                blurRadius: 28,
              ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [AppColors.panel, AppColors.panel2]
                      : [AppColors.pureWhite, const Color(0xFFFFF8F7)],
                ),
                border: Border.all(
                  color: _hovered
                      ? (isDark ? AppColors.red : AppColors.lightAccent)
                          .withValues(alpha: 0.55)
                      : (isDark ? AppColors.redLine : AppColors.lightBorder),
                ),
              ),
              child: Padding(
                padding: widget.padding ?? const EdgeInsets.all(28),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
