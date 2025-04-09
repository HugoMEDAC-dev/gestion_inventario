import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_colors.dart';

/// Menú desplegable que permite al admin seleccionar una subcategoría específica
/// dentro de una categoría para filtrar productos en tiempo real desde Firestore.
class MenuCategoria extends StatelessWidget {
  final String title;
  final String categoria;
  final List<String> subcategorias;
  final String selectedCategory;
  final String selectedSubcategory;
  final Function(String categoria, String subcategoria) onChanged;

  const MenuCategoria({
    super.key,
    required this.title,
    required this.categoria,
    required this.subcategorias,
    required this.selectedCategory,
    required this.selectedSubcategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco para destacar el menú
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26, // Sombra para efecto elevado
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value:
            selectedCategory == categoria &&
                    subcategorias.contains(selectedSubcategory)
                ? selectedSubcategory
                : subcategorias.first,
        dropdownColor: Colors.white,
        style: const TextStyle(color: Colors.black),
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
        underline: const SizedBox(), // Quitamos la línea inferior del menú
        onChanged: (value) {
          if (value != null) {
            onChanged(categoria, value);
          }
        },
        items:
            subcategorias.map((sub) {
              return DropdownMenuItem(
                value: sub,
                child: Text('${title.split(' ')[0]} - ${sub.toUpperCase()}'),
              );
            }).toList(),
      ),
    );
  }
}
