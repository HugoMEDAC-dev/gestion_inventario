import 'package:flutter/material.dart';
import '../../utils/categorias.dart';
import '../../core/app_colors.dart';

class SubcategoriaDropdown extends StatelessWidget {
  final String? selectedCategoria;
  final String? selectedSubcategoria;
  final Function(String?) onChanged;

  const SubcategoriaDropdown({
    super.key,
    required this.selectedCategoria,
    required this.selectedSubcategoria,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final subcategorias =
        selectedCategoria != null
            ? subcategoriasPorCategoria[selectedCategoria] ?? []
            : [];

    return DropdownButtonFormField<String>(
      value:
          subcategorias.contains(selectedSubcategoria)
              ? selectedSubcategoria
              : null,
      decoration: const InputDecoration(
        labelText: 'Subcategoría',
        labelStyle: TextStyle(color: AppColors.formLabelColor),
      ),
      items:
          subcategorias
              .map(
                (sub) => DropdownMenuItem<String>(
                  value: sub,
                  child: Text(sub[0].toUpperCase() + sub.substring(1)),
                ),
              )
              .toList(),
      onChanged: onChanged,
      validator:
          (value) =>
              value == null || value.isEmpty
                  ? 'Selecciona una subcategoría'
                  : null,
    );
  }
}
