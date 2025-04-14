import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/buttons/boton_formulario.dart';
import 'package:flutter_application_1/components/dropdowns/categoria_dropdown.dart';
import 'package:flutter_application_1/components/dropdowns/subcategoria_dropdown.dart';
import 'package:flutter_application_1/components/wrappers/pantalla_formulario_wrapper.dart';
import 'package:flutter_application_1/utils/categorias.dart';
import 'package:flutter_application_1/utils/firestore_helpers.dart';
import 'package:flutter_application_1/utils/validators.dart';
import '../../../core/app_colors.dart';

class EliminarProductoScreen extends StatefulWidget {
  const EliminarProductoScreen({super.key});

  @override
  State<EliminarProductoScreen> createState() => _EliminarProductoScreenState();
}

class _EliminarProductoScreenState extends State<EliminarProductoScreen> {
  String? _categoriaSeleccionada;
  String? _subcategoriaSeleccionada;

  List<DocumentSnapshot> _productos = [];
  DocumentSnapshot? _productoSeleccionado;

  /// Carga todos los productos desde Firestore según la categoría
  Future<void> _cargarProductos() async {
    if (!validarSeleccionCategoriaYSubcategoria(
      context,
      _categoriaSeleccionada,
      _subcategoriaSeleccionada,
    ))
      return;

    try {
      final productos = await cargarProductos(
        _categoriaSeleccionada!,
        _subcategoriaSeleccionada!,
      );

      setState(() {
        _productos = productos;
        _productoSeleccionado = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error al cargar productos: $e')),
      );
    }
  }

  /// Elimina el producto seleccionado con confirmación previa
  Future<void> _eliminarProducto() async {
    if (_productoSeleccionado == null) return;

    final confirmacion = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('¿Eliminar producto?'),
            content: Text(
              '¿Estás seguro de que deseas eliminar "${_productoSeleccionado!['nombre']}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmacion == true) {
      try {
        await eliminarProducto(_productoSeleccionado!);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Producto eliminado correctamente')),
        );

        await _cargarProductos();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Error al eliminar: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PantallaFormularioWrapper(
      child: ListView(
        children: [
          const Text(
            'Selecciona un producto para eliminar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          CategoriaDropdown(
            selectedCategoria: _categoriaSeleccionada,
            onChanged: (value) {
              setState(() {
                _categoriaSeleccionada = value;
                _subcategoriaSeleccionada =
                    subcategoriasPorCategoria[value]!.first;
                _productos.clear();
              });
            },
          ),

          const SizedBox(height: 12),

          SubcategoriaDropdown(
            selectedCategoria: _categoriaSeleccionada,
            selectedSubcategoria: _subcategoriaSeleccionada,
            onChanged: (value) {
              setState(() {
                _subcategoriaSeleccionada = value;
                _productos.clear();
              });
            },
          ),

          const SizedBox(height: 16),

          BotonFormulario(
            texto: 'Cargar productos',
            icono: Icons.search,
            onPressed: _cargarProductos,
            colorFondo: AppColors.buttonGradient1,
          ),

          const SizedBox(height: 20),

          if (_productos.isNotEmpty)
            DropdownButtonFormField<DocumentSnapshot>(
              value: _productoSeleccionado,
              decoration: const InputDecoration(
                labelText: 'Producto a eliminar',
                labelStyle: TextStyle(color: AppColors.formLabelColor),
              ),
              items:
                  _productos
                      .map(
                        (doc) => DropdownMenuItem(
                          value: doc,
                          child: Text(doc['nombre']),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _productoSeleccionado = value!;
                });
              },
            ),

          const SizedBox(height: 30),

          if (_productoSeleccionado != null)
            BotonFormulario(
              texto: 'Eliminar producto',
              icono: Icons.delete_forever,
              onPressed: _eliminarProducto,
              colorFondo: Colors.red,
            ),
        ],
      ),
    );
  }
}
