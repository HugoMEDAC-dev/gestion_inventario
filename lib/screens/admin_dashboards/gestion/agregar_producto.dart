import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/buttons/boton_formulario.dart';
import 'package:flutter_application_1/components/dropdowns/categoria_dropdown.dart';
import 'package:flutter_application_1/components/dropdowns/subcategoria_dropdown.dart';
import 'package:flutter_application_1/components/wrappers/pantalla_formulario_wrapper.dart';
import 'package:flutter_application_1/utils/categorias.dart';
import 'package:flutter_application_1/utils/firestore_helpers.dart';
import '../../../core/app_colors.dart'; // Importamos la paleta de colores personalizada

class AgregarProductoScreen extends StatefulWidget {
  const AgregarProductoScreen({super.key});

  @override
  State<AgregarProductoScreen> createState() => _AgregarProductoScreenState();
}

class _AgregarProductoScreenState extends State<AgregarProductoScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para campos del formulario
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  String? _categoriaSeleccionada;
  String? _subcategoriaSeleccionada;

  /// Función que guarda el producto en la base de datos
  Future<void> _guardarProducto() async {
    if (_formKey.currentState!.validate()) {
      if (_categoriaSeleccionada == null || _subcategoriaSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ Debes seleccionar una categoría y subcategoría.'),
          ),
        );
        return;
      }

      try {
        final nuevoID = await guardarProductoConID(
          categoria: _categoriaSeleccionada!,
          subcategoria: _subcategoriaSeleccionada!,
          data: {
            'nombre': _nombreController.text.trim(),
            'marca': _marcaController.text.trim(),
            'precio': double.parse(_precioController.text.trim()),
            'stock': int.parse(_stockController.text.trim()),
          },
        );

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Producto agregado con ID "$nuevoID"')),
        );

        _nombreController.clear();
        _marcaController.clear();
        _precioController.clear();
        _stockController.clear();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Error al guardar: $e')));
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _marcaController.dispose();
    _precioController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PantallaFormularioWrapper(
      child: Form(
        key: _formKey, // Formulario principal
        child: ListView(
          children: [
            const Text(
              'Rellena los datos del nuevo producto',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Dropdown de categoría
            CategoriaDropdown(
              selectedCategoria: _categoriaSeleccionada,
              onChanged: (value) {
                setState(() {
                  _categoriaSeleccionada = value;
                  _subcategoriaSeleccionada =
                      subcategoriasPorCategoria[value]!.first;
                });
              },
            ),

            const SizedBox(height: 12),

            // Dropdown de subcategoría
            SubcategoriaDropdown(
              selectedCategoria: _categoriaSeleccionada,
              selectedSubcategoria: _subcategoriaSeleccionada,
              onChanged: (value) {
                setState(() {
                  _subcategoriaSeleccionada = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // Campos de texto
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                labelStyle: TextStyle(color: AppColors.formLabelColor),
              ),
              validator:
                  (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio' : null,
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: _marcaController,
              decoration: const InputDecoration(
                labelText: 'Marca',
                labelStyle: TextStyle(color: AppColors.formLabelColor),
              ),
              validator:
                  (value) =>
                      value!.isEmpty ? 'Este campo es obligatorio' : null,
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: _precioController,
              decoration: const InputDecoration(
                labelText: 'Precio (€)',
                labelStyle: TextStyle(color: AppColors.formLabelColor),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) return 'Este campo es obligatorio';
                final parsed = double.tryParse(value);
                return (parsed == null || parsed < 0)
                    ? 'Introduce un precio válido'
                    : null;
              },
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: _stockController,
              decoration: const InputDecoration(
                labelText: 'Stock',
                labelStyle: TextStyle(color: AppColors.formLabelColor),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) return 'Este campo es obligatorio';
                final parsed = int.tryParse(value);
                return (parsed == null || parsed < 0)
                    ? 'Introduce una cantidad válida'
                    : null;
              },
            ),

            const SizedBox(height: 30),

            // Botón de guardar
            BotonFormulario(
              texto: 'Guardar producto',
              icono: Icons.save,
              onPressed: _guardarProducto,
              colorFondo: AppColors.buttonGradient1,
              colorTexto: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
