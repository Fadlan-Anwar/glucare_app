class CustomUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final int isCompleted;

  CustomUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.isCompleted,
  });

  factory CustomUser.fromJson(Map<String, dynamic> json) {
    return CustomUser(
      uid: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      displayName: json['fullname'],
      photoURL: json['profile_image'],
      isCompleted: json['is_completed'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': int.tryParse(uid) ?? 0,
      'email': email,
      'fullname': displayName,
      'profile_image': photoURL,
      'is_completed': isCompleted,
    };
  }
}
