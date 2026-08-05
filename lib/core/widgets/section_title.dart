import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_website/app/theme/app_colors.dart';
import 'package:portfolio_website/app/utils/responsive.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.number,
    required this.title,
    this.alignCenter = false,
  });

  final String number;
  final String title;
  final bool alignCenter;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.redDeep : AppColors.lightAccent;
    final titleColor = isDark ? AppColors.pureWhite : AppColors.lightText;
    final numLabel = number.replaceAll('.', '').padLeft(2, '0');

    return Row(
      mainAxisAlignment:
          alignCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: accent),
          ),
          child: Text(
            numLabel,
            style: GoogleFonts.orbitron(
              color: accent,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 14.w),
        Flexible(
          child: Text(
            title,
            style: GoogleFonts.tajawal(
              color: titleColor,
              fontSize: context.isMobileLayout ? 26.sp : 32,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
