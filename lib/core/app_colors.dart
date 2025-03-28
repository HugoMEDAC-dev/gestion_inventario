import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF21006D);
  static const Color secundary = Color(0xFF1F0345);
  static const Color accent = Color(0xD68742D6);
  static const Color textColor = Color(0xFFFFFFFF);

  //Background

  static const Color background = Color(0xFF9299FF);
  static const Color backgroundApp1 = Color(0xFF120D42);
  static const Color backgroundApp2 = Color(0xFF231F31);
  static const Color backgroundComponent = Color(0xFF92DFA3);
  static const Color buttonGradient1 = Color(0xFF004FF8);
  static const Color buttonGradient2 = Color(0xFF090081);

  final ThemeData appTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
  );
}
