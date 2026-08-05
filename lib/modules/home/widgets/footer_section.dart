import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_website/app/theme/app_colors.dart';
import 'package:portfolio_website/app/theme/app_fonts.dart';
import 'package:portfolio_website/core/services/localization_service.dart';
import 'package:portfolio_website/core/services/visit_counter_service.dart';
import 'package:portfolio_website/core/utils/url_helper.dart';
import 'package:portfolio_website/modules/home/controllers/home_controller.dart';

class FooterSection extends GetView<HomeController> {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Get.find<LocalizationService>().locale.value;
      final data = controller.portfolio.value;
      if (data == null) return const SizedBox.shrink();
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final social = data.profile.social;
      final visits = Get.find<VisitCounterService>().totalVisits.value;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 28.w),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark
                  ? AppColors.red.withValues(alpha: 0.15)
                  : AppColors.lightBorder,
            ),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Icon(icon: FontAwesomeIcons.github, url: social.github),
                _Icon(icon: FontAwesomeIcons.linkedin, url: social.linkedin),
                if (social.instagram.isNotEmpty)
                  _Icon(icon: FontAwesomeIcons.instagram, url: social.instagram),
                _Icon(icon: FontAwesomeIcons.whatsapp, url: social.whatsapp),
                _Icon(icon: FontAwesomeIcons.telegram, url: social.telegram),
              ],
            ),
            SizedBox(height: 18.h),
            Text(
              '${data.profile.fullName.text} — ${'footer_role'.tr} © ${DateTime.now().year}',
              textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                color: isDark ? AppColors.mutedDim : AppColors.lightMuted,
                fontSize: 12,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (visits != null) ...[
              SizedBox(height: 10.h),
              Text(
                'total_visits'.trParams({
                  'count': _formatCount(visits),
                }),
                textAlign: TextAlign.center,
                style: AppFonts.arabic(
                  color: isDark ? AppColors.mutedDim : AppColors.lightMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  String _formatCount(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final reverseIndex = digits.length - i;
      buffer.write(digits[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write(',');
      }
    }
    return buffer.toString();
  }
}

class _Icon extends StatelessWidget {
  const _Icon({required this.icon, required this.url});

  final IconData icon;
  final String url;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      onPressed: () => UrlHelper.open(url),
      icon: FaIcon(
        icon,
        size: 16,
        color: isDark ? AppColors.muted : AppColors.lightMuted,
      ),
    );
  }
}
