import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_website/app/theme/app_colors.dart';
import 'package:portfolio_website/app/utils/responsive.dart';
import 'package:portfolio_website/core/services/localization_service.dart';
import 'package:portfolio_website/core/utils/url_helper.dart';
import 'package:portfolio_website/core/widgets/scroll_reveal.dart';
import 'package:portfolio_website/core/widgets/section_container.dart';
import 'package:portfolio_website/modules/home/controllers/home_controller.dart';
import 'package:portfolio_website/modules/home/models/portfolio_models.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HeroSection extends GetView<HomeController> {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Get.find<LocalizationService>().locale.value;
      final data = controller.portfolio.value;
      if (data == null) return const SizedBox.shrink();
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final profile = data.profile;
      final accent = isDark ? AppColors.red : AppColors.lightAccent;

      return SectionContainer(
        sectionKey: controller.homeKey,
        padding: EdgeInsets.fromLTRB(
          context.horizontalPadding,
          context.isMobileLayout ? 72.h : 96,
          context.horizontalPadding,
          context.isMobileLayout ? 48.h : 64,
        ),
        child: ScrollReveal(
          child: Column(
            children: [
              _AvatarRing(profile: profile, accent: accent, isDark: isDark),
              SizedBox(height: 38.h),
              Text(
                'hi_im'.trParams({'name': profile.fullName.text}),
                textAlign: TextAlign.center,
                style: Get.find<LocalizationService>().isArabic
                    ? GoogleFonts.tajawal(
                        color: isDark ? AppColors.redGlow : AppColors.lightAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      )
                    : GoogleFonts.orbitron(
                        color: isDark ? AppColors.redGlow : AppColors.lightAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 5,
                        shadows: [
                          Shadow(
                            color: accent.withValues(alpha: 0.55),
                            blurRadius: 18,
                          ),
                        ],
                      ),
              ),
              SizedBox(height: 14.h),
              Text(
                'job_title'.tr,
                textAlign: TextAlign.center,
                style: Get.find<LocalizationService>().isArabic
                    ? GoogleFonts.tajawal(
                        color: isDark ? AppColors.pureWhite : AppColors.lightText,
                        fontSize: context.isMobileLayout ? 30.sp : 48,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      )
                    : GoogleFonts.orbitron(
                        color: isDark ? AppColors.pureWhite : AppColors.lightText,
                        fontSize: context.isMobileLayout ? 34.sp : 56,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        letterSpacing: 1,
                        shadows: [
                          Shadow(
                            color: accent.withValues(alpha: 0.35),
                            blurRadius: 30,
                          ),
                        ],
                      ),
              ),
              SizedBox(height: 18.h),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Text(
                  'short_bio'.tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.tajawal(
                    color: isDark ? AppColors.muted : AppColors.lightMuted,
                    fontSize: 16,
                    height: 1.9,
                  ),
                ),
              ),
              SizedBox(height: 36.h),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  _SocialCircle(
                    icon: FontAwesomeIcons.github,
                    url: profile.social.github,
                    isDark: isDark,
                  ),
                  _SocialCircle(
                    icon: FontAwesomeIcons.linkedin,
                    url: profile.social.linkedin,
                    isDark: isDark,
                  ),
                  if (profile.social.instagram.isNotEmpty)
                    _SocialCircle(
                      icon: FontAwesomeIcons.instagram,
                      url: profile.social.instagram,
                      isDark: isDark,
                    ),
                  _SocialCircle(
                    icon: FontAwesomeIcons.whatsapp,
                    url: profile.social.whatsapp,
                    isDark: isDark,
                  ),
                  _SocialCircle(
                    icon: FontAwesomeIcons.telegram,
                    url: profile.social.telegram,
                    isDark: isDark,
                  ),
                  _SocialCircle(
                    icon: FontAwesomeIcons.envelope,
                    url: profile.social.email,
                    isDark: isDark,
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: LinearGradient(
                    colors: [
                      accent,
                      isDark ? const Color(0xFFB81C17) : const Color(0xFFB81C17),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.4),
                      blurRadius: 30,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: controller.downloadCv,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: AppColors.pureWhite,
                  ),
                  child: Text('download_cv'.tr),
                ),
              ),
              SizedBox(height: 56.h),
              Column(
                children: [
                  Text(
                    'scroll'.tr,
                    style: GoogleFonts.rajdhani(
                      color: isDark ? AppColors.mutedDim : AppColors.lightMuted,
                      fontSize: 12,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: 1,
                    height: 34,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [accent, accent.withValues(alpha: 0)],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _AvatarRing extends StatefulWidget {
  const _AvatarRing({
    required this.profile,
    required this.accent,
    required this.isDark,
  });

  final ProfileModel profile;
  final Color accent;
  final bool isDark;

  @override
  State<_AvatarRing> createState() => _AvatarRingState();
}

class _AvatarRingState extends State<_AvatarRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibility(VisibilityInfo info) {
    final visible = info.visibleFraction > 0.05;
    if (visible == _visible) return;
    _visible = visible;
    if (visible) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = context.isMobileLayout ? 150.0 : 190.0;
    final initials = _initials(widget.profile.fullName.en);

    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: widget.accent, width: 3),
        boxShadow: [
          BoxShadow(
            color: widget.accent.withValues(alpha: 0.55),
            blurRadius: 45,
          ),
          BoxShadow(
            color: widget.accent.withValues(alpha: 0.25),
            blurRadius: 90,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: widget.profile.avatarUrl.isNotEmpty
          ? (widget.profile.avatarUrl.startsWith('assets/')
              ? Transform.scale(
                  scale: 1.35,
                  child: Image.asset(
                    widget.profile.avatarUrl,
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.45),
                    filterQuality: FilterQuality.high,
                  ),
                )
              : Transform.scale(
                  scale: 1.35,
                  child: Image.network(
                    widget.profile.avatarUrl,
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.45),
                    filterQuality: FilterQuality.high,
                  ),
                ))
          : Container(
              color: widget.isDark ? AppColors.panel : AppColors.lightBg,
              alignment: Alignment.center,
              child: Text(
                initials,
                style: GoogleFonts.orbitron(
                  color: widget.accent,
                  fontSize: size * 0.22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
    );

    return VisibilityDetector(
      key: const Key('hero-avatar-ring'),
      onVisibilityChanged: _onVisibility,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          child: avatar,
          builder: (context, child) {
            return SizedBox(
              width: size + 56,
              height: size + 56,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: _controller.value * 6.2832,
                    child: SizedBox(
                      width: size + 56,
                      height: size + 56,
                      child: const CustomPaint(
                        painter: _DashedCirclePainter(
                          color: AppColors.redLine,
                        ),
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: -_controller.value * 6.2832 * 0.6,
                    child: Container(
                      width: size + 28,
                      height: size + 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.redDeep, width: 1.5),
                      ),
                    ),
                  ),
                  child!,
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'MQ';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final rect = Offset.zero & size;
    const dashWidth = 6.0;
    const dashSpace = 6.0;
    final radius = size.width / 2;
    final circumference = 2 * 3.14159 * radius;
    final dashCount = (circumference / (dashWidth + dashSpace)).floor();
    final sweep = (dashWidth / circumference) * 6.2832;
    final gap = (dashSpace / circumference) * 6.2832;
    var start = 0.0;
    for (var i = 0; i < dashCount; i++) {
      canvas.drawArc(rect.deflate(0.5), start, sweep, false, paint);
      start += sweep + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _SocialCircle extends StatefulWidget {
  const _SocialCircle({
    required this.icon,
    required this.url,
    required this.isDark,
  });

  final IconData icon;
  final String url;
  final bool isDark;

  @override
  State<_SocialCircle> createState() => _SocialCircleState();
}

class _SocialCircleState extends State<_SocialCircle> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.isDark ? AppColors.red : AppColors.lightAccent;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: accent.withValues(alpha: _hovered ? 0.18 : 0.06),
          border: Border.all(
            color: _hovered ? accent : AppColors.redDeep,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.45),
                    blurRadius: 22,
                  ),
                ]
              : null,
        ),
        child: IconButton(
          onPressed: () => UrlHelper.open(widget.url),
          icon: FaIcon(
            widget.icon,
            size: 18,
            color: widget.isDark ? AppColors.text : AppColors.lightText,
          ),
        ),
      ),
    );
  }
}
