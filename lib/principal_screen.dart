import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_app_store_1_1/carrito_screen.dart';
import 'package:mi_app_store_1_1/main.dart';
import 'package:mi_app_store_1_1/relojes_screen.dart';
import 'perfil_screen.dart';


class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  PrincipalScreenState createState() => PrincipalScreenState();
}

class PrincipalScreenState extends State<PrincipalScreen> {
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

  @override
  Widget build(BuildContext context) {
    final List<String> imagePaths = [
      'assets/watch_0.jpg',
      'assets/watch_1.png',
      'assets/watch_2.jpg',
      'assets/watch_3.jpg',
      'assets/watch_4.png',
      'assets/watch_5.jpg',
    ];

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
                    child: Text('Mi cuenta $userName'), // Mostrar "Mi cuenta username"
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PerfilScreen()),
                      );
                    },
                  ),
                  TextButton(child: const Text('Belleza'), onPressed: () {}),
                  TextButton(
                    child: const Text('Relojes'), 
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RelojesScreen()),
                      );
                    }
                  ),
                  TextButton(child: const Text('Servicio Técnico'), onPressed: () {}),
                  TextButton(child: const Text('Blog'), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.search), onPressed: () {}),
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
                  child: Image.asset('assets/tictac_logo.png'),
                ),
                ListTile(
                  title: Text('Mi cuenta $userName'), // Mostrar "Mi cuenta username"
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PerfilScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Belleza'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
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
                ListTile(
                  title: const Text('Servicio Técnico'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Blog'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text('Carrito'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CarritoScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.search),
                  title: const Text('Buscar'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Cerrar sesión'),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut(); // Cerrar sesión
                    if (!mounted) return; // Asegúrate de que el widget siga montado
                    Navigator.pushAndRemoveUntil(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()), // Navegar a PrincipalScreen
                      (Route<dynamic> route) => false, // Eliminar todas las pantallas anteriores
                    );
                  },
                ),
              ],
            ),
          )
        : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset('assets/hero_image.jpg', fit: BoxFit.cover),
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Haz que cada momento cuente',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        child: const Text('Compra Ahora'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Productos recomendados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Text('El reloj ideal para cada día de la semana', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 14),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount;
                      double childAspectRatio;

                      if (constraints.maxWidth < 600) {
                        crossAxisCount = 2;
                        childAspectRatio = 0.75;
                      } else if (constraints.maxWidth < 1200) {
                        crossAxisCount = 3;
                        childAspectRatio = 0.75;
                      } else {
                        crossAxisCount = 4;
                        childAspectRatio = 0.7;
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemCount: imagePaths.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Column(
                              children: [
                                Image.asset(imagePaths[index], fit: BoxFit.cover),
                                const Text('RELOJ CASIO B640WC-5ADF'),
                                const Text('\$324.000'),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}