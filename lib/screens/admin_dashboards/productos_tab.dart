import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_colors.dart';
import 'package:flutter_application_1/screens/admin_dashboards/productos/categoria_section.dart';
import 'package:flutter_application_1/screens/admin_dashboards/productos/menu_categoria.dart';

/// Widget que muestra todos los productos organizados por categorías.
/// Cada categoría (componentes, ordenadores, periféricos) tiene su propia sección.
class ProductosTab extends StatefulWidget {
  const ProductosTab({super.key});

  @override
  State<ProductosTab> createState() => _ProductosTabState();
}

class _ProductosTabState extends State<ProductosTab> {
  // 🧠 _verTodos controla si se muestra todo o solo una subcategoría.
  // Si es true → se muestran todas las categorías y subcategorías.
  // Si es false → solo la subcategoría seleccionada con animación.
  bool _verTodos = true;

  // ✅ Subcategoría seleccionada actualmente
  String _selectedSubcategory = 'cpu'; // Valor inicial por defecto

  // ✅ Categoría seleccionada actualmente (doc principal)
  String _selectedCategory = 'componentes'; // Valor inicial por defecto

  @override
  Widget build(BuildContext context) {
    // Contenedor principal scrollable
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors
                .adminMenuBackground, // Color personalizado admin (fondo superior)
            AppColors
                .screenGradientBottom, // Se mantiene el degradado inferior azul
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // 🔄 Botón para mostrar todos o una subcategoría
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.adminAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _verTodos = !_verTodos;
                      });
                    },
                    icon: Icon(_verTodos ? Icons.filter_alt : Icons.list),
                    label: Text(
                      _verTodos ? 'Filtrar por subcategoría' : 'Ver todos',
                    ),
                  ),
                  const SizedBox(height: 10),
                  // 🧭 Menú interactivo de categorías y subcategorías
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _verTodos ? 0 : 1,
                    child: IgnorePointer(
                      ignoring: _verTodos,
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [
                          MenuCategoria(
                            title: 'Componentes',
                            categoria: 'componentes',
                            subcategorias: ['cpu', 'disco_duro'],
                            selectedCategory: _selectedCategory,
                            selectedSubcategory: _selectedSubcategory,
                            onChanged: (categoria, subcategoria) {
                              setState(() {
                                _selectedCategory = categoria;
                                _selectedSubcategory = subcategoria;
                              });
                            },
                          ),
                          MenuCategoria(
                            title: 'Ordenadores',
                            categoria: 'ordenadores',
                            subcategorias: ['pc_desktop', 'laptop'],
                            selectedCategory: _selectedCategory,
                            selectedSubcategory: _selectedSubcategory,
                            onChanged: (categoria, subcategoria) {
                              setState(() {
                                _selectedCategory = categoria;
                                _selectedSubcategory = subcategoria;
                              });
                            },
                          ),
                          MenuCategoria(
                            title: 'Perifericos',
                            categoria: 'perifericos',
                            subcategorias: ['raton', 'teclado'],
                            selectedCategory: _selectedCategory,
                            selectedSubcategory: _selectedSubcategory,
                            onChanged: (categoria, subcategoria) {
                              setState(() {
                                _selectedCategory = categoria;
                                _selectedSubcategory = subcategoria;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            // ✅ Mostrar todos los productos o solo los filtrados, según el estado
            _verTodos
                ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Center(
                    // 🎯 Centrado horizontal de columnas con Center + mainAxisSize.min
                    child: Row(
                      // 🧱 Distribución horizontal de secciones para una vista profesional de 3 columnas
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize:
                          MainAxisSize.min, // ✅ Evita que se expanda a lo ancho
                      children: [
                        // 🧱 Columna de Componentes
                        Expanded(
                          child: CategoriaSection(
                            titulo: 'Componentes',
                            categoria: 'componentes',
                            subcolecciones: ['cpu', 'disco_duro'],
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ), // 🧩 Espaciado entre columnas
                        // 🧱 Columna de Ordenadores
                        Expanded(
                          child: CategoriaSection(
                            titulo: 'Ordenadores',
                            categoria: 'ordenadores',
                            subcolecciones: ['pc_desktop', 'laptop'],
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ), // 🧩 Espaciado entre columnas
                        // 🧱 Columna de Periféricos
                        Expanded(
                          child: CategoriaSection(
                            titulo: 'Perifericos',
                            categoria: 'perifericos',
                            subcolecciones: ['raton', 'teclado'],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : CategoriaSection(
                  // 👈 Vista filtrada con animación
                  titulo:
                      '${_selectedCategory.toUpperCase()} - ${_selectedSubcategory.toUpperCase()}',
                  categoria: _selectedCategory,
                  subcolecciones: [_selectedSubcategory],
                ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
