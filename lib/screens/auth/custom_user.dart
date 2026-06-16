class CustomUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final int isCompleted;
  final String? gender;
  final String? birthDate;

  CustomUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.isCompleted,
    this.gender,
    this.birthDate,
  });

  factory CustomUser.fromJson(Map<String, dynamic> json) {
    return CustomUser(
      uid: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      displayName: json['fullname'],
      photoURL: json['profile_image'],
      isCompleted: json['is_completed'] ?? 0,
      gender: json['gender'],
      birthDate: json['birth_date']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': int.tryParse(uid) ?? 0,
      'email': email,
      'fullname': displayName,
      'profile_image': photoURL,
      'is_completed': isCompleted,
      'gender': gender,
      'birth_date': birthDate,
    };
  }
}
