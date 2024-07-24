class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  factory UserProfile.fromFirestore(Map<String, dynamic> data) {
    return UserProfile(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photo_url'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photo_url': photoUrl,
    };
  }
}
