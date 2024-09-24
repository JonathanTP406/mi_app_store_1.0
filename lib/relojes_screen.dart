import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mi_app_store_1_1/carrito_screen.dart';
import 'package:mi_app_store_1_1/main.dart';
import 'package:mi_app_store_1_1/perfil_screen.dart';
import 'package:logging/logging.dart';

final Logger _logger = Logger('RelojesScreen');

class RelojesScreen extends StatefulWidget {
  const RelojesScreen({super.key});

  @override
  RelojesScreenState createState() => RelojesScreenState();
}

class RelojesScreenState extends State<RelojesScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userName = 'username'; // Inicializa con un valor predeterminado

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc.data()?['username'] ?? 'username';
        });
      }
    }
  }

  Future<void> _addToCart(String productId, String productName, double? price) async {
    final user = _auth.currentUser;
    if (user != null) {
      final cartRef = FirebaseFirestore.instance.collection('cart').doc(user.uid);
      try {
        await cartRef.set({
          'items': FieldValue.arrayUnion([{
            'productId': productId,
            'productName': productName,
            'precio': price ?? 0.0, // Asegúrate de que el precio está definido
          }])
        }, SetOptions(merge: true));
      } catch (e) {
        // Manejo de errores
        if (mounted) { // Verifica si el widget aún está montado
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al agregar al carrito: $e')),
          );
        }
      }
    }
  }

  // Función para cerrar sesión
  Future<void> _signOut() async {
    await _auth.signOut();
    // Verifica si el widget aún está montado antes de navegar
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MyApp()), // Redirige a main.dart
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/tictac_logo.png', height: 40),
            if (MediaQuery.of(context).size.width >= 600)
              Row(
                children: [
                  TextButton(
                    child: Text('Mi cuenta $userName'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PerfilScreen()),
                      );
                    },
                  ),
                  TextButton(child: const Text('Belleza'), onPressed: () {}),
                  TextButton(child: const Text('Relojes'), onPressed: () {}),
                  TextButton(child: const Text('Servicio Técnico'), onPressed: () {}),
                  TextButton(child: const Text('Blog'), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CarritoScreen()));
                  }),
                  IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                ],
              ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: const Text('Menú', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: Text('Mi cuenta $userName'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PerfilScreen()),
                );
              },
            ),
            ListTile(title: const Text('Belleza'), onTap: () {}),
            ListTile(title: const Text('Relojes'), onTap: () {}),
            ListTile(title: const Text('Servicio Técnico'), onTap: () {}),
            ListTile(title: const Text('Blog'), onTap: () {}),
            ListTile(
              title: const Text('Carrito'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CarritoScreen()));
              },
            ),
            ListTile(
              title: const Text('Cerrar sesión'),
              onTap: _signOut, // Llama a la función de cerrar sesión
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('productos').where('categoria', isEqualTo: 'relojes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay productos en esta categoría.'));
          }

          // Imprimir los datos usando el logger
          _logger.info('productos: ${snapshot.data!.docs.map((doc) => doc.data()).toList()}');

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.6, // Ajusta este valor para cambiar la altura de las tarjetas
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var product = snapshot.data!.docs[index];
              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Image.network(
                        product['imageUrl'],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const CircularProgressIndicator();
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('Error al cargar imagen');
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(product['nombre'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Text('\$${product['precio']}'),
                    ElevatedButton(
                      onPressed: () {
                        // Verifica que el precio no sea nulo
                        double? productPrice = (product['precio'] is num) ? (product['precio'] as num).toDouble() : null;
                        _addToCart(product.id, product['nombre'], productPrice);
                      },
                      child: const Text('Añadir al carrito'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}