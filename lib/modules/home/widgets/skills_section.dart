import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portfolio_website/core/services/localization_service.dart';
import 'package:portfolio_website/app/theme/app_fonts.dart';
import 'package:portfolio_website/app/theme/app_colors.dart';
import 'package:portfolio_website/core/widgets/glass_card.dart';
import 'package:portfolio_website/core/widgets/scroll_reveal.dart';
import 'package:portfolio_website/core/widgets/section_container.dart';
import 'package:portfolio_website/core/widgets/section_title.dart';
import 'package:portfolio_website/modules/home/controllers/home_controller.dart';

class SkillsSection extends GetView<HomeController> {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Get.find<LocalizationService>().locale.value;
      final data = controller.portfolio.value;
      if (data == null) return const SizedBox.shrink();
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return SectionContainer(
        sectionKey: controller.skillsKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScrollReveal(
              child: SectionTitle(number: '2.', title: 'section_skills'.tr),
            ),
            SizedBox(height: 28.h),
            ScrollReveal(
              child: GlassCard(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: data.skills
                      .map(
                        (skill) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.redDeep
                                  : AppColors.lightBorder,
                            ),
                            color: (isDark ? AppColors.red : AppColors.lightAccent)
                                .withValues(alpha: 0.07),
                          ),
                          child: Text(
                            skill.name.text,
                            style: AppFonts.arabic(
                              color: isDark ? AppColors.text : AppColors.lightText,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
