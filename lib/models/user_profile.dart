import 'package:flutter/foundation.dart';

class UserProfile extends ChangeNotifier { // Extend ChangeNotifier
  final String uid;
  final String name;
  final String email;
  late final String? profilePictureUrl;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    this.profilePictureUrl,
  });

  // Add methods to update user profile data and notify listeners
  void updateProfilePicture(String? newUrl) {
    profilePictureUrl = newUrl;
    notifyListeners(); // Notify listeners when the profile is updated
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profile_picture_url': profilePictureUrl,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      profilePictureUrl: map['profile_picture_url'] as String?,
    );
  }
}
