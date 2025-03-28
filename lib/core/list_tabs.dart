import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_colors.dart';

class TabbarNav extends StatelessWidget {
  const TabbarNav({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundComponent,
          title: const Text('PepeComponentes'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.search)),
              Tab(icon: Icon(Icons.shopping_cart)),
            ],
          ),
        ),
      ),
    );
  }
}
