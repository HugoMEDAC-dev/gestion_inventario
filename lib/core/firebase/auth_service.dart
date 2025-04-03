import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Servicio centralizado para manejar autenticación y acceso a datos de usuario
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Método para registrar un usuario con Firebase Authentication y guardarlo en Firestore
  Future<User?> registerUser({
    required String email,
    required String password,
  }) async {
    // Importante: El método devuelve el usuario registrado si tiene éxito
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    // Guardamos los datos básicos en la colección 'users'
    await _firestore.collection('usuarios').doc(user!.uid).set({
      'email': email.trim(),
      'isAdmin': false, // Todos los nuevos usuarios no son admin
    });

    return user;
  }

  /// Método para iniciar sesión con email y password
  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    // Importante: Devuelve el usuario autenticado si tiene éxito
    UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  /// Método para verificar si el usuario es administrador
  Future<bool> isAdminUser(String uid) async {
    // Importante: Devuelve true si el campo 'isAdmin' es true en Firestore
    DocumentSnapshot doc =
        await _firestore.collection('usuarios').doc(uid).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>?;

      // Si el campo 'isAdmin' no existe, asumimos false por defecto
      return data?['isAdmin'] == true;
    }
    return false; // Si el documento no existe, tampoco es admin
  }

  /// Método para cerrar sesión de forma segura
  Future<void> logoutUser() async {
    await _auth.signOut();
  }
}
