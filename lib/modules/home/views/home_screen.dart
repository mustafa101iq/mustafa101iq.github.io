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

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.voidBg : AppColors.lightBg,
      body: Stack(
        children: [
          Positioned.fill(
            child: NetworkBackground(isDark: isDark),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: isDark ? AppColors.red : AppColors.lightAccent,
                ),
              );
            }

            return Column(
              children: [
                const PortfolioNavbar(),
                Expanded(
                  child: SelectionArea(
                    child: SingleChildScrollView(
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
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
      floatingActionButton: const BackToTopButton(),
    );
  }
}
