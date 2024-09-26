import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart'; // Importar el paquete logger
import 'package:mi_app_store_1_1/main.dart';
import 'package:mi_app_store_1_1/perfil_screen.dart';
import 'package:mi_app_store_1_1/principal_screen.dart';
import 'package:mi_app_store_1_1/relojes_screen.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  CarritoScreenState createState() => CarritoScreenState();
}

class CarritoScreenState extends State<CarritoScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userName = 'username'; // Suponiendo que ya tienes el nombre de usuario cargado en algún lugar
  double totalPrice = 0.0; // Para almacenar el total del carrito
  final Logger logger = Logger(); // Crear una instancia de Logger

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

  Future<void> _removeFromCart(String productId) async {
    final userId = _auth.currentUser?.uid; // Obtén el ID del usuario actual
    if (userId != null) {
      final cartRef = FirebaseFirestore.instance.collection('cart').doc(userId);
      final cartSnapshot = await cartRef.get();

      if (cartSnapshot.exists) {
        // Obtén los items del carrito
        final List<dynamic> items = cartSnapshot.data()?['items'] ?? [];
        
        // Filtra los items para eliminar el producto seleccionado
        final updatedItems = items.where((item) => item['productId'] != productId).toList();

        // Actualiza el carrito en Firestore
        await cartRef.update({'items': updatedItems});
      }
    }
  }

  // Método para calcular el precio total de los productos en el carrito
  double _calculateTotal(List<Map<String, dynamic>> cartItems) {
    return cartItems.fold(0.0, (accumulator, item) {
      double itemPrice = (item['precio'] ?? 0.0).toDouble(); // Asegúrate de que el precio sea un double
      return accumulator + itemPrice;
    });
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
                  //TextButton(child: const Text('Belleza'), onPressed: () {}),
                  TextButton(
                    child: const Text('Relojes'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RelojesScreen()),
                      );
                    },
                  ),
                  //TextButton(child: const Text('Servicio Técnico'), onPressed: () {}),
                  //TextButton(child: const Text('Blog'), onPressed: () {}),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CarritoScreen()),
                      );
                    },
                  ),
                  //IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                ],
              ),
          ],
        ),
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
                    title: Text('Mi cuenta $userName'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PerfilScreen()),
                      );
                    },
                  ),
                  //ListTile(title: const Text('Belleza'),onTap: () {Navigator.pop(context);},),
                  ListTile(
                    title: const Text('Relojes'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RelojesScreen()),
                      );
                    },
                  ),
                  //ListTile(title: const Text('Servicio Técnico'),onTap: () {Navigator.pop(context);},),
                  //ListTile(title: const Text('Blog'),onTap: () {Navigator.pop(context);},),
                  ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: const Text('Carrito'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CarritoScreen()));
                    },
                  ),
                  //ListTile(leading: const Icon(Icons.search),title: const Text('Buscar'),onTap: () {Navigator.pop(context);},),
                  ListTile(
                    title: const Text('Cerrar sesión'),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      // Evitar usar el BuildContext después de un async gap
                      if (mounted) {
                        Navigator.pushAndRemoveUntil(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(builder: (context) => const MyApp()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            )
          : null,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('cart').doc(_auth.currentUser?.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return const Center(child: Text('Carrito vacío'));
          }

          logger.d("Datos del carrito: ${snapshot.data?.data()}"); // Agregar esta línea para depuración

          var cartItems = List<Map<String, dynamic>>.from(snapshot.data!['items'] ?? []);

          // Calcula el precio total
          totalPrice = _calculateTotal(cartItems);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index];
                    return ListTile(
                      title: Text(item['productName']),
                      subtitle: Text('\$${item['precio'].toStringAsFixed(0)}'), // Mostrar el precio sin decimales
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          logger.i("Eliminando producto con ID: ${item['productId']}"); // Usar logger en lugar de print
                          _removeFromCart(item['productId']); // Solo pasar el productId
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total: \$${totalPrice.toStringAsFixed(0)}', // Mostrar el total sin decimales
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}