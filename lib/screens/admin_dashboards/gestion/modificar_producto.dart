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

class ModificarProductoScreen extends StatefulWidget {
  const ModificarProductoScreen({super.key});

  @override
  State<ModificarProductoScreen> createState() =>
      _ModificarProductoScreenState();
}

class _ModificarProductoScreenState extends State<ModificarProductoScreen> {
  final _nombreController = TextEditingController();
  final _marcaController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();

  String? _categoriaSeleccionada;
  String? _subcategoriaSeleccionada;

  List<DocumentSnapshot> _productos = [];
  DocumentSnapshot? _productoSeleccionado;

  /// Cargar productos desde la subcategoría seleccionada
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

  /// Rellenar el formulario al seleccionar un producto
  void _cargarFormulario(DocumentSnapshot doc) {
    setState(() {
      _productoSeleccionado = doc;
      _nombreController.text = doc['nombre'];
      _marcaController.text = doc['marca'];
      _precioController.text = doc['precio'].toString();
      _stockController.text = doc['stock'].toString();
    });
  }

  /// Guardar los cambios del producto
  Future<void> _guardarCambios() async {
    if (_productoSeleccionado == null) return;

    try {
      await actualizarProducto(_productoSeleccionado!, {
        'nombre': _nombreController.text.trim(),
        'marca': _marcaController.text.trim(),
        'precio': double.parse(_precioController.text.trim()),
        'stock': int.parse(_stockController.text.trim()),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Producto modificado correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error al guardar cambios: $e')));
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
      child: ListView(
        children: [
          const Text(
            'Selecciona y edita un producto',
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
                labelText: 'Selecciona producto',
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
                if (value != null) _cargarFormulario(value);
              },
            ),

          const SizedBox(height: 20),

          if (_productoSeleccionado != null) ...[
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                labelStyle: TextStyle(color: AppColors.formLabelColor),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _marcaController,
              decoration: const InputDecoration(
                labelText: 'Marca',
                labelStyle: TextStyle(color: AppColors.formLabelColor),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _precioController,
              decoration: const InputDecoration(
                labelText: 'Precio',
                labelStyle: TextStyle(color: AppColors.formLabelColor),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _stockController,
              decoration: const InputDecoration(
                labelText: 'Stock',
                labelStyle: TextStyle(color: AppColors.formLabelColor),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            BotonFormulario(
              texto: 'Guardar cambios',
              icono: Icons.save,
              onPressed: _guardarCambios,
              colorFondo: Colors.orangeAccent,
              colorTexto: AppColors.textColor,
            ),
          ],
        ],
      ),
    );
  }
}
