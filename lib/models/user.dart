class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String? profilePictureUrl;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    this.profilePictureUrl,
  });

  // Convert a UserProfile instance to a map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profile_picture_url': profilePictureUrl,
    };
  }

  // Create a UserProfile instance from a map
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      profilePictureUrl: map['profile_picture_url'] as String?,
    );
  }
}
