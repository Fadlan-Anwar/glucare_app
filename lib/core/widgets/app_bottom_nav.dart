import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Widget Bottom Navigation Bar yang dipakai di semua halaman utama.
/// [currentIndex] menentukan tab mana yang sedang aktif:
///   0 = Home, 1 = Analisis, 2 = Rekomendasi, 3 = Progres, 4 = Profil
class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.mainBlue,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return; // Jangan navigasi ke halaman yang sama
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/dashboard');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/analysis');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/recommendation');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/progress');
            break;
          case 4:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Beranda"),
        BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: "Analisis"),
        BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), label: "Rekomendasi"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Progres"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profil"),
      ],
    );
  }
}
