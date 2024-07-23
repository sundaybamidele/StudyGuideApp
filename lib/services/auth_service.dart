import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to provide user authentication state
  Stream<User?> get user => _auth.authStateChanges();

  // Get the current user
  User? get currentUser => _auth.currentUser;

  // Register a new user
  Future<User?> register(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();  // Notify listeners of the change
      return userCredential.user;
    } catch (e) {
      // Handle registration errors
      if (kDebugMode) {
        print('Error registering user: $e');
      }
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();  // Notify listeners of the change
      return userCredential.user;
    } catch (e) {
      // Handle sign-in errors
      if (kDebugMode) {
        print('Error signing in: $e');
      }
      return null;
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();  // Notify listeners of the change
  }

  // Update user profile
  Future<void> updateUserProfile(String displayName, String email) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await user.updateProfile(displayName: displayName);
        // ignore: deprecated_member_use
        await user.updateEmail(email);
        await user.reload();
        notifyListeners();  // Notify listeners of the change
      } catch (e) {
        if (kDebugMode) {
          print('Error updating user profile: $e');
        }
        rethrow;
      }
    }
  }
}
