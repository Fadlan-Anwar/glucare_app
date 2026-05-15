import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

// Provider untuk AuthService singleton
final authServiceProvider = Provider((ref) {
  return AuthService();
});

// Provider untuk listen perubahan auth state (login/logout)
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Provider untuk mendapatkan user ID jika sudah login
final userIdProvider = FutureProvider<String?>((ref) async {
  final authState = await ref.watch(authStateChangesProvider.future);
  return authState?.uid;
});

// Provider untuk mendapatkan current user info
final currentUserProvider = FutureProvider<User?>((ref) async {
  final authState = await ref.watch(authStateChangesProvider.future);
  return authState;
});

// Provider untuk status login
final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final user = await ref.watch(userIdProvider.future);
  return user != null;
});

// Provider untuk fetch user profile dari Firestore berdasarkan UID
final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  try {
    final user = await ref.watch(authStateChangesProvider.future);
    
    if (user == null || user.uid.isEmpty) {
      return null;
    }

    final firestore = FirebaseFirestore.instance;
    final docSnapshot = await firestore
        .collection('user')
        .doc(user.uid)
        .get();

    if (docSnapshot.exists) {
      return docSnapshot.data();
    }
    return null;
  } catch (e) {
    throw Exception('Error fetching user profile: ${e.toString()}');
  }
});
