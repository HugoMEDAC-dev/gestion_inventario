import 'package:cloud_firestore/cloud_firestore.dart';

/// Carga todos los productos desde una subcategoría específica.
Future<List<DocumentSnapshot>> cargarProductos(
  String categoria,
  String subcategoria,
) async {
  final query =
      await FirebaseFirestore.instance
          .collection('productos')
          .doc(categoria)
          .collection(subcategoria)
          .get();

  return query.docs;
}

/// Guarda un producto nuevo con un ID personalizado tipo `cpu_01`, `cpu_02`, etc.
Future<String> guardarProductoConID({
  required String categoria,
  required String subcategoria,
  required Map<String, dynamic> data,
}) async {
  final coleccion = FirebaseFirestore.instance
      .collection('productos')
      .doc(categoria)
      .collection(subcategoria);

  final docs = await coleccion.get();
  final ids = docs.docs.map((doc) => doc.id).toList();

  final numeros =
      ids.where((id) => id.startsWith(subcategoria)).map((id) {
        final partes = id.split('_');
        return (partes.length == 2) ? int.tryParse(partes[1]) ?? 0 : 0;
      }).toList();

  final siguienteNumero = (numeros.isEmpty
          ? 1
          : numeros.reduce((a, b) => a > b ? a : b) + 1)
      .toString()
      .padLeft(2, '0');

  final nuevoID = '${subcategoria}_$siguienteNumero';

  await coleccion.doc(nuevoID).set(data);
  return nuevoID;
}

/// Actualiza un producto existente con nuevos datos.
Future<void> actualizarProducto(
  DocumentSnapshot doc,
  Map<String, dynamic> data,
) {
  return doc.reference.update(data);
}

/// Elimina un producto existente.
Future<void> eliminarProducto(DocumentSnapshot doc) {
  return doc.reference.delete();
}
