import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portfolio_website/core/services/localization_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_website/app/theme/app_colors.dart';
import 'package:portfolio_website/app/utils/responsive.dart';
import 'package:portfolio_website/core/widgets/glass_card.dart';
import 'package:portfolio_website/core/widgets/scroll_reveal.dart';
import 'package:portfolio_website/core/widgets/section_container.dart';
import 'package:portfolio_website/core/widgets/section_title.dart';
import 'package:portfolio_website/modules/home/controllers/home_controller.dart';
import 'package:portfolio_website/modules/home/models/portfolio_models.dart';

class ServicesSection extends GetView<HomeController> {
  const ServicesSection({super.key});

  IconData _iconFor(String key) {
    return switch (key) {
      'phone_android' => Icons.phone_android_rounded,
      'palette' => Icons.palette_outlined,
      'cloud' => Icons.cloud_outlined,
      'api' => Icons.hub_outlined,
      'store' => Icons.storefront_outlined,
      'build' => Icons.build_circle_outlined,
      _ => Icons.widgets_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Get.find<LocalizationService>().locale.value;
      final data = controller.portfolio.value;
      if (data == null) return const SizedBox.shrink();
      final crossAxisCount = context.isDesktopLayout
          ? 3
          : context.isTabletLayout
          ? 2
          : 1;
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final accent = isDark ? AppColors.accent : AppColors.lightAccent;

      return SectionContainer(
        sectionKey: controller.servicesKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScrollReveal(
              child: SectionTitle(number: '3.', title: 'section_services'.tr),
            ),
            SizedBox(height: 14.h),
            ScrollReveal(
              child: Text(
                'services_subtitle'.tr,
                style: GoogleFonts.tajawal(
                  color: isDark ? AppColors.muted : AppColors.lightMuted,
                  fontSize: 15,
                  height: 1.8,
                ),
              ),
            ),
            SizedBox(height: 28.h),
            LayoutBuilder(
              builder: (context, constraints) {
                final spacing = 18.0;
                final itemWidth =
                    (constraints.maxWidth - spacing * (crossAxisCount - 1)) /
                    crossAxisCount;
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (var i = 0; i < data.services.length; i++)
                      SizedBox(
                        width: itemWidth,
                        child: ScrollReveal(
                          delay: Duration(milliseconds: 60 * (i % 6)),
                          child: _ServiceCard(
                            service: data.services[i],
                            icon: _iconFor(data.services[i].icon),
                            accent: accent,
                            isDark: isDark,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      );
    });
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.service,
    required this.icon,
    required this.accent,
    required this.isDark,
  });

  final ServiceModel service;
  final IconData icon;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accent, size: 22),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_outward_rounded,
                color: isDark ? AppColors.slate : AppColors.lightMuted,
                size: 18,
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Text(
            service.title.text,
            style: GoogleFonts.tajawal(
              color: isDark ? AppColors.lightestSlate : AppColors.lightText,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.35,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            service.description.text,
            style: GoogleFonts.tajawal(
              color: isDark ? AppColors.lightSlate : AppColors.lightMuted,
              fontSize: 14,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
