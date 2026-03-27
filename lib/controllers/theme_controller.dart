import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  late RxBool isDarkMode;

  @override
  void onInit() {
    super.onInit();
    bool savedValue = _box.read(_key) ?? false;
    isDarkMode = RxBool(savedValue);
  }

  ThemeMode get themeMode => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
    isDarkMode.value = !isDarkMode.value;
    _box.write(_key, isDarkMode.value);
    Get.changeThemeMode(themeMode);
  }
}
