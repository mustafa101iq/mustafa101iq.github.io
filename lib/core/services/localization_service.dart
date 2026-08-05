import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalizationService extends GetxService {
  static const String _key = 'localeCode';
  static const Locale english = Locale('en', 'US');
  static const Locale arabic = Locale('ar', 'SA');

  final GetStorage _storage = GetStorage();
  final Rx<Locale> locale = english.obs;

  Future<LocalizationService> init() async {
    final saved = _storage.read<String>(_key);
    locale.value = saved == 'ar' ? arabic : english;
    return this;
  }

  bool get isArabic => locale.value.languageCode == 'ar';

  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  Future<void> toggleLocale() async {
    await changeLocale(isArabic ? english : arabic);
  }

  Future<void> changeLocale(Locale value) async {
    locale.value = value;
    _storage.write(_key, value.languageCode);
    Get.locale = value;
    await Get.updateLocale(value);
  }
}
