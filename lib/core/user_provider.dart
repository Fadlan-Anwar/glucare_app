import 'package:flutter/material.dart';
import 'dart:io';

class UserData {
  String name;
  String gender;
  String phone;
  String email;
  String birthDate;
  File? profileImage;

  UserData({
    required this.name,
    required this.gender,
    required this.phone,
    required this.email,
    required this.birthDate,
    this.profileImage,
  });
}

class UserProvider {
  static final ValueNotifier<UserData> userNotifier = ValueNotifier<UserData>(
    UserData(
      name: 'Fadlan',
      gender: 'Laki-laki',
      phone: '812-3456-7890',
      email: 'fadlanf553@gmail.com',
      birthDate: '01-02-2003',
      profileImage: null,
    ),
  );

  static void updateProfile({
    String? name,
    String? gender,
    String? phone,
    String? email,
    String? birthDate,
    File? profileImage,
  }) {
    final current = userNotifier.value;
    userNotifier.value = UserData(
      name: name ?? current.name,
      gender: gender ?? current.gender,
      phone: phone ?? current.phone,
      email: email ?? current.email,
      birthDate: birthDate ?? current.birthDate,
      // Pass the new image, or keep current if not provided
      profileImage: profileImage != null ? profileImage : current.profileImage,
    );
  }
}
