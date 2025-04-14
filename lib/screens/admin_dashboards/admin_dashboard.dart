import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_colors.dart';
import 'package:flutter_application_1/screens/admin_dashboards/gestion/gestion_tab.dart';
import 'package:flutter_application_1/screens/admin_dashboards/productos/productos_tab.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0; // Controla qué pestaña está activa
  bool _isDarkMode = false; // Alterna entre modo claro y oscuro

  // 🧩 Lista de pestañas del panel admin: cada una cargada desde archivos modulares
  static final List<Widget> _pages = <Widget>[
    const ProductosTab(), // Pestaña de Productos
    const GestionTab(), // Pestaña de Gestión
    _buildPage(
      Icons.report_problem,
      "Incidencias",
    ), // (Pendiente de implementación)
  ];

  // Construye el contenido visual de cada pestaña con icono y texto
  static Widget _buildPage(IconData icon, String label) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            label,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Controlador de navegación por pestañas
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Alterna el modo oscuro/normal
  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Panel de Administración",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.appBarColor,
        actions: [
          // Alternador de modo oscuro
          IconButton(
            icon: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: _toggleDarkMode,
          ),
          // Cerrar sesión
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),

      // Fondo visual dinámico según el modo oscuro o claro
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                _isDarkMode
                    ? [Colors.blueGrey.shade700, Colors.blueGrey.shade900]
                    : [Colors.blue.shade300, Colors.blue.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _pages[_selectedIndex], // Muestra la pestaña seleccionada
      ),

      // Barra inferior de navegación con íconos
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Productos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Gestión'),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_problem),
            label: 'Incidencias',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
