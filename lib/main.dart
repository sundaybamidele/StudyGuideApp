import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart'; // Import other screens as needed
import 'screens/course_screen.dart';
import 'screens/study_materials_screen.dart';
import 'screens/assessment_screen.dart';
import 'screens/login_screen.dart'; // Your login screen
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),
        Provider<StorageService>(create: (_) => StorageService()),
      ],
      child: MaterialApp(
        title: 'Study Guide App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(), // Initial route goes to splash screen
          '/home': (context) => HomeScreen(),
          // ignore: null_check_always_fails
          '/courses': (context) => CourseScreen(course: null!), // Added null as a placeholder
          '/study_materials': (context) => const StudyMaterialsScreen(),
          '/assessment': (context) => const AssessmentScreen(),
          '/login': (context) => LoginScreen(),
        },
      ),
    );
  }
}
