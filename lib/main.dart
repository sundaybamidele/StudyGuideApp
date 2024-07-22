import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/course_screen.dart'; // Ensure this import is correct
import 'screens/study_materials_screen.dart';
import 'screens/assessment_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize timezone data
  tz.initializeTimeZones();

  // Initialize notification plugin
  await initializeNotifications();

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
          '/': (context) => const SplashScreen(),
          // ignore: prefer_const_constructors
          '/home': (context) => HomeScreen(),
          // ignore: prefer_const_constructors
          '/courses': (context) => CourseScreen(courseId: 'sample_course_id'), // Adjust as needed
          '/study_materials': (context) => const StudyMaterialsScreen(),
          '/assessment': (context) => const AssessmentScreen(),
          '/login': (context) => LoginScreen(),
        },
      ),
    );
  }
}
