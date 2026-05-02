import 'package:flutter/material.dart';

/// Kumpulan warna yang digunakan di seluruh aplikasi GluCare.
/// Menggantikan deklarasi `const Color mainBlue = ...` yang berulang di setiap file.
class AppColors {
  AppColors._(); // Tidak bisa diinstansiasi

  /// Warna utama biru GluCare
  static const Color mainBlue = Color(0xFF007BFF);

  /// Warna background abu-abu muda
  static const Color bgGray = Color(0xFFF8F9FA);

  /// Background biru sangat muda
  static const Color bgLightBlue = Color(0xFFF8FAFF);

  /// Background biru muda untuk card
  static const Color lightBlueBg = Color(0xFFCDE4FF);

  /// Warna background light untuk settings
  static const Color settingsBg = Color(0xFFF5F9FF);

  /// Warna merah utama (untuk risiko tinggi)
  static const Color mainRed = Color(0xFFDC3545);

  /// Gradient biru untuk header settings
  static const Color gradientBlueLight = Color(0xFF66B2FF);

  /// Warna teks gelap utama
  static const Color textDark = Color(0xFF1A1A2E);

  /// Warna teks medium (abu-abu)
  static const Color textMedium = Color(0xFF6B7280);
}
