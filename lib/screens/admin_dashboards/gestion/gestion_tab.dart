import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import 'agregar_producto.dart';
import 'modificar_producto.dart';
import 'eliminar_producto.dart';

class GestionTab extends StatelessWidget {
  const GestionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Se ha cambiado el fondo simple por un fondo degradado profesional
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.adminMenuBackground, // Azul superior oscuro
              AppColors.screenGradientBottom, // Azul inferior claro
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 40,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Encabezado
                      const Text(
                        'Acciones disponibles',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),

                      // Botón: Agregar Producto
                      _buildGestionButton(
                        context,
                        icon: Icons.add_box,
                        label: 'Agregar Producto',
                        color: Colors.green,
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                milliseconds: 400, // Duración de la animación
                              ),
                              pageBuilder:
                                  (_, __, ___) =>
                                      const AgregarProductoScreen(), //Pantalla de destino
                              transitionsBuilder: (_, animation, __, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(
                                      1.0,
                                      0.0,
                                    ), // Inicio de la animación: derecha de la pantalla
                                    end:
                                        Offset
                                            .zero, // Fin de la animación: posición normal
                                  ).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve:
                                          Curves
                                              .easeInOut, // Suaviza la transición
                                    ),
                                  ),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Botón: Modificar Producto
                      _buildGestionButton(
                        context,
                        icon: Icons.edit,
                        label: 'Modificar Producto',
                        color: Colors.orangeAccent,
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                milliseconds: 400,
                              ),
                              pageBuilder:
                                  (_, __, ___) =>
                                      const ModificarProductoScreen(),
                              transitionsBuilder: (_, animation, __, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(1.0, 0.0),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOut,
                                    ),
                                  ),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Botón: Eliminar Producto
                      _buildGestionButton(
                        context,
                        icon: Icons.delete_forever,
                        label: 'Eliminar Producto',
                        color: Colors.red,
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                milliseconds: 400,
                              ),
                              pageBuilder:
                                  (_, __, ___) =>
                                      const EliminarProductoScreen(),
                              transitionsBuilder: (_, animation, __, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(
                                      1.0,
                                      0.0,
                                    ),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOut,
                                    ),
                                  ),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Widget reutilizable para los botones de la gestión
  Widget _buildGestionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 26, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
