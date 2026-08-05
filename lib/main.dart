import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:portfolio_website/app/bindings/app_binding.dart';
import 'package:portfolio_website/app/routes/app_pages.dart';
import 'package:portfolio_website/app/theme/app_theme.dart';
import 'package:portfolio_website/app/translations/app_translations.dart';
import 'package:portfolio_website/app/utils/responsive.dart';
import 'package:portfolio_website/core/services/font_bootstrap.dart';
import 'package:portfolio_website/core/services/localization_service.dart';
import 'package:portfolio_website/core/services/portfolio_bootstrap.dart';
import 'package:portfolio_website/core/services/theme_service.dart';
import 'package:portfolio_website/core/services/visit_counter_service.dart';
import 'package:visibility_detector/visibility_detector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  VisibilityDetectorController.instance.updateInterval =
      const Duration(milliseconds: 120);
  await GetStorage.init();
  await Future.wait([
    PortfolioBootstrap.load(),
    FontBootstrap.load(),
  ]);
  final themeService = await ThemeService().init();
  final localizationService = await LocalizationService().init();
  Get.put<ThemeService>(themeService, permanent: true);
  Get.put<LocalizationService>(localizationService, permanent: true);
  Get.put<VisitCounterService>(VisitCounterService(), permanent: true);
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<LocalizationService>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth > 0 ? constraints.maxWidth : 375.0;
        final height = constraints.maxHeight > 0
            ? constraints.maxHeight
            : 812.0;
        final size = Size(width, height);
        return ScreenUtilInit(
          designSize: designSizeForDevice(size),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return Obx(() {
              final locale = localization.locale.value;
              return GetMaterialApp(
                title: 'Mustafa Q. Yassin | Flutter Developer',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: Get.find<ThemeService>().themeMode,
                translations: AppTranslations(),
                locale: locale,
                fallbackLocale: LocalizationService.arabic,
                initialBinding: AppBinding(),
                initialRoute: AppPages.initial,
                getPages: AppPages.routes,
                builder: (context, widget) {
                  final scale = MediaQuery.of(
                    context,
                  ).textScaler.scale(1).clamp(0.85, 1.2).toDouble();
                  return Directionality(
                    textDirection: localization.textDirection,
                    child: MediaQuery(
                      data: MediaQuery.of(
                        context,
                      ).copyWith(textScaler: TextScaler.linear(scale)),
                      child: widget ?? const SizedBox.shrink(),
                    ),
                  );
                },
              );
            });
          },
        );
      },
    );
  }
}
