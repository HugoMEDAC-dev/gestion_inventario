import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF21006D);
  static const Color secundary = Color(0xFF1F0345);
  static const Color accent = Color(0xD68742D6);
  static const Color textColor = Color(0xFFFFFFFF);

  // Background
  static const Color background = Color(0xFF9299FF);
  static const Color backgroundApp1 = Color(0xFF120D42);
  static const Color backgroundApp2 = Color(0xFF231F31);
  static const Color backgroundComponent = Color(0xFF92DFA3);
  static const Color buttonGradient1 = Color(0xFF004FF8);
  static const Color buttonGradient2 = Color(0xFF090081);

  // Color para AppBar (azul moderno)
  static const Color appBarColor = Color(0xFF448AFF);

  // Fondo de pantallas (login, register, home)
  static const Color screenGradientTop = Color(
    0xFF64B5F6,
  ); // Azul claro superior
  static const Color screenGradientBottom = Color(
    0xFF1565C0,
  ); // Azul profundo inferior

  /*
    El screenGradientBottom puedes ajustarlo si quieres que se vea más oscuro o más suave.
    Puedes experimentar con tonos como 0xFF1565C0 o 0xFF0D47A1 si lo quieres más profundo.
  */

  // Paleta opcional para pestañas del panel administrador
  static const Color adminMenuBackground = Color(0xFF2A3B8F); // Azul oscuro
  static const Color adminAccent = Color(
    0xFFB3E5FC,
  ); // Azul claro para iconos o highlights

  // 🎨 Colores opcionales adicionales para sección de administración
  static const Color adminCard = Color(0xFFF0F4FF); // Fondo suave para tarjetas
  static const Color adminHeader = Color(0xFF1B2E73); // Fondo para encabezados
  static const Color adminDivider = Color(
    0xFFB0BEC5,
  ); // Líneas separadoras suaves

  final ThemeData appTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
  );
}
