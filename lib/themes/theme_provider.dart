import 'package:chat_app/themes/dark_mode.dart';
import 'package:chat_app/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeProvider {
  ThemeData _themeData = lightMode;

  // ThemeData get themeData => _themeData;

  // bool get isDarkMode => _themeData == darkMode;

  // set themeData(ThemeData themeData) {
  //   _themeData = themeData;
  // }

  void toggleTheme() {
    // var theme = ThemeData.light();
    if (!Get.isDarkMode) {
      _themeData = darkMode;
      // theme = ThemeData.dark();
    } else {
      _themeData = lightMode;
      // theme = ThemeData.light();
    }

    Get.changeTheme(_themeData);
  }
}
