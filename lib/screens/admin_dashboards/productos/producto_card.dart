import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_colors.dart';

/// Tarjeta compacta y legible que muestra la información principal de un producto.
class ProductoCard extends StatelessWidget {
  final Map<String, dynamic> producto;

  const ProductoCard({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
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
            // Ajusta automáticamente la altura al contenido
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: isWide ? 180 : 150,
                maxWidth: isWide ? 260 : 180,
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
}
