import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/auth_service.dart';
import '../../core/user_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  late Animation<double> _logoScaleAnimation;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _logoScaleAnimation = Tween<double>(begin: 1.5, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutBack),
    );

    _progressController.forward();

    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for animation to finish
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;

    // Check if user has a valid token
    final isLoggedIn = await AuthService.isLoggedIn();

    if (isLoggedIn) {
      // Load user data into UserProvider
      final userData = await AuthService.getCurrentUser();
      if (userData != null) {
        UserProvider.updateProfile(
          name: userData['name'] ?? 'User',
          email: userData['email'] ?? '',
        );
      }
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } else {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            
            // Logo Image
            ScaleTransition(
              scale: _logoScaleAnimation,
              child: Image.asset(
                'assets/images/logo.png',
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // App Name
            Text(
              'GLUCARE',
              style: GoogleFonts.poppins(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF007AE1),
                letterSpacing: 2,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Tagline
            Text(
              'Ai Asistenmu untuk menjauhi diabetes',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            
            const Spacer(),
            
            // Bottom Loading Bar & Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: _progressAnimation.value,
                          minHeight: 12,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF007AE1)),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'v1.0.1 | Loading...',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
