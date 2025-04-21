import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pagina de inicio')),
      body: Center(child: Text('Texto de la pagina de inicio')),
    );
  }
}
