import 'package:flutter/material.dart';

/// Función reutilizable para validar selección de categoría y subcategoría
bool validarSeleccionCategoriaYSubcategoria(
  BuildContext context,
  String? categoria,
  String? subcategoria, {
  String mensaje = '⚠️ Debes seleccionar una categoría y subcategoría.',
}) {
  if (categoria == null || subcategoria == null) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
    return false;
  }
  return true;
}
