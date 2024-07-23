import 'dart:io'; // Import this for File class
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../services/auth_service.dart';
import 'edit_profile_screen.dart'; // Ensure this file and class exist
import 'edit_password_screen.dart'; // Ensure this file and class exist

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _picker = ImagePicker();
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;
    if (user != null) {
      setState(() {
        _profileImageUrl = user.photoURL;
      });
    }
  }

  Future<void> _updateProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery); // Updated method
    if (pickedFile != null) {
      final file = File(pickedFile.path); // Import dart:io to use File
      final user = Provider.of<AuthService>(context, listen: false).currentUser;

      if (user != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${user.uid}.jpg');
        await ref.putFile(file);
        final url = await ref.getDownloadURL();

        await user.updatePhotoURL(url);
        await Provider.of<AuthService>(context, listen: false).updateUserProfile(
          user.displayName ?? '',
          user.email ?? '',
        );
        setState(() {
          _profileImageUrl = url;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_profileImageUrl != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_profileImageUrl!),
              ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _updateProfileImage,
              child: const Text('Update Profile Picture'),
            ),
            if (user != null) ...[
              const SizedBox(height: 16.0),
              Text(
                'Name: ${user.displayName ?? ''}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Email: ${user.email}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
                child: const Text('Edit Profile'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditPasswordScreen(),
                    ),
                  );
                },
                child: const Text('Change Password'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await authService.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Background color
                ),
                child: const Text('Logout'),
              ),
            ] else ...[
              const Center(child: Text('No user data available')),
            ],
          ],
        ),
      ),
    );
  }
}
