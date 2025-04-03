import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home_screen.dart'; // Ruta a la pantalla principal después del registro

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); // Clave para validar el formulario
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  // Función de registro con Firebase (descomentar cuando esté implementado)
  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Intenta registrar al usuario con email y password
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      User? user = userCredential.user;

      // Añade los datos del usuario a la colección 'users' en Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'uid': user.uid,
        'email': _emailController.text.trim(),
        'role': 'user', // Por defecto los nuevos usuarios son normales
      });

      // Verifica que el widget sigue montado en pantalla antes de usar el context
      if (!mounted) return;

      // Muestra un mensaje tipo SnackBar cuando el usuario se registra correctamente
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario registrado con éxito')),
      );

      // Redirige a la pantalla principal (HomeScreen)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      // Manejamos los errores comunes de registro con mensajes específicos
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      // Manejamos los errores comunes de registro con mensajes específicos
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message =
              'El correo ya está en uso'; // Ya existe un usuario con ese correo
          break;
        case 'weak-password':
          message =
              'La contraseña es demasiado débil'; // No cumple los requisitos mínimos
          break;
        case 'invalid-email':
          message = 'Correo no válido'; // Formato incorrecto
          break;
        default:
          message =
              'Error inesperado: ${e.message}'; // Otros errores no previstos
      }

      // Mostramos el mensaje de error con SnackBar (mensaje inferior que desaparece solo)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      // Actualiza el estado para ocultar el indicador de carga
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de Usuario',
          style: TextStyle(
            color: Colors.white, // Texto blanco
            fontSize: 22, // Tamaño más grande
            fontWeight: FontWeight.bold, // Negrita para destacar
            letterSpacing: 1.0, // Espaciado entre letras para elegancia
          ),
        ),
        centerTitle:
            true, // Esto centra el título en la AppBar, importante en web
        backgroundColor: AppColors.appBarColor,
      ),
      body: Container(
        // Fondo gradiente para unificar estilo con login
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.screenGradientTop,
              AppColors.screenGradientBottom,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Título centrado
                      const Text(
                        'Crea tu cuenta',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),

                      // Campo Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Correo Electrónico',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Introduce un correo';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Correo inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Campo Contraseña
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator:
                            (value) =>
                                value != null && value.length < 6
                                    ? 'Mínimo 6 caracteres'
                                    : null,
                      ),
                      const SizedBox(height: 30),

                      // Botón de registro (habilitar después)
                      ElevatedButton(
                        onPressed: _isLoading ? null : _registerUser,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:
                            _isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  'Registrarse',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                      ),

                      const SizedBox(height: 20),

                      // Vuelta al login
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            // Sección donde ajustamos el sombreado del TextButton
                            padding:
                                EdgeInsets
                                    .zero, // Elimina el padding extra que agranda el botón
                            tapTargetSize:
                                MaterialTapTargetSize
                                    .shrinkWrap, // Reduce el área táctil al mínimo
                          ),
                          onPressed: () {
                            Navigator.pop(context); // Regresa al login
                          },
                          child: const Text(
                            '¿Ya tienes cuenta? Inicia sesión',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
