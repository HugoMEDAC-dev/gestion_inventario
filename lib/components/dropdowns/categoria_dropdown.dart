import 'package:flutter/material.dart';
import '../../utils/categorias.dart';
import '../../core/app_colors.dart';

class CategoriaDropdown extends StatelessWidget {
  final String? selectedCategoria;
  final Function(String) onChanged;

  const CategoriaDropdown({
    super.key,
    required this.selectedCategoria,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedCategoria,
      decoration: const InputDecoration(
        labelText: 'Categoría',
        labelStyle: TextStyle(color: AppColors.formLabelColor),
      ),
      items:
          subcategoriasPorCategoria.keys.map((categoria) {
            return DropdownMenuItem(
              value: categoria,
              child: Text(
                categoria[0].toUpperCase() +
                    categoria.substring(1), // Visual profesional
              ),
            );
          }).toList(),
      onChanged: (value) {
        if (value != null) onChanged(value); // Callback personalizado
      },
    );
  }
}
