import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portfolio_website/core/services/localization_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_website/app/theme/app_fonts.dart';
import 'package:portfolio_website/app/theme/app_colors.dart';
import 'package:portfolio_website/app/utils/responsive.dart';
import 'package:portfolio_website/core/widgets/glass_card.dart';
import 'package:portfolio_website/core/widgets/scroll_reveal.dart';
import 'package:portfolio_website/core/widgets/section_container.dart';
import 'package:portfolio_website/core/widgets/section_title.dart';
import 'package:portfolio_website/modules/home/controllers/home_controller.dart';

class EducationSection extends GetView<HomeController> {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Get.find<LocalizationService>().locale.value;
      final data = controller.portfolio.value;
      if (data == null) return const SizedBox.shrink();
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final accent = isDark ? AppColors.accent : AppColors.lightAccent;

      return SectionContainer(
        sectionKey: controller.educationKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScrollReveal(
              child: SectionTitle(number: '6.', title: 'section_education'.tr),
            ),
            SizedBox(height: 32.h),
            ...data.education.asMap().entries.map((entry) {
              final item = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: ScrollReveal(
                  delay: Duration(milliseconds: 70 * entry.key),
                  child: GlassCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.school_outlined, color: accent),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.degree.text,
                                style: AppFonts.arabic(
                                  color: isDark
                                      ? AppColors.lightestSlate
                                      : AppColors.lightText,
                                  fontSize: context.isMobileLayout ? 15.sp : 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                item.institution.text,
                                style: AppFonts.arabic(
                                  color: accent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                item.period.text,
                                style: GoogleFonts.orbitron(
                                  color: isDark
                                      ? AppColors.slate
                                      : AppColors.lightMuted,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                item.description.text,
                                style: AppFonts.arabic(
                                  color: isDark
                                      ? AppColors.slate
                                      : AppColors.lightMuted,
                                  fontSize: 13.5,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}
