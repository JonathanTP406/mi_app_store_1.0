import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mi_app_store_1_1/firebase_options.dart';
import 'login_screen.dart';
import 'register_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TicTac Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Definir rutas aquí
      routes: {
        '/': (context) => const HomeScreen(), // Ruta principal
        '/login': (context) => const LoginScreen(), // Ruta para iniciar sesión
        '/register': (context) => const RegisterScreen(), // Ruta para el registro
      },
      initialRoute: '/', // Establece la pantalla principal como ruta inicial
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/tictac_logo.png', // Asegúrate de tener este archivo en tu carpeta de assets
                  height: 120,
                ),
                const SizedBox(height: 30),
                Text(
                  'Bienvenidos',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                _buildButton('Iniciar Sesión', Colors.white, Colors.blue[700]!, () {
                  Navigator.pushNamed(context, '/login');
                }),
                const SizedBox(height: 20),
                _buildButton('Registrarse', Colors.blue[700]!, Colors.white, () {
                  Navigator.pushNamed(context, '/register');
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color textColor, Color backgroundColor, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      child: Text(text),
    );
  }
}