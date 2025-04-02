import 'package:flutter/material.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0; // Índice para rastrear la pestaña seleccionada
  bool _isDarkMode = false; // Estado para el modo nocturno

  // Lista de páginas para cada opción del BottomNavigationBar
  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Home', style: TextStyle(fontSize: 24))),
    Center(child: Text('Search', style: TextStyle(fontSize: 24))),
    Center(child: Text('Carrito de Compras', style: TextStyle(fontSize: 24))),
  ];

  // Función para cambiar la pestaña seleccionada
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Función para alternar entre modo claro y oscuro
  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión Inventario'), // Título de la AppBar
        actions: [
          // Botón en la AppBar para cambiar el modo nocturno
          IconButton(
            icon: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: _toggleDarkMode,
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color:
            _isDarkMode ? Colors.blueGrey : Colors.white, // Fondo según el modo
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
        ],
        currentIndex: _selectedIndex, // Índice seleccionado
        selectedItemColor: Colors.white, // Color del ítem seleccionado
        unselectedItemColor:
            Colors.white70, // Color de los ítems no seleccionados
        backgroundColor: Colors.blue, // Color de fondo del NavigationBar
        onTap: _onItemTapped, // Función para cambiar de pestaña
      ),
    );
  }
}
