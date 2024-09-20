import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserMenu extends StatelessWidget {
  const UserMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text('Mi cuenta');
        }
        final data = snapshot.data!.data() as Map<String, dynamic>;
        final userName = data['username'] ?? 'Mi cuenta';

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Mi cuenta $userName'),
            if (MediaQuery.of(context).size.width >= 600)
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // Acción para el carrito
                },
              ),
            if (MediaQuery.of(context).size.width >= 600)
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // Acción para la búsqueda
                },
              ),
          ],
        );
      },
    );
  }
}