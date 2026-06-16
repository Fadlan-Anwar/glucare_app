import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final planDataProvider = FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final user = AuthService().currentUser;
  if (user == null || user.uid.isEmpty) return null;
  try {
    return await PlanService().getPlanData(user.uid);
  } catch (e) {
    return null;
  }
});

class PlanService {
  static final PlanService _instance = PlanService._internal();
  factory PlanService() => _instance;
  PlanService._internal();

  // Endpoint uses AuthService.baseApiUrl
  String get baseUrl => '${AuthService.baseApiUrl}/plan';

  Future<Map<String, dynamic>> getPlanData(String userId) async {
    final url = Uri.parse('$baseUrl/$userId');
    final response = await http.get(url).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal memuat data plan');
    }
  }

  Future<void> enrollPlan({
    required String userId,
    required double sleepTargetHours,
    required int walkingTargetMinutes,
    required String nutritionGoal,
  }) async {
    final url = Uri.parse('$baseUrl/enroll');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'sleep_target_hours': sleepTargetHours,
        'walking_target_minutes': walkingTargetMinutes,
        'nutrition_goal': nutritionGoal,
      }),
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal enroll program');
    }
  }

  Future<Map<String, dynamic>> submitDailyTracking({
    required String userId,
    required int day,
    double? sleepHours,
    int? walkingMinutes,
    double? nutritionScore,
  }) async {
    final url = Uri.parse('$baseUrl/daily');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'day': day,
        'sleep_hours': sleepHours,
        'walking_minutes': walkingMinutes,
        'nutrition_score': nutritionScore,
      }),
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal menyimpan data harian');
    }
  }

  Future<Map<String, dynamic>> submitGlucoseTracking({
    required String userId,
    required int day,
    required double glucoseValue,
  }) async {
    final url = Uri.parse('$baseUrl/glucose');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'day': day,
        'glucose_value': glucoseValue,
      }),
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal menyimpan data gula darah');
    }
  }

  Future<Map<String, dynamic>> runAssessment(String userId, int days) async {
    final endpoint = days == 30 ? 'assessment30' : 'assessment90';
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
      }),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal menjalankan evaluasi');
    }
  }

  Future<List<Map<String, dynamic>>> getDailyTracking(String userId) async {
    final url = Uri.parse('$baseUrl/tracking/daily/$userId');
    final response = await http.get(url).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['data'] ?? []);
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getGlucoseTracking(String userId) async {
    final url = Uri.parse('$baseUrl/tracking/glucose/$userId');
    final response = await http.get(url).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['data'] ?? []);
    }
    return [];
  }
}
