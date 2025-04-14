import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_colors.dart';

/// Botón profesional reutilizable con icono, texto, color personalizado y comportamiento dinámico.
class BotonFormulario extends StatelessWidget {
  final String texto;
  final IconData icono;
  final VoidCallback onPressed;
  final Color colorFondo;
  final Color colorTexto;

  const BotonFormulario({
    super.key,
    required this.texto,
    required this.icono,
    required this.onPressed,
    required this.colorFondo,
    this.colorTexto = AppColors.textColor
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        icon: Icon(icono, color: colorTexto),
        label: Text(
          texto,
          style: TextStyle(
            fontSize: 18,
            color: colorTexto,
          ),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorFondo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}
