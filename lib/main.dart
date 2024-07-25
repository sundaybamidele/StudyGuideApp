import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart'; // Import FirestoreService
import 'services/storage_service.dart'; // Import StorageService
import 'screens/user_profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart'; // Import HomeScreen
import 'screens/splash_screen.dart'; // Import SplashScreen
import 'screens/course_list_screen.dart'; // Import CourseListScreen
import 'screens/study_materials_screen.dart'; // Import StudyMaterialsScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => FirestoreService()), // Add FirestoreService provider
        Provider(create: (_) => StorageService()), // Add StorageService provider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Guide App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // Set SplashScreen as the initial screen
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const UserProfileScreen(),
        '/manage_courses': (context) => const CourseListScreen(), // Updated route
        '/study_materials': (context) => const StudyMaterialsScreen(), // Add StudyMaterialsScreen route
        // Add other routes if needed
      },
    );
  }
}
