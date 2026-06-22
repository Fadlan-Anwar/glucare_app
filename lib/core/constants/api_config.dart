/// Konfigurasi API terpusat.
/// Ganti [baseUrl] jika ingin switch antara development dan production.
class ApiConfig {
  // ── Production (VPS) ──
  static const String baseUrl = 'https://nusahealth.infinitelearningstudent.id';

  // ── Development (uncomment salah satu jika perlu) ──
  // static const String baseUrl = 'http://localhost:5000';       // Web / Windows
  // static const String baseUrl = 'http://10.0.2.2:5000';        // Android Emulator

  /// Base API URL: /api
  static const String apiUrl = '$baseUrl/api';

  /// Auth API URL: /api/auth
  static const String authUrl = '$apiUrl/auth';
}
