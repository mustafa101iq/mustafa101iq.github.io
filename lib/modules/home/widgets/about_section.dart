import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portfolio_website/app/theme/app_fonts.dart';
import 'package:portfolio_website/app/theme/app_colors.dart';
import 'package:portfolio_website/core/services/localization_service.dart';
import 'package:portfolio_website/core/widgets/glass_card.dart';
import 'package:portfolio_website/core/widgets/scroll_reveal.dart';
import 'package:portfolio_website/core/widgets/section_container.dart';
import 'package:portfolio_website/core/widgets/section_title.dart';
import 'package:portfolio_website/modules/home/controllers/home_controller.dart';

class AboutSection extends GetView<HomeController> {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Get.find<LocalizationService>().locale.value;
      final data = controller.portfolio.value;
      if (data == null) return const SizedBox.shrink();
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final accent = isDark ? AppColors.redGlow : AppColors.lightAccent;
      final text = isDark ? AppColors.text : AppColors.lightText;
      final muted = isDark ? AppColors.muted : AppColors.lightMuted;
      final profile = data.profile;
      final about = data.about;

      return SectionContainer(
        sectionKey: controller.aboutKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScrollReveal(
              child: SectionTitle(number: '1.', title: 'section_about'.tr),
            ),
            SizedBox(height: 36.h),
            ScrollReveal(
              child: GlassCard(
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 32.h),
                child: Column(
                  children: [
                    _CvBlock(
                      title: 'personal_info'.tr,
                      accent: accent,
                      child: Column(
                        children: [
                          _InfoRow(
                            label: 'info_name'.tr,
                            value: profile.fullName.text,
                            text: text,
                            muted: muted,
                          ),
                          _InfoRow(
                            label: 'info_nationality'.tr,
                            value: 'nationality_value'.tr,
                            text: text,
                            muted: muted,
                          ),
                          _InfoRow(
                            label: 'info_location'.tr,
                            value: profile.location.text,
                            text: text,
                            muted: muted,
                          ),
                          _InfoRow(
                            label: 'info_experience'.tr,
                            value:
                                '${profile.yearsOfExperience}+ ${'years_label'.tr}',
                            text: text,
                            muted: muted,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    _CvBlock(
                      title: 'specialization'.tr,
                      accent: accent,
                      child: Text(
                        about.specialization.text,
                        style: AppFonts.arabic(
                          color: text,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w300,
                          height: 2,
                        ),
                      ),
                    ),
                    _CvBlock(
                      title: 'bio'.tr,
                      accent: accent,
                      child: Text(
                        '${about.intro.text}\n\n${about.workStyle.text}',
                        style: AppFonts.arabic(
                          color: text,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w300,
                          height: 2,
                        ),
                      ),
                    ),
                    _CvBlock(
                      title: 'strengths'.tr,
                      accent: accent,
                      showDivider: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: about.strengths
                            .map(
                              (item) => Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: Text(
                                  '•  ${item.text}',
                                  style: AppFonts.arabic(
                                    color: text,
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w300,
                                    height: 1.8,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.text,
    required this.muted,
    this.isLast = false,
  });

  final String label;
  final String value;
  final Color text;
  final Color muted;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110.w,
            child: Text(
              label,
              style: AppFonts.arabic(
                color: muted,
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                height: 1.6,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppFonts.arabic(
                color: text,
                fontSize: 15.5,
                fontWeight: FontWeight.w400,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CvBlock extends StatelessWidget {
  const _CvBlock({
    required this.title,
    required this.child,
    required this.accent,
    this.showDivider = true,
  });

  final String title;
  final Widget child;
  final Color accent;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 22.h),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: isDark
                      ? AppColors.red.withValues(alpha: 0.18)
                      : AppColors.lightBorder,
                ),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppFonts.arabic(
              color: accent,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 14.h),
          child,
        ],
      ),
    );
  }
}
