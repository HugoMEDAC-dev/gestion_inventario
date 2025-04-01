import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabbarNav extends StatelessWidget {
  const TabbarNav({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProvider.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
          ],
          iconTheme: IconThemeData(
            color:
                themeProvider.isDarkMode
                    ? Colors.white
                    : Colors.black, // Cambia el color según el modo
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, const Color(0xFF3425B8)],
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            labelColor: themeProvider.isDarkMode ? Colors.white : Colors.black,
            splashFactory: NoSplash.splashFactory,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.search)),
              Tab(icon: Icon(Icons.shopping_cart)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text("Prueba HOME")),
            Center(child: Text("Prueba Busqueda")),
            Center(child: Text("Prueba Carrito de Compras")),
          ],
        ),
      ),
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themedata) {
    _themeData = themedata; // Aquí usamos el parámetro
    notifyListeners();
  }

  void toggleTheme() {
    themeData = (_themeData == lightMode) ? darkMode : lightMode;
  }

  static ThemeProvider of(BuildContext context) {
    return context.read<ThemeProvider>();
  }
}

final ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
);

final ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
);
