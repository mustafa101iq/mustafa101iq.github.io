import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxService {
  static const String _key = 'isDarkMode';
  final GetStorage _storage = GetStorage();
  final RxBool isDarkMode = true.obs;

  Future<ThemeService> init() async {
    isDarkMode.value = _storage.read<bool>(_key) ?? true;
    return this;
  }

  ThemeMode get themeMode =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _storage.write(_key, isDarkMode.value);
    Get.changeThemeMode(themeMode);
  }
}
