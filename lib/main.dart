import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // FirebaseAuth for user authentication
import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/storage_service.dart';
import 'models/user_profile.dart'; // Import UserProfile model
import 'screens/user_profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/course_list_screen.dart';
import 'screens/study_materials_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => FirestoreService()),
        Provider(create: (_) => StorageService()),
        // UserProfile provider, populated with the current FirebaseAuth user
        ChangeNotifierProvider<UserProfile>(
          create: (_) {
            final firebaseUser = FirebaseAuth.instance.currentUser;
            return UserProfile(
              uid: firebaseUser?.uid ?? '', 
              name: firebaseUser?.displayName ?? 'Guest',
              email: firebaseUser?.email ?? '',
            );
          },
        ),
        // Listen to authentication state changes
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: FirebaseAuth.instance.currentUser,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = Provider.of<User?>(context);

    return MaterialApp(
      title: 'Study Guide App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: firebaseUser == null ? const LoginScreen() : const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const UserProfileScreen(),
        '/manage_courses': (context) => const CourseListScreen(),
        '/study_materials': (context) => const StudyMaterialsScreen(),
      },
    );
  }
}
