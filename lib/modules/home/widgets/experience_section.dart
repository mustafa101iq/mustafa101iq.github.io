import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_website/app/theme/app_colors.dart';
import 'package:portfolio_website/core/services/localization_service.dart';
import 'package:portfolio_website/core/widgets/scroll_reveal.dart';
import 'package:portfolio_website/core/widgets/section_container.dart';
import 'package:portfolio_website/core/widgets/section_title.dart';
import 'package:portfolio_website/modules/home/controllers/home_controller.dart';
import 'package:portfolio_website/modules/home/models/portfolio_models.dart';

class ExperienceSection extends GetView<HomeController> {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Get.find<LocalizationService>().locale.value;
      final data = controller.portfolio.value;
      if (data == null) return const SizedBox.shrink();
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final accent = isDark ? AppColors.accent : AppColors.lightAccent;
      final isRtl = Directionality.of(context) == TextDirection.rtl;
      final isArabic = Get.find<LocalizationService>().isArabic;

      return SectionContainer(
        sectionKey: controller.experienceKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScrollReveal(
              child: SectionTitle(number: '5.', title: 'section_experience'.tr),
            ),
            SizedBox(height: 36.h),
            ScrollReveal(
              child: Stack(
                children: [
                  Positioned(
                    top: 7,
                    bottom: 7,
                    left: isRtl ? null : 13,
                    right: isRtl ? 13 : null,
                    child: Container(
                      width: 2,
                      color: accent.withValues(alpha: 0.25),
                    ),
                  ),
                  Column(
                    children: List.generate(data.experience.length, (index) {
                      final item = data.experience[index];
                      final isLast = index == data.experience.length - 1;
                      return _TimelineItem(
                        item: item,
                        isLast: isLast,
                        accent: accent,
                        isDark: isDark,
                        isArabic: isArabic,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.item,
    required this.isLast,
    required this.accent,
    required this.isDark,
    required this.isArabic,
  });

  final ExperienceModel item;
  final bool isLast;
  final Color accent;
  final bool isDark;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final periodStyle = isArabic
        ? GoogleFonts.tajawal(
            color: accent,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          )
        : GoogleFonts.orbitron(color: accent, fontSize: 12);

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 32.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Container(
              width: 14,
              height: 14,
              margin: const EdgeInsets.only(top: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent,
                border: Border.all(
                  color: isDark ? AppColors.voidBg : AppColors.lightBg,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.35),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.period.text, style: periodStyle),
                SizedBox(height: 8.h),
                Text(
                  item.role.text,
                  style: GoogleFonts.tajawal(
                    color: isDark
                        ? AppColors.lightestSlate
                        : AppColors.lightText,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  item.company.text,
                  style: GoogleFonts.tajawal(
                    color: isDark
                        ? AppColors.lightSlate
                        : AppColors.lightMuted,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  item.description.text,
                  style: GoogleFonts.tajawal(
                    color: isDark ? AppColors.slate : AppColors.lightMuted,
                    fontSize: 14,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
