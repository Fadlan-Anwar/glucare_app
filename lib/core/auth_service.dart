import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _currentUserKey = 'current_user_email';
  static const String _usersKey = 'registered_users';

  // ---------- Token Management ----------

  /// Generate a simple local token (UUID-like)
  static String _generateToken() {
    final random = Random.secure();
    final values = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Url.encode(values).replaceAll('=', '');
  }

  /// Check if user is already logged in (has valid token)
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Get the current token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Get the currently logged-in user's data
  static Future<Map<String, String>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_currentUserKey);
    if (email == null) return null;

    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return null;

    final Map<String, dynamic> users = jsonDecode(usersJson);
    if (!users.containsKey(email)) return null;

    final userData = Map<String, dynamic>.from(users[email]);
    return {
      'name': userData['name'] ?? '',
      'email': email,
      'password': userData['password'] ?? '',
    };
  }

  // ---------- Registration ----------

  /// Register a new user locally
  /// Returns: { 'success': true/false, 'message': '...', 'token': '...' }
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return {'success': false, 'message': 'Semua kolom harus diisi'};
    }

    if (!email.contains('@') || !email.contains('.')) {
      return {'success': false, 'message': 'Format email tidak valid'};
    }

    if (password.length < 6) {
      return {'success': false, 'message': 'Kata sandi minimal 6 karakter'};
    }

    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    Map<String, dynamic> users = {};

    if (usersJson != null) {
      users = jsonDecode(usersJson);
    }

    // Check if email is already registered
    if (users.containsKey(email)) {
      return {'success': false, 'message': 'Email sudah terdaftar'};
    }

    // Save user
    users[email] = {
      'name': name,
      'password': password,
    };

    await prefs.setString(_usersKey, jsonEncode(users));

    // Auto-login after registration
    final token = _generateToken();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_currentUserKey, email);

    return {'success': true, 'message': 'Registrasi berhasil!', 'token': token};
  }

  // ---------- Login ----------

  /// Login with email and password
  /// Returns: { 'success': true/false, 'message': '...', 'token': '...' }
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return {'success': false, 'message': 'Email dan kata sandi harus diisi'};
    }

    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    if (usersJson == null) {
      return {'success': false, 'message': 'Akun tidak ditemukan. Silakan daftar terlebih dahulu'};
    }

    final Map<String, dynamic> users = jsonDecode(usersJson);

    if (!users.containsKey(email)) {
      return {'success': false, 'message': 'Email tidak terdaftar'};
    }

    final userData = Map<String, dynamic>.from(users[email]);

    if (userData['password'] != password) {
      return {'success': false, 'message': 'Kata sandi salah'};
    }

    // Generate token and save
    final token = _generateToken();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_currentUserKey, email);

    return {'success': true, 'message': 'Login berhasil!', 'token': token};
  }

  // ---------- Logout ----------

  /// Clear token and current user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_currentUserKey);
  }

  // ---------- Change Password ----------

  /// Change password for the currently logged-in user
  static Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_currentUserKey);
    if (email == null) {
      return {'success': false, 'message': 'Tidak ada user yang login'};
    }

    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) {
      return {'success': false, 'message': 'Data user tidak ditemukan'};
    }

    final Map<String, dynamic> users = jsonDecode(usersJson);
    if (!users.containsKey(email)) {
      return {'success': false, 'message': 'User tidak ditemukan'};
    }

    final userData = Map<String, dynamic>.from(users[email]);

    if (userData['password'] != oldPassword) {
      return {'success': false, 'message': 'Kata sandi lama salah'};
    }

    if (newPassword.length < 6) {
      return {'success': false, 'message': 'Kata sandi baru minimal 6 karakter'};
    }

    // Update password
    userData['password'] = newPassword;
    users[email] = userData;
    await prefs.setString(_usersKey, jsonEncode(users));

    return {'success': true, 'message': 'Kata sandi berhasil diubah!'};
  }
}
