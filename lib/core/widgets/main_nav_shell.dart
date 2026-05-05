import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../../screens/home/dashboard_screen.dart';
import '../../screens/analysis/analysis_screen.dart';
import '../../screens/recommendation/recommendation_screen.dart';
import '../../screens/progress/progress_screen.dart';
import '../../screens/profile/profile_screen.dart';

/// Shell navigasi utama yang membungkus 5 tab utama.
/// Menggunakan IndexedStack agar state setiap tab dipertahankan
/// dan perpindahan tab terasa instan tanpa animasi push/pop.
class MainNavShell extends StatefulWidget {
  final int initialIndex;
  const MainNavShell({super.key, this.initialIndex = 0});

  @override
  State<MainNavShell> createState() => _MainNavShellState();
}

class _MainNavShellState extends State<MainNavShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  // Daftar 5 halaman tab utama
  final List<Widget> _pages = const [
    DashboardContent(),
    AnalysisContent(),
    RecommendationContent(),
    ProgressContent(),
    ProfileContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack mempertahankan state dan langsung switch tanpa animasi
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      // Bottom nav persistent — tidak rebuild saat pindah tab
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.mainBlue,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11.0,
        unselectedFontSize: 10.0,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            setState(() => _currentIndex = index);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: "Analisis"),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), label: "Rekomendasi"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Progres"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profil"),
        ],
      ),
    );
  }
}
