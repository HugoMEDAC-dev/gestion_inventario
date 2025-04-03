// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_colors.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  _UserDashboard createState() => _UserDashboard();
}

class _UserDashboard extends State<UserDashboard> {
  int _selectedIndex = 0; // Controla qué pestaña está activa
  bool _isDarkMode = false; // Activa/desactiva modo oscuro

  // Contenido de cada pestaña. Puedes reemplazar luego por pantallas reales
  static final List<Widget> _pages = <Widget>[
    _buildPage(Icons.home, "Inicio"),
    _buildPage(Icons.search, "Buscar"),
    _buildPage(Icons.shopping_cart, "Carrito"),
  ];

  // Método estático para generar una vista bonita para cada pestaña
  static Widget _buildPage(IconData icon, String label) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.white),
          SizedBox(height: 16),
          Text(label, style: TextStyle(fontSize: 24, color: Colors.white)),
        ],
      ),
    );
  }

  // Cambia el índice al tocar una opción del BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Cambia entre modo claro y oscuro
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
          "Gestión Inventario",
          style: TextStyle(
            color: Colors.white, // Texto blanco
            fontSize: 22, // Tamaño más grande
            fontWeight: FontWeight.bold, // Negrita para destacar
            letterSpacing: 1.0, // Espaciado entre letras para elegancia
          ),
        ),
        centerTitle: true, // Esto centra el título en la AppBar
        actions: [
          // Botón para alternar entre modo claro y oscuro
          IconButton(
            icon: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: _toggleDarkMode,
          ),
          // Botón para cerrar sesión y volver al login
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await FirebaseAuth.instance
                  .signOut(); // Cierra sesión del usuario
              // Navega de vuelta a la pantalla de login
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
        backgroundColor: AppColors.appBarColor,
      ),

      // Cuerpo de la pantalla con fondo gradiente según modo
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
        child: _pages[_selectedIndex], // Muestra la página activa
      ),

      // Barra inferior de navegación
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.blueAccent,
        onTap: _onItemTapped, // Cambia de pestaña al tocar ícono
      ),
    );
  }
}
