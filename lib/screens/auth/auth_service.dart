import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

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
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // LOGOUT
  Future<void> signOut() async {
    await _auth.signOut();
  }
}