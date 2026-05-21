import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;
  final http.Client _httpClient = http.Client();

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges =>
      _auth.authStateChanges();

  // REGISTER
  Future<UserCredential> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      if (email.isEmpty ||
          password.isEmpty ||
          fullName.isEmpty) {
        throw Exception('Semua kolom harus diisi');
      }

      if (password.length < 6) {
        throw Exception('Kata sandi minimal 6 karakter');
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!
          .updateDisplayName(fullName);

      await _createUserDocument(
        uid: userCredential.user!.uid,
        email: email,
        fullName: fullName,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> _createUserDocument({
    required String uid,
    required String email,
    required String fullName,
  }) async {
    await _firestore.collection('user').doc(uid).set({
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    });
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await register(
      email: email,
      password: password,
      fullName: fullName,
    );
  }

  // LOGIN
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email dan kata sandi harus diisi');
      }
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // LOGOUT
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }

  // GOOGLE SIGN IN
  Future<UserCredential?> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize();
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();

      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      // Also save to Firestore if needed
      if (userCredential.user != null) {
        await _firestore.collection('user').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
          'fullName': userCredential.user!.displayName,
          'updatedAt': DateTime.now(),
        }, SetOptions(merge: true));
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // FACEBOOK SIGN IN
  Future<UserCredential?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile'],
      );

      if (result.status == LoginStatus.success) {
        // Create a new credential
        final AuthCredential credential = FacebookAuthProvider.credential(
          result.accessToken!.tokenString,
        );

        // Once signed in, return the UserCredential
        UserCredential userCredential = await _auth.signInWithCredential(credential);
        
        // Also save to Firestore if needed
        if (userCredential.user != null) {
          await _firestore.collection('user').doc(userCredential.user!.uid).set({
            'uid': userCredential.user!.uid,
            'email': userCredential.user!.email,
            'fullName': userCredential.user!.displayName,
            'updatedAt': DateTime.now(),
          }, SetOptions(merge: true));
        }

        return userCredential;
      } else if (result.status == LoginStatus.cancelled) {
        return null;
      } else {
        throw Exception(result.message ?? 'Login Facebook gagal');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ALIAS FOR SIGNOUT
  static Future<void> logout() async {
    await _auth.signOut();
  }

  // CHANGE PASSWORD
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw Exception('User tidak ditemukan');
      }

      // Re-authenticate user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // UPDATE PROFILE (Name and Firestore fields)
  Future<void> updateProfile({
    required String fullName,
    String? gender,
    String? phone,
    String? birthDate,
    String? profileImageUrl,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception('User tidak ditemukan');

      // 1. Update Firebase Auth Display Name and Photo URL
      await user.updateDisplayName(fullName);
      if (profileImageUrl != null) {
        await user.updatePhotoURL(profileImageUrl);
      }

      // 2. Update Firestore document (using set with merge: true to create if missing)
      await _firestore.collection('user').doc(user.uid).set({
        'fullName': fullName,
        if (gender != null) 'gender': gender,
        if (phone != null) 'phone': phone,
        if (birthDate != null) 'birthDate': birthDate,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
        'updatedAt': DateTime.now(),
      }, SetOptions(merge: true));
      debugPrint("Firestore update successful for UID: ${user.uid}");
    } on FirebaseAuthException catch (e) {
      debugPrint("FirebaseAuth Error updating profile: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      debugPrint("General Error updating profile: $e");
      throw Exception(e.toString());
    }
  }

  // UPLOAD PROFILE IMAGE TO FIREBASE STORAGE
  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception('User tidak ditemukan');

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user.uid}.jpg');

      // Upload the file
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint("Error uploading profile image: $e");
      throw Exception("Gagal mengunggah foto profil: ${e.toString()}");
    }
  }

  // UPDATE EMAIL (Cara Resmi Firebase - Memerlukan Verifikasi Email Baru)
  Future<void> updateEmail({
    required String newEmail,
    required String password,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null || user.email == null) throw Exception('User tidak ditemukan');

      // 1. Re-authenticate untuk keamanan
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      // 2. Kirim email verifikasi ke alamat baru
      await user.verifyBeforeUpdateEmail(newEmail);

      // 3. Update Firestore SEGERA agar UI aplikasi langsung berubah tanpa refresh
      await _firestore.collection('user').doc(user.uid).set({
        'email': newEmail,
        'updatedAt': DateTime.now(),
      }, SetOptions(merge: true));
      
      debugPrint("Verification sent & Firestore updated to: $newEmail");
    } on FirebaseAuthException catch (e) {
      debugPrint("FirebaseAuth Error: ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      debugPrint("Error: $e");
      throw Exception(e.toString());
    }
  }

  // FETCH USER DATA FROM FIRESTORE
  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      DocumentSnapshot doc = await _firestore.collection('user').doc(user.uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}