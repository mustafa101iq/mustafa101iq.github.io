import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:portfolio_website/core/utils/url_helper.dart';
import 'package:portfolio_website/core/widgets/cached_asset_image.dart';
import 'package:portfolio_website/modules/home/models/portfolio_models.dart';
import 'package:portfolio_website/modules/home/models/project_model.dart';

enum PortfolioSection {
  home,
  about,
  skills,
  services,
  projects,
  experience,
  education,
  contact,
}

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final GlobalKey homeKey = GlobalKey();
  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey skillsKey = GlobalKey();
  final GlobalKey servicesKey = GlobalKey();
  final GlobalKey projectsKey = GlobalKey();
  final GlobalKey experienceKey = GlobalKey();
  final GlobalKey educationKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  final RxBool isLoading = true.obs;
  final RxBool showBackToTop = false.obs;
  final RxBool isNavScrolled = false.obs;
  final Rx<PortfolioSection> activeSection = PortfolioSection.home.obs;
  final Rxn<PortfolioData> portfolio = Rxn<PortfolioData>();
  final RxList<ProjectModel> projects = <ProjectModel>[].obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final GlobalKey<FormState> contactFormKey = GlobalKey<FormState>();
  final RxBool isSending = false.obs;

  Map<PortfolioSection, GlobalKey> get sectionKeys => {
    PortfolioSection.home: homeKey,
    PortfolioSection.about: aboutKey,
    PortfolioSection.skills: skillsKey,
    PortfolioSection.services: servicesKey,
    PortfolioSection.projects: projectsKey,
    PortfolioSection.experience: experienceKey,
    PortfolioSection.education: educationKey,
    PortfolioSection.contact: contactKey,
  };

  List<({PortfolioSection section, String labelKey})> get navItems => const [
        (section: PortfolioSection.home, labelKey: 'nav_home'),
        (section: PortfolioSection.about, labelKey: 'nav_about'),
        (section: PortfolioSection.skills, labelKey: 'nav_skills'),
        (section: PortfolioSection.services, labelKey: 'nav_services'),
        (section: PortfolioSection.projects, labelKey: 'nav_projects'),
        (section: PortfolioSection.experience, labelKey: 'nav_experience'),
        (section: PortfolioSection.contact, labelKey: 'nav_contact'),
      ];

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    loadData();
  }

  DateTime? _lastSectionCheck;

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        rootBundle.loadString('assets/data/portfolio.json'),
        rootBundle.loadString('assets/data/projects.json'),
      ]);
      portfolio.value = PortfolioData.fromJson(
        jsonDecode(results[0]) as Map<String, dynamic>,
      );
      projects.assignAll(
        (jsonDecode(results[1]) as List<dynamic>)
            .map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      debugPrint('Failed to load portfolio data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _onScroll() {
    final offset = scrollController.offset;
    final shouldShowTop = offset > 500;
    final shouldNavScroll = offset > 40;
    if (showBackToTop.value != shouldShowTop) {
      showBackToTop.value = shouldShowTop;
    }
    if (isNavScrolled.value != shouldNavScroll) {
      isNavScrolled.value = shouldNavScroll;
    }

    final now = DateTime.now();
    if (_lastSectionCheck != null &&
        now.difference(_lastSectionCheck!) < const Duration(milliseconds: 100)) {
      return;
    }
    _lastSectionCheck = now;
    _updateActiveSection();
  }

  void _updateActiveSection() {
    PortfolioSection current = PortfolioSection.home;
    for (final entry in sectionKeys.entries) {
      final context = entry.value.currentContext;
      if (context == null) continue;
      final box = context.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final position = box.localToGlobal(Offset.zero).dy;
      if (position <= 160) {
        current = entry.key;
      }
    }
    if (activeSection.value != current) {
      activeSection.value = current;
    }
  }

  Future<void> scrollToSection(PortfolioSection section) async {
    final key = sectionKeys[section];
    final context = key?.currentContext;
    if (context == null) return;
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
      alignment: 0.08,
    );
    activeSection.value = section;
  }

  Future<void> scrollToTop() async {
    await scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> downloadCv() async {
    final url = portfolio.value?.profile.cvUrl;
    if (url != null) await UrlHelper.open(url);
  }

  Future<void> submitContactForm() async {
    if (!(contactFormKey.currentState?.validate() ?? false)) return;
    isSending.value = true;
    final profile = portfolio.value?.profile;
    if (profile != null) {
      await UrlHelper.openEmail(
        email: profile.email,
        subject: 'contact_subject'.trParams({
          'name': nameController.text.trim(),
        }),
        body: 'contact_body'.trParams({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'message': messageController.text.trim(),
        }),
      );
    }
    nameController.clear();
    emailController.clear();
    messageController.clear();
    isSending.value = false;
    Get.snackbar(
      'message_ready'.tr,
      'message_ready_body'.tr,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  void showProjectDetails(ProjectModel project) {
    final images = project.previewImages;
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Material(
            color: Get.isDarkMode ? const Color(0xFF150807) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (images.isNotEmpty)
                  SizedBox(
                    height: project.isCoverVisual ? 360 : 220,
                    width: double.infinity,
                    child: ColoredBox(
                      color: Get.isDarkMode
                          ? const Color(0xFF120808)
                          : const Color(0xFFEDE4F5),
                      child: CachedAssetImage(
                        images.first,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        displayWidth: 480,
                        displayHeight: 360,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.title.text,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 220),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project.details.text,
                                style: TextStyle(
                                  height: 1.6,
                                  color: Get.isDarkMode
                                      ? const Color(0xFFB78E89)
                                      : const Color(0xFF7A5F5C),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: project.technologies
                                    .map((tech) => Chip(label: Text(tech.text)))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  child: Row(
                    children: [
                      TextButton(onPressed: Get.back, child: Text('close'.tr)),
                      const Spacer(),
                      if (project.liveDemoUrl.isNotEmpty)
                        FilledButton.icon(
                          onPressed: () => UrlHelper.open(project.liveDemoUrl),
                          icon: const Icon(Icons.play_arrow_rounded, size: 18),
                          label: Text('live_demo'.tr),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
