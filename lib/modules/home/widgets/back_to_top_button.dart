import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_website/app/theme/app_colors.dart';
import 'package:portfolio_website/modules/home/controllers/home_controller.dart';

class BackToTopButton extends GetView<HomeController> {
  const BackToTopButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accent : AppColors.lightAccent;

    return Obx(() {
      return AnimatedSlide(
        duration: const Duration(milliseconds: 280),
        offset: controller.showBackToTop.value
            ? Offset.zero
            : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 280),
          opacity: controller.showBackToTop.value ? 1 : 0,
          child: FloatingActionButton.small(
            onPressed: controller.scrollToTop,
            tooltip: 'back_to_top'.tr,
            backgroundColor: accent,
            foregroundColor: AppColors.pureWhite,
            child: const Icon(Icons.keyboard_arrow_up_rounded),
          ),
        ),
      );
    });
  }
}
