import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final Logger _logger = Logger();
  String _email = '';
  String _password = '';
  String _username = '';

Future<void> _trySubmitForm() async {
  final isValid = _formKey.currentState!.validate();
  if (isValid) {
    _formKey.currentState!.save();
    try {
      _logger.i("Intentando crear usuario...");
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      _logger.i("Usuario creado, guardando datos adicionales...");
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'username': _username,
        'email': _email,
        'createdAt': Timestamp.now(),
      });

      _logger.i("Datos guardados, mostrando diálogo...");

      if (!mounted) return;

      // Mostrar mensaje de éxito como ventana emergente
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Registro Exitoso'),
            content: const Text('Tu cuenta ha sido creada correctamente.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                  Navigator.of(context).popUntil((route) => route.isFirst); // Vuelve a la pantalla principal
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      _logger.e("Error durante el registro: $e");
      if (!mounted) return;

      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en el registro: ${e.toString()}')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    // El resto del método build permanece sin cambios
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/tictac_logo.png',
                      height: 120,
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Registro',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                key: const ValueKey('username'),
                                validator: (value) {
                                  if (value == null || value.isEmpty || value.length < 4) {
                                    return 'El nombre de usuario debe tener al menos 4 caracteres.';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _username = value ?? '',
                                decoration: const InputDecoration(
                                  labelText: 'Nombre de Usuario',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                key: const ValueKey('email'),
                                validator: (value) {
                                  if (value == null || value.isEmpty || !value.contains('@')) {
                                    return 'Por favor ingrese un email válido.';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _email = value ?? '',
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                key: const ValueKey('password'),
                                validator: (value) {
                                  if (value == null || value.isEmpty || value.length < 7) {
                                    return 'La contraseña debe tener al menos 7 caracteres.';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _password = value ?? '',
                                decoration: const InputDecoration(
                                  labelText: 'Contraseña',
                                  border: OutlineInputBorder(),
                                ),
                                obscureText: true,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _trySubmitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                child: const Text('Registrarse'),
                              ),
                            ],
                          ),
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
    );
  }
}