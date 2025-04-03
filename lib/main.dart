import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Necesario para inicializar Firebase
import 'package:flutter_application_1/screens/home_screen.dart';
import 'screens/auth/login_screen.dart'; // Importa la pantalla de login (pantalla inicial)
import 'firebase_options.dart'; // Archivo generado por FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegura que Flutter esté inicializado antes de Firebase
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions
            .currentPlatform, // Inicializa Firebase con opciones según la plataforma
  );
  runApp(const MyApp()); // Inicia la aplicación
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta la etiqueta de debug
      title: 'Gestión Inventario',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Tema principal
      ),
      // Ruta inicial cuando se abre la app
      initialRoute: '/login',
      // Mapa de rutas nombradas para navegar fácilmente entre pantallas
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home':
            (context) => const HomeScreen(), // Puedes añadir más si lo deseas
      },
    );
  }
}
