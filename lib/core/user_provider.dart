import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class UserData {
  String name;
  String gender;
  String phone;
  String email;
  String birthDate;
  File? profileImage;
  String? profileImageUrl;

  UserData({
    required this.name,
    required this.gender,
    required this.phone,
    required this.email,
    required this.birthDate,
    this.profileImage,
    this.profileImageUrl,
  });
}

class UserProvider {
  static final ValueNotifier<UserData> userNotifier = ValueNotifier<UserData>(
    UserData(
      name: '',
      gender: '',
      phone: '',
      email: '',
      birthDate: '',
      profileImage: null,
      profileImageUrl: null,
    ),
  );

  static void clearProfile() {
    userNotifier.value = UserData(
      name: '',
      gender: '',
      phone: '',
      email: '',
      birthDate: '',
      profileImage: null,
      profileImageUrl: null,
    );
  }

  static void updateProfile({
    String? name,
    String? gender,
    String? phone,
    String? email,
    String? birthDate,
    File? profileImage,
    String? profileImageUrl,
    bool clearLocalImage = false,
    bool clearImageUrl = false,
  }) {
    final current = userNotifier.value;
    userNotifier.value = UserData(
      name: name ?? current.name,
      gender: gender ?? current.gender,
      phone: phone ?? current.phone,
      email: email ?? current.email,
      birthDate: birthDate ?? current.birthDate,
      profileImage: clearLocalImage ? null : (profileImage ?? current.profileImage),
      profileImageUrl: clearImageUrl ? null : (profileImageUrl ?? current.profileImageUrl),
    );
  }

  // Save profile image to local app documents directory and remember path in prefs
  static Future<File?> persistLocalProfileImage(String uid, File file) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final newFile = await file.copy('$path/profile_$uid.jpg');
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_path_$uid', newFile.path);
      
      updateProfile(profileImage: newFile);
      return newFile;
    } catch (e) {
      debugPrint("Error saving local profile image: $e");
      return null;
    }
  }

  // Load profile image path from prefs
  static Future<File?> loadLocalProfileImage(String uid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final path = prefs.getString('profile_path_$uid');
      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          updateProfile(profileImage: file);
          return file;
        }
      }
      updateProfile(clearLocalImage: true);
      return null;
    } catch (e) {
      debugPrint("Error loading local profile image: $e");
      return null;
    }
  }

  // Clear profile image path from prefs
  static Future<void> clearLocalProfileImage(String uid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('profile_path_$uid');
      updateProfile(clearLocalImage: true);
    } catch (e) {
      debugPrint("Error clearing local profile image: $e");
    }
  }
}
