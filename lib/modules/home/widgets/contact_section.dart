import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_website/app/theme/app_colors.dart';
import 'package:portfolio_website/core/services/localization_service.dart';
import 'package:portfolio_website/core/utils/url_helper.dart';
import 'package:portfolio_website/core/widgets/scroll_reveal.dart';
import 'package:portfolio_website/core/widgets/section_container.dart';
import 'package:portfolio_website/core/widgets/section_title.dart';
import 'package:portfolio_website/modules/home/controllers/home_controller.dart';

class ContactSection extends GetView<HomeController> {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Get.find<LocalizationService>().locale.value;
      final data = controller.portfolio.value;
      if (data == null) return const SizedBox.shrink();
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final profile = data.profile;

      final links = [
        (
          icon: FontAwesomeIcons.telegram,
          label: 'telegram'.tr,
          value: profile.social.telegram.replaceFirst('https://t.me/', '@'),
          url: profile.social.telegram,
        ),
        (
          icon: FontAwesomeIcons.whatsapp,
          label: 'whatsapp'.tr,
          value: profile.phone,
          url: profile.social.whatsapp,
        ),
        (
          icon: FontAwesomeIcons.envelope,
          label: 'email'.tr.toUpperCase(),
          value: profile.email,
          url: profile.social.email,
        ),
        (
          icon: FontAwesomeIcons.github,
          label: 'github'.tr.toUpperCase(),
          value: 'github_profile'.tr,
          url: profile.social.github,
        ),
        (
          icon: FontAwesomeIcons.linkedin,
          label: 'linkedin'.tr,
          value: 'linkedin_profile'.tr,
          url: profile.social.linkedin,
        ),
        if (profile.social.instagram.isNotEmpty)
          (
            icon: FontAwesomeIcons.instagram,
            label: 'instagram'.tr,
            value: 'instagram_profile'.tr,
            url: profile.social.instagram,
          ),
      ];

      return SectionContainer(
        sectionKey: controller.contactKey,
        child: Column(
          children: [
            ScrollReveal(
              child: SectionTitle(
                number: '7.',
                title: 'section_contact'.tr,
                alignCenter: true,
              ),
            ),
            SizedBox(height: 16.h),
            ScrollReveal(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Text(
                  'contact_subtitle'.tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    color: isDark ? AppColors.muted : AppColors.lightMuted,
                    fontSize: 15,
                    height: 1.9,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            ScrollReveal(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Column(
                  children: links
                      .map(
                        (link) => Padding(
                          padding: EdgeInsets.only(bottom: 14.h),
                          child: _ContactRow(
                            icon: link.icon,
                            label: link.label,
                            value: link.value,
                            url: link.url,
                            isDark: isDark,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            SizedBox(height: 28.h),
            ScrollReveal(
              child: _MiniForm(controller: controller, isDark: isDark),
            ),
          ],
        ),
      );
    });
  }
}

class _ContactRow extends StatefulWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final String value;
  final String url;
  final bool isDark;

  @override
  State<_ContactRow> createState() => _ContactRowState();
}

class _ContactRowState extends State<_ContactRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.isDark ? AppColors.red : AppColors.lightAccent;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: Matrix4.translationValues(_hovered ? -4 : 0, 0, 0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => UrlHelper.open(widget.url),
            borderRadius: BorderRadius.circular(14),
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: accent.withValues(alpha: _hovered ? 0.1 : 0.04),
                border: Border.all(
                  color: _hovered ? accent : AppColors.redLine,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent.withValues(alpha: 0.12),
                    ),
                    alignment: Alignment.center,
                    child: FaIcon(widget.icon, size: 16, color: accent),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.label,
                          style: GoogleFonts.rajdhani(
                            color: widget.isDark
                                ? AppColors.mutedDim
                                : AppColors.lightMuted,
                            fontSize: 12,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.value,
                          style: GoogleFonts.tajawal(
                            color: widget.isDark
                                ? AppColors.text
                                : AppColors.lightText,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniForm extends StatelessWidget {
  const _MiniForm({required this.controller, required this.isDark});

  final HomeController controller;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.contactFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: controller.nameController,
            decoration: InputDecoration(labelText: 'name'.tr),
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'required'.tr : null,
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: controller.emailController,
            decoration: InputDecoration(labelText: 'email'.tr),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'required'.tr;
              if (!GetUtils.isEmail(value.trim())) return 'invalid_email'.tr;
              return null;
            },
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: controller.messageController,
            maxLines: 4,
            decoration: InputDecoration(labelText: 'message'.tr),
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'required'.tr : null,
          ),
          SizedBox(height: 18.h),
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isSending.value
                    ? null
                    : controller.submitContactForm,
                child: Text(
                  controller.isSending.value ? 'sending'.tr : 'send_message'.tr,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
