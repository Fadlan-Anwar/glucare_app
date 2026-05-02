import 'package:flutter/material.dart';

// Core
import 'core/constants/app_colors.dart';
import 'core/widgets/main_nav_shell.dart';

// Auth Screens
import 'screens/auth/splash_screen.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';

// Analysis Screens (untuk push dari dalam tab)
import 'screens/analysis/clinical_mode_screen.dart';
import 'screens/analysis/analysis_result_screen.dart';
import 'screens/analysis/questionnaire_screen.dart';

// Profile sub-screens (untuk push dari dalam tab)
import 'screens/profile/edit_profile_screen.dart';
import 'screens/profile/settings/settings_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainBlue),
        useMaterial3: true,
        fontFamily: 'Sans-Serif',
      ),
      initialRoute: '/splash',
      
      routes: {
        // --- Auth flow (halaman terpisah dengan transisi) ---
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/': (context) => const LoginScreen(), 
        '/login': (context) => const LoginScreen(), 
        '/register': (context) => const RegisterScreen(),

        // --- Main app (satu shell, 5 tab instan) ---
        '/dashboard': (context) => const MainNavShell(initialIndex: 0),
        '/analysis': (context) => const MainNavShell(initialIndex: 1),
        '/recommendation': (context) => const MainNavShell(initialIndex: 2),
        '/progress': (context) => const MainNavShell(initialIndex: 3),
        '/profile': (context) => const MainNavShell(initialIndex: 4),

        // --- Sub-halaman (push di atas shell) ---
        '/clinical-mode': (context) => const ClinicalModeScreen(),
        '/analysis-result': (context) => const AnalysisResultScreen(
              hba1c: 0.0, gulaDarah: 0, berat: 0.0, tinggi: 1.0),
        '/questionnaire': (context) => const QuestionnaireScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
      },
    );
  }
}