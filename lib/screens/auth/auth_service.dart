import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_user.dart';
import '../../core/user_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  // Base URL for backend REST API. Automatically switches between Web and Android Emulator.
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api/auth';
    }
    return 'http://10.0.2.2:5000/api/auth';
  }

  // Base API URL for endpoints outside /auth.
  static String get baseApiUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api';
    }
    return 'http://10.0.2.2:5000/api';
  }
  
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  CustomUser? _currentUser;
  final StreamController<CustomUser?> _authController = StreamController<CustomUser?>.broadcast();
  
  Stream<CustomUser?> get authStateChanges => _authController.stream;
  CustomUser? get currentUser => _currentUser;

  // Retrieve auth token from local storage
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Load user data from SharedPreferences to initialize current state
  Future<CustomUser?> checkCurrentUser() async {
    if (_currentUser != null) return _currentUser;

    final prefs = await SharedPreferences.getInstance();
    final userJsonStr = prefs.getString('user_data');
    if (userJsonStr != null) {
      try {
        final userJson = jsonDecode(userJsonStr);
        _currentUser = CustomUser.fromJson(userJson);
        _authController.add(_currentUser);
        return _currentUser;
      } catch (e) {
        debugPrint("Error loading saved user data: $e");
      }
    }
    return null;
  }

  // REGISTER
  Future<CustomUser> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
        throw Exception('Semua kolom harus diisi');
      }

      if (password.length < 6) {
        throw Exception('Kata sandi minimal 6 karakter');
      }

      final url = Uri.parse('$baseUrl/register');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullname': fullName,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Registration successful, auto-login user
        return await signIn(email: email, password: password);
      } else {
        throw Exception(data['message'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      debugPrint("Error during registration: $e");
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<CustomUser> signUp({
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
  Future<CustomUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email dan kata sandi harus diisi');
      }

      final url = Uri.parse('$baseUrl/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = data['token'];
        final userJson = data['user'];

        final prefs = await SharedPreferences.getInstance();
        if (token != null) {
          await prefs.setString('jwt_token', token);
        }
        await prefs.setString('user_data', jsonEncode(userJson));

        final user = CustomUser.fromJson(userJson);
        _currentUser = user;
        _authController.add(user);
        return user;
      } else {
        throw Exception(data['message'] ?? 'Login gagal');
      }
    } catch (e) {
      debugPrint("Error during login: $e");
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // LOGOUT
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_data');
    _currentUser = null;
    _authController.add(null);
    UserProvider.clearProfile();
  }

  // GOOGLE SIGN IN
  Future<CustomUser?> signInWithGoogle() async {
    try {
      // 1. Initialize Google Sign In (Required in version 7+)
      await _googleSignIn.initialize(
        serverClientId: '740953369648-d8no5la6nme2gcddjf387f2ufigpvpj0.apps.googleusercontent.com',
      );

      // 2. Trigger Google Sign In flow (authenticate() replaces signIn() in version 7+)
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
      if (googleUser == null) return null; // User cancelled

      // 3. Get auth details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception("Gagal mendapatkan Google ID Token");
      }

      // 3. Post to backend
      final url = Uri.parse('$baseUrl/google');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': idToken}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = data['token'];
        final userJson = data['user'];

        final prefs = await SharedPreferences.getInstance();
        if (token != null) {
          await prefs.setString('jwt_token', token);
        }
        await prefs.setString('user_data', jsonEncode(userJson));

        final user = CustomUser.fromJson(userJson);
        _currentUser = user;
        _authController.add(user);
        return user;
      } else {
        throw Exception(data['message'] ?? 'Login dengan Google gagal');
      }
    } catch (e) {
      debugPrint("Error during Google sign in: $e");
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // FACEBOOK SIGN IN
  Future<CustomUser?> signInWithFacebook() async {
    try {
      // 1. Trigger Facebook Login flow
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;
        if (accessToken == null) {
          throw Exception("Gagal mendapatkan Access Token Facebook");
        }

        // 2. Post to backend
        final url = Uri.parse('$baseUrl/facebook');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'token': accessToken.tokenString}),
        );

        final data = jsonDecode(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          final token = data['token'];
          final userJson = data['user'];

          final prefs = await SharedPreferences.getInstance();
          if (token != null) {
            await prefs.setString('jwt_token', token);
          }
          await prefs.setString('user_data', jsonEncode(userJson));

          final user = CustomUser.fromJson(userJson);
          _currentUser = user;
          _authController.add(user);
          return user;
        } else {
          throw Exception(data['message'] ?? 'Login dengan Facebook gagal');
        }
      } else if (result.status == LoginStatus.cancelled) {
        return null; // User cancelled
      } else {
        throw Exception(result.message ?? "Terjadi kesalahan saat login Facebook");
      }
    } catch (e) {
      debugPrint("Error during Facebook sign in: $e");
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  static Future<void> logout() async {
    await AuthService().signOut();
  }

  // CHANGE PASSWORD
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = await checkCurrentUser();
      if (user == null) throw Exception('User tidak ditemukan');

      final token = await getToken();
      final url = Uri.parse('$baseUrl/change-password/${user.uid}');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Gagal memperbarui kata sandi');
      }
    } catch (e) {
      debugPrint("Error during change password: $e");
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // UPDATE PROFILE (Name and database fields)
  Future<void> updateProfile({
    required String fullName,
    String? gender,
    String? phone,
    String? birthDate,
    String? profileImageUrl,
  }) async {
    try {
      final user = await checkCurrentUser();
      if (user == null) throw Exception('User tidak ditemukan');

      final token = await getToken();
      final url = Uri.parse('$baseUrl/update-profile/${user.uid}');

      final body = {
        'fullname': fullName,
        'email': user.email,
        if (gender != null) 'gender': gender,
        if (phone != null) 'phone': phone,
        if (birthDate != null) 'birth_date': birthDate,
        'profile_image': profileImageUrl ?? '',
      };

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final updatedUserJson = data['user'];
        if (updatedUserJson != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_data', jsonEncode(updatedUserJson));
          
          _currentUser = CustomUser.fromJson(updatedUserJson);
          _authController.add(_currentUser);
        }
      } else {
        throw Exception(data['message'] ?? 'Gagal memperbarui profil');
      }
    } catch (e) {
      debugPrint("Error updating profile: $e");
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // UPLOAD PROFILE IMAGE
  Future<String?> uploadProfileImage(List<int> bytes, String filename) async {
    try {
      final user = await checkCurrentUser();
      if (user == null) throw Exception('User tidak ditemukan');

      final token = await getToken();
      final url = Uri.parse('$baseUrl/upload-photo/${user.uid}');

      var request = http.MultipartRequest('PUT', url);
      request.headers.addAll({
        if (token != null) 'Authorization': 'Bearer $token',
      });

      request.files.add(http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: filename,
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final relativePath = responseData['imagePath'];
        if (relativePath != null) {
          // Prepend host URL dynamically depending on platform
          final host = kIsWeb ? 'http://localhost:5000' : 'http://10.0.2.2:5000';
          return '$host$relativePath';
        }
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Gagal mengunggah foto profil');
      }
      return null;
    } catch (e) {
      debugPrint("Error uploading profile image: $e");
      throw Exception("Gagal mengunggah foto profil: ${e.toString().replaceFirst('Exception: ', '')}");
    }
  }

  // UPDATE EMAIL (Mock)
  Future<void> updateEmail({
    required String newEmail,
    required String password,
  }) async {
    throw Exception('Fitur edit email tidak didukung secara terpisah. Harap lakukan lewat edit profile.');
  }

  // FETCH USER DATA FROM DATABASE
  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      final user = await checkCurrentUser();
      if (user == null) return null;

      final token = await getToken();
      final url = Uri.parse('$baseUrl/profile/${user.uid}');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      return null;
    }
  }

  // FETCH LATEST LAB DATA FROM DATABASE
  Future<Map<String, dynamic>?> fetchLatestLabData() async {
    try {
      final user = await checkCurrentUser();
      if (user == null) return null;

      final token = await getToken();
      final url = Uri.parse('$baseApiUrl/lab/${user.uid}');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching latest lab data: $e");
      return null;
    }
  }

  // FETCH LATEST KUESIONER DATA FROM DATABASE
  Future<Map<String, dynamic>?> fetchLatestKuesionerData() async {
    try {
      final user = await checkCurrentUser();
      if (user == null) return null;

      final token = await getToken();
      final url = Uri.parse('$baseApiUrl/kuesioner/${user.uid}');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching latest kuesioner data: $e");
      return null;
    }
  }

  // SUBMIT LAB DATA
  Future<void> submitLabData({
    required double hba1c,
    required int gulaDarahPuasa,
    required double beratBadan,
    required double tinggiBadan,
    required String riwayatKeluarga,
    required String riwayatDiabetes,
  }) async {
    try {
      final user = await checkCurrentUser();
      if (user == null) throw Exception('User tidak ditemukan');

      final token = await getToken();
      final url = Uri.parse('$baseApiUrl/lab/submit');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_id': user.uid,
          'hba1c': hba1c,
          'gula_darah_puasa': gulaDarahPuasa,
          'berat_badan': beratBadan,
          'tinggi_badan': tinggiBadan,
          'riwayat_keluarga': riwayatKeluarga,
          'riwayat_diabetes': riwayatDiabetes,
        }),
      );

      if (response.statusCode != 201) {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Gagal menyimpan data lab');
      }
    } catch (e) {
      debugPrint("Error submitting lab data: $e");
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // SUBMIT QUESTIONNAIRE DATA
  Future<void> submitKuesionerData({
    required String usia,
    required String riwayatKeluarga,
    required String olahraga,
    required String makananManis,
    required String lingkarPinggang,
    required String gejalaDiabetes,
    required String jamTidur,
    required String tingkatStress,
  }) async {
    try {
      final user = await checkCurrentUser();
      if (user == null) throw Exception('User tidak ditemukan');

      final token = await getToken();
      final url = Uri.parse('$baseApiUrl/kuesioner/submit');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_id': user.uid,
          'usia': usia,
          'riwayat_keluarga': riwayatKeluarga,
          'olahraga': olahraga,
          'makanan_manis': makananManis,
          'lingkar_pinggang': lingkarPinggang,
          'gejala_diabetes': gejalaDiabetes,
          'jam_tidur': jamTidur,
          'tingkat_stress': tingkatStress,
        }),
      );

      if (response.statusCode != 201) {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Gagal menyimpan data kuesioner');
      }
    } catch (e) {
      debugPrint("Error submitting kuesioner data: $e");
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  // RUN AI PREDICTION FOR 90-DAY MONITORING
  Future<Map<String, dynamic>> getAiPrediction({
    required String patientId,
    required List<Map<String, dynamic>> records,
  }) async {
    try {
      final token = await getToken();
      final url = Uri.parse('$baseApiUrl/monitoring/predict');

      debugPrint("Calling AI Prediction URL: $url");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'patient_id': patientId,
          'records': records,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data as Map<String, dynamic>;
      } else {
        throw Exception(data['message'] ?? 'Gagal memproses prediksi AI');
      }
    } catch (e) {
      debugPrint("Error running AI prediction: $e");
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}