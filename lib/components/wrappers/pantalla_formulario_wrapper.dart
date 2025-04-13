import 'package:flutter/material.dart';
import '../../../core/app_colors.dart'; // 🎨 Paleta personalizada

/// Envoltura visual reutilizable para pantallas con fondo degradado + tarjeta centrada.
class PantallaFormularioWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const PantallaFormularioWrapper({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20), // Espaciado por defecto
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo degradado
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.adminMenuBackground,
              AppColors.screenGradientBottom,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.white,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: padding,
                child:
                    child, // Contenido que viene desde agregar/modificar/eliminar
              ),
            ),
          ),
        ),
      ),
    );
  }
}
