import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio_website/app/theme/app_colors.dart';
import 'package:portfolio_website/core/widgets/network_background.dart';
import 'package:portfolio_website/modules/home/controllers/home_controller.dart';
import 'package:portfolio_website/modules/home/widgets/about_section.dart';
import 'package:portfolio_website/modules/home/widgets/back_to_top_button.dart';
import 'package:portfolio_website/modules/home/widgets/contact_section.dart';
import 'package:portfolio_website/modules/home/widgets/education_section.dart';
import 'package:portfolio_website/modules/home/widgets/experience_section.dart';
import 'package:portfolio_website/modules/home/widgets/footer_section.dart';
import 'package:portfolio_website/modules/home/widgets/hero_section.dart';
import 'package:portfolio_website/modules/home/widgets/portfolio_navbar.dart';
import 'package:portfolio_website/modules/home/widgets/projects_section.dart';
import 'package:portfolio_website/modules/home/widgets/services_section.dart';
import 'package:portfolio_website/modules/home/widgets/skills_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showBackground = false;
  bool _contentReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _contentReady = true);
      Future<void>.delayed(const Duration(milliseconds: 180), () {
        if (mounted) setState(() => _showBackground = true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.voidBg : AppColors.lightBg;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          if (_showBackground)
            Positioned.fill(
              child: IgnorePointer(
                child: NetworkBackground(isDark: isDark),
              ),
            ),
          AnimatedOpacity(
            opacity: _contentReady ? 1 : 0,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOut,
            child: const Column(
              children: [
                PortfolioNavbar(),
                Expanded(
                  child: SelectionArea(
                    child: _HomeScrollBody(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: const BackToTopButton(),
    );
  }
}

class _HomeScrollBody extends GetView<HomeController> {
  const _HomeScrollBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller.scrollController,
      physics: const BouncingScrollPhysics(),
      child: const Column(
        children: [
          HeroSection(),
          AboutSection(),
          SkillsSection(),
          ServicesSection(),
          ProjectsSection(),
          ExperienceSection(),
          EducationSection(),
          ContactSection(),
          FooterSection(),
        ],
      ),
    );
  }
}
