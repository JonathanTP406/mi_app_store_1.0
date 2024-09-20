import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'principal_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _logger = Logger();
  String _email = '';
  String _password = '';

  void _trySubmitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PrincipalScreen()),
        );
      } catch (e) {
        _showErrorDialog('Error durante el inicio de sesión. Por favor, verifica tus credenciales.');
        _logger.e('Error during login: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF2196F3),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo de Tictac (placeholder)
                  Image.asset(
                    'assets/tictac_logo.png', // Asegúrate de tener este archivo en tu carpeta de assets
                    height: 120,
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                                prefixIcon: Icon(Icons.email),
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
                                prefixIcon: Icon(Icons.lock),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _trySubmitForm,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text('Iniciar Sesión'),
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
    );
  }
}

