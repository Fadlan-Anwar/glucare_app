import 'package:flutter/material.dart';

// Import semua halaman dari folder lib
import 'splash_screen.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';
import 'register_screen.dart';
import 'dashboard_screen.dart';
import 'analysis_screen.dart';
import 'clinical_mode_screen.dart';
import 'analysis_result_screen.dart'; 
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'edit_profile_screen.dart';
import 'questionnaire_screen.dart';
import 'recommendation_screen.dart';

void main() {
  runApp(const GluCareApp());
}

class GluCareApp extends StatelessWidget {
  const GluCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GluCare',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF007BFF)),
        useMaterial3: true,
        fontFamily: 'Sans-Serif', // Sesuaikan jika kamu pakai font khusus
      ),
      // Halaman pertama yang muncul saat aplikasi dibuka
      initialRoute: '/splash',
      
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/': (context) => const LoginScreen(), 
        '/login': (context) => const LoginScreen(), 
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/analysis': (context) => const AnalysisScreen(),
        '/clinical-mode': (context) => const ClinicalModeScreen(),
        
        // Halaman Hasil Analisis (Tanpa const karena menerima data)
        '/analysis-result': (context) => const AnalysisResultScreen(
              hba1c: 0.0, 
              gulaDarah: 0, 
              berat: 0.0, 
              tinggi: 1.0, 
            ),

        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/questionnaire': (context) => const QuestionnaireScreen(),
        
        // Halaman Rekomendasi yang baru kita buat
        '/recommendation': (context) => const RecommendationScreen(),
      },
    );
  }
}