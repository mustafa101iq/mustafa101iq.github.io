import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBreakpoints {
  AppBreakpoints._();

  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1280;
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  bool get isMobileLayout => screenWidth < AppBreakpoints.mobile;
  bool get isTabletLayout =>
      screenWidth >= AppBreakpoints.mobile &&
      screenWidth < AppBreakpoints.tablet;
  bool get isDesktopLayout => screenWidth >= AppBreakpoints.tablet;

  double get contentMaxWidth {
    if (isDesktopLayout) return 760;
    if (isTabletLayout) return 700;
    return screenWidth;
  }

  double get horizontalPadding {
    if (isDesktopLayout) return 28.w;
    if (isTabletLayout) return 28.w;
    return 28.w;
  }
}

Size designSizeForDevice(Size size) {
  if (size.width >= AppBreakpoints.tablet) {
    return const Size(1440, 900);
  }
  if (size.width >= AppBreakpoints.mobile) {
    return const Size(768, 1024);
  }
  return const Size(375, 812);
}
