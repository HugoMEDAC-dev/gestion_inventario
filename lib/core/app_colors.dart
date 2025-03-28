import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF21006D);
  static const Color secundary = Color(0xFF1F0345);
  static const Color accent = Color(0xD68742D6);

  //Background

  static const Color background = Color(0xFF646FFF);
  static const Color backgroundComponent = Color(0xFF6247DD);

  final ThemeData appTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
  );
}
