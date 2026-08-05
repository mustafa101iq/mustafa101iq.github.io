import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_website/app/theme/app_fonts.dart';
import 'package:portfolio_website/app/theme/app_colors.dart';
import 'package:portfolio_website/app/utils/responsive.dart';
import 'package:portfolio_website/core/services/localization_service.dart';
import 'package:portfolio_website/core/services/theme_service.dart';
import 'package:portfolio_website/modules/home/controllers/home_controller.dart';

class PortfolioNavbar extends GetView<HomeController> {
  const PortfolioNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final localization = Get.find<LocalizationService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.red : AppColors.lightAccent;

    return Obx(() {
      localization.locale.value;
      final scrolled = controller.isNavScrolled.value;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: context.horizontalPadding,
          vertical: scrolled ? 10 : 14,
        ),
        decoration: BoxDecoration(
          color: (isDark ? AppColors.voidBg : AppColors.lightBg).withValues(
            alpha: scrolled ? 0.96 : 0.72,
          ),
          border: Border(
            bottom: BorderSide(
              color: isDark
                  ? AppColors.red.withValues(alpha: scrolled ? 0.18 : 0)
                  : AppColors.lightBorder.withValues(alpha: scrolled ? 1 : 0),
            ),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Row(
                children: [
                  Text(
                    'MQ.',
                    style: GoogleFonts.orbitron(
                      color: accent,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  if (context.isDesktopLayout)
                    ...controller.navItems.map(
                      (item) => _NavLink(
                        label: item.labelKey.tr,
                        isActive:
                            controller.activeSection.value == item.section,
                        onTap: () => controller.scrollToSection(item.section),
                        isDark: isDark,
                      ),
                    )
                  else
                    IconButton(
                      tooltip: 'menu'.tr,
                      onPressed: () => _openDrawer(context, isDark),
                      icon: Icon(
                        Icons.menu_rounded,
                        color: isDark ? AppColors.text : AppColors.lightText,
                      ),
                    ),
                  TextButton(
                    onPressed: localization.toggleLocale,
                    child: Text(
                      localization.isArabic ? 'EN' : 'AR',
                      style: GoogleFonts.orbitron(
                        color: accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: themeService.isDarkMode.value
                        ? 'light_mode'.tr
                        : 'dark_mode'.tr,
                    onPressed: themeService.toggleTheme,
                    icon: Icon(
                      themeService.isDarkMode.value
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      color: accent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _openDrawer(BuildContext context, bool isDark) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark ? AppColors.panel : AppColors.pureWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: controller.navItems.map((item) {
              return ListTile(
                title: Text(
                  item.labelKey.tr,
                  style: AppFonts.arabic(fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  controller.scrollToSection(item.section);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.isDark,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? AppColors.redGlow : AppColors.lightAccent;
    final color = isActive
        ? accent
        : (isDark ? AppColors.muted : AppColors.lightMuted);

    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: GoogleFonts.rajdhani(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
