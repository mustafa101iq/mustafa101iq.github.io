import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_website/app/theme/app_fonts.dart';
import 'package:portfolio_website/app/theme/app_colors.dart';
import 'package:portfolio_website/app/utils/responsive.dart';
import 'package:portfolio_website/core/services/localization_service.dart';
import 'package:portfolio_website/core/utils/url_helper.dart';
import 'package:portfolio_website/core/widgets/cached_asset_image.dart';
import 'package:portfolio_website/core/widgets/scroll_reveal.dart';
import 'package:portfolio_website/core/widgets/section_container.dart';
import 'package:portfolio_website/core/widgets/section_title.dart';
import 'package:portfolio_website/modules/home/controllers/home_controller.dart';
import 'package:portfolio_website/modules/home/models/project_model.dart';

const _phoneScreenshotAspect = 472 / 1024;

class ProjectsSection extends GetView<HomeController> {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Get.find<LocalizationService>().locale.value;
      if (controller.projects.isEmpty) return const SizedBox.shrink();
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return SectionContainer(
        sectionKey: controller.projectsKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScrollReveal(
              child: SectionTitle(number: '4.', title: 'section_projects'.tr),
            ),
            SizedBox(height: 14.h),
            ScrollReveal(
              child: Text(
                'projects_subtitle'.tr,
                style: AppFonts.arabic(
                  color: isDark ? AppColors.muted : AppColors.lightMuted,
                  fontSize: 15,
                  height: 1.8,
                ),
              ),
            ),
            SizedBox(height: 36.h),
            ...controller.projects.asMap().entries.map(
              (entry) => Padding(
                padding: EdgeInsets.only(bottom: 32.h),
                child: ScrollReveal(
                  delay: Duration(milliseconds: 70 * entry.key),
                  child: _ProjectFeature(
                    project: entry.value,
                    index: entry.key,
                    isDark: isDark,
                    onDetails: () => controller.showProjectDetails(entry.value),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _ProjectFeature extends StatefulWidget {
  const _ProjectFeature({
    required this.project,
    required this.index,
    required this.isDark,
    required this.onDetails,
  });

  final ProjectModel project;
  final int index;
  final bool isDark;
  final VoidCallback onDetails;

  @override
  State<_ProjectFeature> createState() => _ProjectFeatureState();
}

class _ProjectFeatureState extends State<_ProjectFeature> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.isDark ? AppColors.accent : AppColors.lightAccent;
    final visual = _ProjectVisual(
      project: widget.project,
      index: widget.index,
      accent: accent,
      isDark: widget.isDark,
      hovered: _hovered,
    );
    final details = _ProjectDetails(
      project: widget.project,
      index: widget.index,
      accent: accent,
      isDark: widget.isDark,
      onDetails: widget.onDetails,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        padding: EdgeInsets.all(context.isMobileLayout ? 18.w : 26),
        decoration: BoxDecoration(
          color: widget.isDark ? AppColors.navyLight : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: _hovered
                ? accent.withValues(alpha: 0.3)
                : widget.isDark
                ? AppColors.slate.withValues(alpha: 0.14)
                : AppColors.lightBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: widget.isDark
                    ? (_hovered ? 0.2 : 0.12)
                    : (_hovered ? 0.08 : 0.04),
              ),
              blurRadius: _hovered ? 36 : 24,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: context.isDesktopLayout
            ? Row(
                children: widget.index.isEven
                    ? [
                        Expanded(flex: 11, child: visual),
                        SizedBox(width: 38.w),
                        Expanded(flex: 9, child: details),
                      ]
                    : [
                        Expanded(flex: 9, child: details),
                        SizedBox(width: 38.w),
                        Expanded(flex: 11, child: visual),
                      ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  visual,
                  SizedBox(height: 26.h),
                  details,
                ],
              ),
      ),
    );
  }
}

class _ProjectVisual extends StatefulWidget {
  const _ProjectVisual({
    required this.project,
    required this.index,
    required this.accent,
    required this.isDark,
    required this.hovered,
  });

  final ProjectModel project;
  final int index;
  final Color accent;
  final bool isDark;
  final bool hovered;

  @override
  State<_ProjectVisual> createState() => _ProjectVisualState();
}

class _ProjectVisualState extends State<_ProjectVisual> {
  late final PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.project.previewImages;
    final isCover = widget.project.isCoverVisual;
    final isMobile = context.isMobileLayout;
    final phoneW = isMobile ? 156.0 : 176.0;
    final phoneH = phoneW / _phoneScreenshotAspect;
    final height = isCover
        ? (isMobile ? 420.h : 520.0)
        : phoneH + (isMobile ? 56 : 48);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      height: height,
      transform: Matrix4.translationValues(0, widget.hovered ? -3 : 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: widget.isDark ? const Color(0xFF0E0605) : const Color(0xFFF0E6E3),
      ),
      clipBehavior: Clip.antiAlias,
      child: images.isEmpty
          ? _FallbackVisual(
              index: widget.index,
              accent: widget.accent,
              isMobile: context.isMobileLayout,
            )
          : isCover
          ? _CoverGallery(
              images: images,
              pageController: _pageController,
              page: _page,
              accent: widget.accent,
              isDark: widget.isDark,
              onPageChanged: (i) => setState(() => _page = i),
            )
          : _DeviceGallery(
              images: images,
              pageController: _pageController,
              page: _page,
              accent: widget.accent,
              index: widget.index,
              onPageChanged: (i) => setState(() => _page = i),
            ),
    );
  }
}

class _CoverGallery extends StatelessWidget {
  const _CoverGallery({
    required this.images,
    required this.pageController,
    required this.page,
    required this.accent,
    required this.isDark,
    required this.onPageChanged,
  });

  final List<String> images;
  final PageController pageController;
  final int page;
  final Color accent;
  final bool isDark;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: isDark ? const Color(0xFF120808) : const Color(0xFFEDE4F5),
        ),
        PageView.builder(
          controller: pageController,
          itemCount: images.length,
          onPageChanged: onPageChanged,
          itemBuilder: (_, i) => Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 34),
            child: CachedAssetImage(
              images[i],
              fit: BoxFit.contain,
              alignment: Alignment.center,
              displayWidth: 420,
              displayHeight: 520,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 10,
          child: _GalleryDots(
            count: images.length,
            index: page,
            accent: accent,
          ),
        ),
      ],
    );
  }
}

class _DeviceGallery extends StatelessWidget {
  const _DeviceGallery({
    required this.images,
    required this.pageController,
    required this.page,
    required this.accent,
    required this.index,
    required this.onPageChanged,
  });

  final List<String> images;
  final PageController pageController;
  final int page;
  final Color accent;
  final int index;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final palettes = [
      [const Color(0xFF1A3A6E), const Color(0xFF0A1424)],
      [const Color(0xFF3D2A6E), const Color(0xFF140F24)],
    ];
    final palette = palettes[index % palettes.length];
    final isMobile = context.isMobileLayout;
    final phoneW = isMobile ? 156.0 : 176.0;

    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: palette,
            ),
          ),
          child: const SizedBox.expand(),
        ),
        Positioned(
          top: -50,
          right: -40,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.12),
            ),
          ),
        ),
        Positioned(
          bottom: -30,
          left: -20,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: SizedBox(
              width: phoneW,
              child: AspectRatio(
                aspectRatio: _phoneScreenshotAspect,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A0C),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.45),
                        blurRadius: 28,
                        offset: const Offset(0, 18),
                      ),
                      BoxShadow(
                        color: accent.withValues(alpha: 0.2),
                        blurRadius: 40,
                        spreadRadius: -4,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: images.length,
                      onPageChanged: onPageChanged,
                      itemBuilder: (_, i) => CachedAssetImage(
                        images[i],
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        displayWidth: phoneW,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 10,
          child: _GalleryDots(
            count: images.length,
            index: page,
            accent: accent,
          ),
        ),
      ],
    );
  }
}

class _GalleryDots extends StatelessWidget {
  const _GalleryDots({
    required this.count,
    required this.index,
    required this.accent,
  });

  final int count;
  final int index;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    if (count <= 1) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? accent : Colors.white.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _FallbackVisual extends StatelessWidget {
  const _FallbackVisual({
    required this.index,
    required this.accent,
    required this.isMobile,
  });

  final int index;
  final Color accent;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A0A08),
      child: Center(
        child: Icon(
          Icons.phone_iphone_rounded,
          size: isMobile ? 48 : 64,
          color: accent.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _ProjectDetails extends StatelessWidget {
  const _ProjectDetails({
    required this.project,
    required this.index,
    required this.accent,
    required this.isDark,
    required this.onDetails,
  });

  final ProjectModel project;
  final int index;
  final Color accent;
  final bool isDark;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '0${index + 1} / ${'mobile_product'.tr}',
          style: GoogleFonts.rajdhani(
            color: accent,
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          project.title.text,
          style: AppFonts.arabic(
            color: isDark ? AppColors.lightestSlate : AppColors.lightText,
            fontSize: context.isMobileLayout ? 24.sp : 30,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          project.description.text,
          style: AppFonts.arabic(
            color: isDark ? AppColors.lightSlate : AppColors.lightMuted,
            fontSize: 15,
            height: 1.7,
          ),
        ),
        SizedBox(height: 20.h),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: project.technologies
              .map(
                (tech) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    tech.text,
                    style: AppFonts.arabic(
                      color: accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 28.h),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (project.liveDemoUrl.isNotEmpty)
              _PreviewButton(
                accent: accent,
                onTap: () => UrlHelper.open(project.liveDemoUrl),
              ),
            if (project.githubUrl.isNotEmpty)
              _GhostButton(
                label: 'github'.tr,
                icon: Icons.code_rounded,
                isDark: isDark,
                onTap: () => UrlHelper.open(project.githubUrl),
              ),
            _GhostButton(
              label: 'view_case_study'.tr,
              icon: Icons.article_outlined,
              isDark: isDark,
              onTap: onDetails,
            ),
          ],
        ),
      ],
    );
  }
}

class _PreviewButton extends StatefulWidget {
  const _PreviewButton({
    required this.accent,
    required this.onTap,
  });

  final Color accent;
  final VoidCallback onTap;

  @override
  State<_PreviewButton> createState() => _PreviewButtonState();
}

class _PreviewButtonState extends State<_PreviewButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 14.h,
          ),
          decoration: BoxDecoration(
            color: widget.accent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: widget.accent.withValues(alpha: _hovered ? 0.45 : 0.28),
                blurRadius: _hovered ? 22 : 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'live_demo'.tr,
                style: AppFonts.arabic(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_outward_rounded,
                color: Colors.white.withValues(alpha: 0.9),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GhostButton extends StatefulWidget {
  const _GhostButton({
    required this.label,
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  @override
  State<_GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<_GhostButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final border = widget.isDark
        ? AppColors.slate.withValues(alpha: 0.35)
        : AppColors.lightBorder;
    final fg = widget.isDark ? AppColors.lightestSlate : AppColors.lightText;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: _hovered
                ? (widget.isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : Colors.black.withValues(alpha: 0.03))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 16, color: fg.withValues(alpha: 0.85)),
              SizedBox(width: 8.w),
              Text(
                widget.label,
                style: AppFonts.arabic(
                  color: fg,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
