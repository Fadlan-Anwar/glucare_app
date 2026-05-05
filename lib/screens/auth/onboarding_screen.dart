import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      imagePath: 'assets/images/onboarding1.png',
      title: 'Cek Risiko Diabetes Anda',
      subtitle: 'Ketahui risiko diabetes Anda dengan cepat melalui penilaian kesehatan yang sederhana.',
    ),
    _OnboardingPage(
      imagePath: 'assets/images/onboarding2.png',
      title: 'Rekomendasi Kesehatan Pintar',
      subtitle: 'Terima saran personal untuk pola makan, olahraga, dan gaya hidup sehat yang disesuaikan untuk Anda.',
    ),
    _OnboardingPage(
      imagePath: 'assets/images/onboarding3.png',
      title: 'Program 90 Hari & Pengingat',
      subtitle: 'Jalani program kesehatan 90 hari dengan misi harian dan pantau progres Anda setiap saat.',
    ),
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/auth-choice');
    }
  }

  void _onSkip() {
    Navigator.pushReplacementNamed(context, '/auth-choice');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _buildPage(page);
                },
              ),
            ),

            // Bottom section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  // Dot Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 32 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? const Color(0xFF007AE1)
                              : const Color(0xFFD4E4F7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Bottom Navigation Buttons (no background)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Skip Button
                      TextButton(
                        onPressed: _onSkip,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF3B5998),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: Text(
                          'Lewati',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4A6B9C),
                          ),
                        ),
                      ),

                      // Next Button
                      SizedBox(
                        width: 120,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _onNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007AE1),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Text(
                            _currentPage == _pages.length - 1 ? 'Mulai' : 'Lanjut',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration Image
          Hero(
            tag: page.imagePath,
            child: SizedBox(
              height: 280,
              child: Image.asset(
                page.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 280,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 40),
          
          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          
          // Subtitle
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.black87,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final String imagePath;
  final String title;
  final String subtitle;

  const _OnboardingPage({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });
}
