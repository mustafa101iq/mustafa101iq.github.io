import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio_website/app/theme/app_colors.dart';
import 'package:portfolio_website/app/utils/responsive.dart';

class SectionContainer extends StatelessWidget {
  const SectionContainer({
    super.key,
    required this.child,
    this.sectionKey,
    this.padding,
  });

  final Widget child;
  final Key? sectionKey;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: sectionKey,
      width: double.infinity,
      alignment: Alignment.center,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: context.horizontalPadding,
            vertical: context.isMobileLayout ? 56.h : 72,
          ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.contentMaxWidth),
        child: child,
      ),
    );
  }
}

class AccentText extends StatelessWidget {
  const AccentText(this.text, {super.key, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(
        color: isDark ? AppColors.redGlow : AppColors.lightAccent,
      ),
    );
  }
}
