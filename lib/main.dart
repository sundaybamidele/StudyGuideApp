import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAnalytics analytics;

  const HomeScreen({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    Provider.of<FirestoreService>(context);
    Provider.of<StorageService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () async {
              await analytics.logEvent(name: 'home_screen_opened');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Welcome, ${authService.currentUser?.displayName ?? 'User'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Course List'),
              onTap: () {
                Navigator.pushNamed(context, '/manage_courses');
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Assessment'),
              onTap: () {
                Navigator.pushNamed(context, '/assessment');
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Reminder'),
              onTap: () {
                Navigator.pushNamed(context, '/reminder');
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback'),
              onTap: () {
                Navigator.pushNamed(context, '/feedback');
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('Study Materials'),
              onTap: () {
                Navigator.pushNamed(context, '/study_materials');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('User Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await authService.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to the Home Screen!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await analytics.logEvent(name: 'button_pressed', parameters: {'button_name': 'example_button'});
              },
              child: const Text('Log Button Press'),
            ),
          ],
        ),
      ),
    );
  }
}
