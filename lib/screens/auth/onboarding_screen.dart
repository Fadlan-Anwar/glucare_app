import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Welcome to Glucare",
      "subtitle": "Your Ai assistant to help you avoid diabetes with ease and fun.",
      "image": "assets/images/logo.png"
    },
    {
      "title": "Stay Healthy",
      "subtitle": "Get daily suggestions, reminders, and information from Glucare.",
      "image": "assets/images/logo.png"
    },
    {
      "title": "Check Your\nDiabetes Risk",
      "subtitle": "Quickly discover your diabetes risk through a simple health assessment.",
      "image": "assets/images/onboarding1.png"
    },
    {
      "title": "Get Health\nRecommendations",
      "subtitle": "Receive recommendations for better lifestyle, nutrition, and daily activity.",
      "image": "assets/images/onboarding2.png"
    },
    {
      "title": "90 Day\nHealth Plan",
      "subtitle": "Start a structured 90-day program to improve your health and reduce risk.",
      "image": "assets/images/onboarding3.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (v) => setState(() => _currentPage = v),
              itemCount: onboardingData.length,
              itemBuilder: (context, i) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(onboardingData[i]["image"]!, height: 250),
                  const SizedBox(height: 40),
                  Text(
                    onboardingData[i]["title"]!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26, 
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      onboardingData[i]["subtitle"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Indikator Titik (Dot Indicator)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
              (index) => Container(
                height: 8,
                width: _currentPage == index ? 24 : 8,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _currentPage == index ? AppColors.mainBlue : Colors.grey.withOpacity(0.3),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(30, 40, 30, 50),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage == onboardingData.length - 1) {
                    // PINDAH KE REGISTRASI sesuai desain Figma
                    Navigator.pushReplacementNamed(context, '/auth-choice');
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300), 
                      curve: Curves.ease,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _currentPage == onboardingData.length - 1 
                      ? "Let's Get Started"
                      : "NEXT",
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
