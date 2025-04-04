import 'package:flutter/material.dart';

class CarritoScreen extends StatefulWidget {
  @override
  _CarritoScreenState createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  List<String> carrito = ['placa base']; // Lista de productos en el carrito

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrito de Compras"),
        backgroundColor: Colors.blueAccent,
      ),
      body: carrito.isEmpty
          ? Center(
              child: Text("El carrito está vacío"),
            )
          : ListView.builder(
              itemCount: carrito.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(carrito[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          carrito.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: carrito.isEmpty ? null : () {
            // Lógica para finalizar la compra
          },
          child: Text("Finalizar Compra"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}
