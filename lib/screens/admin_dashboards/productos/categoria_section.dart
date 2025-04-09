import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_colors.dart';
import 'producto_card.dart';

/// Widget que representa una sección completa de productos dentro de una categoría y sus subcategorías.
class CategoriaSection extends StatelessWidget {
  final String titulo;
  final String categoria;
  final List<String> subcolecciones;

  const CategoriaSection({
    super.key,
    required this.titulo,
    required this.categoria,
    required this.subcolecciones,
  });

  @override
  Widget build(BuildContext context) {
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
        // Muestra los productos de cada subcolección
        // de la colección "productos" del Cloud Firestore
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      decoration: BoxDecoration(
                        color: AppColors.adminAccent.withValues(),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        sub.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      bottom: 24,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 600;
                        return Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: isWide ? 800 : double.infinity,
                            ),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isWide ? 3 : 2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: isWide ? 3 / 4 : 2.5 / 3,
                                  ),
                              itemCount: productos.length,
                              itemBuilder: (context, index) {
                                final producto =
                                    productos[index].data()
                                        as Map<String, dynamic>;
                                return ProductoCard(producto: producto);
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
}
