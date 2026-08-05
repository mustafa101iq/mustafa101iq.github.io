import 'package:flutter/material.dart';

abstract final class AppFonts {
  static const tajawal = 'Tajawal';

  static TextStyle arabic({
    TextStyle? textStyle,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    List<Shadow>? shadows,
  }) {
    return (textStyle ?? const TextStyle()).copyWith(
      fontFamily: tajawal,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      shadows: shadows,
    );
  }

  static TextTheme arabicTextTheme([TextTheme? base]) {
    final theme = base ?? ThemeData.light().textTheme;
    return theme.apply(fontFamily: tajawal);
  }
}
