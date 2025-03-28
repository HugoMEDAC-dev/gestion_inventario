import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_colors.dart';

class TabbarNav extends StatelessWidget {
  const TabbarNav({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.buttonGradient1, AppColors.buttonGradient2],
              ),
              color: AppColors.backgroundComponent,
              borderRadius: BorderRadius.circular(50),
            ),
            labelColor: const Color(0xFFFFFFFF),
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
