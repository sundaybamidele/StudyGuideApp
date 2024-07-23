import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    // Ensure FirestoreService is available
    // ignore: unnecessary_null_comparison
    if (firestoreService == null) {
      return const Scaffold(
        body: Center(child: Text('FirestoreService not available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: const Center(
        child: Text('Home Screen Content'),
      ),
    );
  }
}
