import 'package:flutter/foundation.dart';

class UserProfile extends ChangeNotifier {
  final String uid;
  final String name;
  final String email;
  String? profilePictureUrl;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    this.profilePictureUrl,
  });

  void updateProfilePicture(String? newUrl) {
    profilePictureUrl = newUrl;
    notifyListeners();
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
