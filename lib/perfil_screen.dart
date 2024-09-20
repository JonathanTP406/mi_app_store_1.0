import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'principal_screen.dart'; // Asegúrate de importar PrincipalScreen
import 'user_menu.dart'; // Asegúrate de importar el widget UserMenu

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  PerfilScreenState createState() => PerfilScreenState();
}

class PerfilScreenState extends State<PerfilScreen> {
  File? _imageFile;
  String? _imageUrl;
  bool _isLoading = false; // Nueva variable para gestionar el estado de carga
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfilePicture();
  }

  Future<void> _loadProfilePicture() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()!['imageUrl'] != null) {
        setState(() {
          _imageUrl = doc.data()!['imageUrl'];
        });
      }
    }
  }

Future<void> _pickImage(ImageSource source) async {
  final pickedFile = await _picker.pickImage(source: source);
  if (pickedFile != null) {
    if (!mounted) return; // Verificar si el widget aún está montado
    setState(() {
      _imageFile = File(pickedFile.path);
      _isLoading = true; // Mostrar indicador de carga
    });
    await _uploadImage();
  }
}

Future<void> _uploadImage() async {
  try {
    if (_imageFile != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final storageRef = FirebaseStorage.instance.ref().child('profile_pictures/${user.uid}.jpg');
        await storageRef.putFile(_imageFile!);
        final downloadUrl = await storageRef.getDownloadURL();
        
        // Verificar si el widget sigue montado antes de usar el contexto o setState
        if (!mounted) return;
        
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'imageUrl': downloadUrl,
        });
        setState(() {
          _imageUrl = downloadUrl;
          _isLoading = false; // Ocultar indicador de carga
        });
      }
    }
  } catch (e) {
    if (!mounted) return;
    setState(() {
      _isLoading = false; // Ocultar indicador de carga incluso en caso de error
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al subir la imagen: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const UserMenu(), // Usar el widget de menú común aquí
      ),
      drawer: MediaQuery.of(context).size.width < 600
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const PrincipalScreen()),
                        );
                      },
                      child: Image.asset('assets/tictac_logo.png'),
                    ),
                  ),
                  ListTile(
                    title: const Text('Belleza'),
                    onTap: () {
                      Navigator.pop(context); // Cierra el drawer
                    },
                  ),
                  ListTile(
                    title: const Text('Relojes'),
                    onTap: () {
                      Navigator.pop(context); // Cierra el drawer
                    },
                  ),
                  ListTile(
                    title: const Text('Servicio Técnico'),
                    onTap: () {
                      Navigator.pop(context); // Cierra el drawer
                    },
                  ),
                  ListTile(
                    title: const Text('Blog'),
                    onTap: () {
                      Navigator.pop(context); // Cierra el drawer
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: const Text('Carrito'),
                    onTap: () {
                      Navigator.pop(context); // Cierra el drawer
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.search),
                    title: const Text('Buscar'),
                    onTap: () {
                      Navigator.pop(context); // Cierra el drawer
                    },
                  ),
                ],
              ),
            )
          : null,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageUrl != null
                      ? NetworkImage(_imageUrl!)
                      : _imageFile != null
                          ? FileImage(_imageFile!)
                          : const NetworkImage('https://www.gravatar.com/avatar/placeholder') as ImageProvider,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: () => _showImageSourceActionSheet(context),
                    ),
                  ),
                ),
                if (_isLoading) const CircularProgressIndicator(), // Mostrar el indicador de carga
                ListTile(
                  title: const Text('Pedidos'),
                  onTap: () {
                    // Acción para la opción Pedidos
                  },
                ),
                ListTile(
                  title: const Text('Direcciones'),
                  onTap: () {
                    // Acción para la opción Direcciones
                  },
                ),
                ListTile(
                  title: const Text('Detalles de la cuenta'),
                  onTap: () {
                    // Acción para la opción Detalles de la cuenta
                  },
                ),
                ListTile(
                  title: const Text('Cerrar sesión'),
                  onTap: () {
                    // Acción para cerrar sesión
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Tomar una foto'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Seleccionar de la galería'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}