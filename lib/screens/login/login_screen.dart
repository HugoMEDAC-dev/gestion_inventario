// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Necesario para login real
import 'package:flutter_application_1/services/firebase/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false; // Para mostrar indicador mientras se inicia sesión
  // Variable para mostrar u ocultar la contraseña
  bool _obscurePassword = true;
  // Clave para validar el formulario antes de enviar
  final _formKey = GlobalKey<FormState>();

  // Método para iniciar sesión con Firebase Auth y redirigir según si es admin o no
  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true; // Muestra un indicador de carga mientras se autentica
    });

    try {
      // Creamos una instancia del servicio de autenticación
      final authService = AuthService();

      // Iniciamos sesión con email y contraseña usando el servicio
      final user = await authService.loginUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (user != null) {
        // Obtenemos si el usuario es administrador usando el campo booleano 'isAdmin'
        final isAdmin = await authService.isAdminUser(user.uid);

        // Redireccionamos según el tipo de usuario que inicie sesión
        if (isAdmin) {
          if (!mounted) return; // Verifica si el widget sigue montado
          Navigator.pushReplacementNamed(
            context,
            '/admin-dashboard', // Ruta nombrada del panel de administrador
          );
        } else {
          if (!mounted) return; // Verifica si el widget sigue montado
          Navigator.pushReplacementNamed(
            context,
            '/user-dashboard', // Ruta nombrada del panel de usuario
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      // Capturamos errores comunes de inicio de sesión y los mostramos
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Usuario no registrado';
          break;
        case 'wrong-password':
          message = 'Contraseña incorrecta';
          break;
        case 'invalid-email':
          message = 'Correo electrónico no válido';
          break;
        default:
          message = 'Error inesperado: ${e.message}';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      // Cualquier otro error no previsto
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Ocultamos el indicador de carga
      });
    }
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
        backgroundColor: AppColors.appBarColor,
      ),
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Form(
            key: _formKey, // Clave del formulario para validaciones
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Campo Email
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    // Validamos que no esté vacío y tenga formato correcto
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce tu correo';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Correo electrónico no válido';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Correo Electrónico",
                    prefixIcon: const Icon(Icons.email),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Campo Contraseña
                TextFormField(
                  controller: passwordController,
                  obscureText:
                      _obscurePassword, // Aplica la visibilidad según el estado
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    prefixIcon: const Icon(Icons.lock),
                    // Sufijo con icono para mostrar/ocultar contraseña
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          // Alternamos la visibilidad de la contraseña
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Validación de la contraseña
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La contraseña es obligatoria';
                    }
                    if (value.length < 6) {
                      return 'Mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Botón Iniciar Sesión
                ElevatedButton(
                  onPressed:
                      _isLoading
                          ? null
                          : () {
                            // Validamos antes de hacer login
                            if (_formKey.currentState!.validate()) {
                              _loginUser();
                            }
                          },

                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color.fromARGB(255, 221, 224, 228),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                            "Iniciar Sesión",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                ),

                const SizedBox(height: 20),

                // Botón de texto que lleva a la pantalla de registro
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/register', // Ruta nombrada de la pantalla de registro
                    );
                  },
                  child: const Text(
                    "¿No tienes cuenta? Regístrate",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
