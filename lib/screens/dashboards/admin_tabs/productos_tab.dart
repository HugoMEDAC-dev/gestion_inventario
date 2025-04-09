import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_colors.dart';

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

  /// Construye una sección visual por categoría con sus subcolecciones reales desde Firestore.
  /// Cada subcolección representa un tipo de producto (ej: CPU, Laptop...).
  Widget _buildCategoriaSection(
    String titulo,
    String categoria,
    List<String> subcolecciones,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            titulo,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Muestra productos por cada subcolección específica del Firebase
        ...subcolecciones.map((sub) {
          return StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('productos')
                    .doc(categoria)
                    .collection(sub)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No hay productos en esta subcategoría.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final productos = snapshot.data!.docs;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child:
                    /// 🔠 Encabezado visual de subcategoría con estilo admin
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      decoration: BoxDecoration(
                        color: AppColors.adminAccent.withOpacity(
                          0.9,
                        ), // 🎨 Color destacado admin
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        sub.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // ✅ Contraste para legibilidad
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      bottom: 24,
                    ), // 📌 Espaciado lateral + separación inferior
                    child:
                    /// 📦 Lista de productos en formato responsive (se adapta al ancho de pantalla)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide =
                            constraints.maxWidth >
                            600; // 📱 Detección de pantalla ancha
                        return
                        // ✅ Usamos LayoutBuilder para adaptar la distribución al tamaño de pantalla
                        Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              // 📐 Limita el ancho en pantallas anchas, usa ancho completo en móviles
                              maxWidth: isWide ? 800 : double.infinity,
                            ),
                            child: GridView.builder(
                              shrinkWrap:
                                  true, // 🔄 Permite que el GridView se ajuste al contenido
                              physics:
                                  const NeverScrollableScrollPhysics(), // ❌ No hace scroll independiente
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    isWide
                                        ? 3
                                        : 2, // 📱 Responsive: 2 columnas en móvil, 3 en web
                                crossAxisSpacing:
                                    16, // ↔️ Separación horizontal entre tarjetas
                                mainAxisSpacing:
                                    16, // ↕️ Separación vertical entre tarjetas
                                childAspectRatio: // las tarjetas se vean más rectangulares en pantallas anchas (web) y más cuadradas/adaptadas en móviles.
                                    isWide ? 3 / 4 : 2.5 / 3,
                              ),
                              itemCount: productos.length,
                              itemBuilder: (context, index) {
                                final producto =
                                    productos[index].data()
                                        as Map<String, dynamic>;
                                return _buildProductoCard(
                                  producto,
                                ); // 🧩 Reutiliza la card uniforme
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        }),
      ],
    );
  }

  /// Tarjeta compacta y legible que muestra la información principal de un producto.
  /// 🟦 Card cuadrada y adaptativa para móviles y web
  Widget _buildProductoCard(Map<String, dynamic> producto) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;

        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.textColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: IntrinsicHeight(
            // 🔁 Ajusta automáticamente la altura al contenido
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth:
                    isWide ? 180 : 150, // 📐 Ancho mínimo por tipo de pantalla
                maxWidth:
                    isWide ? 260 : 180, // 📐 Ancho máximo por tipo de pantalla
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2,
                    size: 44,
                    color: AppColors.adminAccent,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    producto['nombre'] ?? 'Sin nombre',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Marca: ${producto['marca'] ?? '-'}',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Precio: ${producto['precio']?.toStringAsFixed(2) ?? '-'}€',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Stock: ${producto['stock'] ?? 0}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 🔽 Crea el botón desplegable de subcategorías dentro de una categoría
  /// 🔽 Menú desplegable que permite al admin seleccionar una subcategoría específica
  /// dentro de una categoría para filtrar productos en tiempo real desde Firestore.
  Widget _buildMenuCategory(
    String title,
    String categoria,
    List<String> subcategorias,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white, // 🎨 Fondo blanco para destacar el menú
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26, // 💫 Sombra para efecto elevado
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value:
            _selectedCategory == categoria &&
                    subcategorias.contains(_selectedSubcategory)
                ? _selectedSubcategory
                : subcategorias.first,
        dropdownColor: Colors.white,
        style: const TextStyle(color: Colors.black),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: AppColors.primary,
        ), // 🎨 Icono personalizado
        underline: const SizedBox(), // ❌ Quitamos la línea inferior del menú
        onChanged: (value) {
          setState(() {
            _selectedCategory = categoria;
            _selectedSubcategory = value!;
          });
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

  /// ✅ Muestra una sola subcategoría reutilizando el layout general
  /// 🎯 Se mantiene coherencia visual con la vista general
  Widget _buildSingleSection() {
    return _buildCategoriaSection(
      '${_selectedCategory.toUpperCase()} - ${_selectedSubcategory.toUpperCase()}', // 🔠 Título combinado
      _selectedCategory,
      [_selectedSubcategory], // 📦 Lista con una sola subcategoría
    );
  }

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
                          _buildMenuCategory('Componentes', 'componentes', [
                            'cpu',
                            'disco_duro',
                          ]),
                          _buildMenuCategory('Ordenadores', 'ordenadores', [
                            'laptop',
                            'pc_desktop',
                          ]),
                          _buildMenuCategory('Periféricos', 'perifericos', [
                            'raton',
                            'teclado',
                          ]),
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
                          child: _buildCategoriaSection(
                            'Componentes',
                            'componentes',
                            ['cpu', 'disco_duro'],
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ), // 🧩 Espaciado entre columnas
                        // 🧱 Columna de Ordenadores
                        Expanded(
                          child: _buildCategoriaSection(
                            'Ordenadores',
                            'ordenadores',
                            ['laptop', 'pc_desktop'],
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ), // 🧩 Espaciado entre columnas
                        // 🧱 Columna de Periféricos
                        Expanded(
                          child: _buildCategoriaSection(
                            'Periféricos',
                            'perifericos',
                            ['raton', 'teclado'],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : _buildSingleSection(), // 👈 Vista filtrada con animación

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
