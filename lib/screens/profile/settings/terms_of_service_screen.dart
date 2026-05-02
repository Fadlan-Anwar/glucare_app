import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.settingsBg,
      body: Column(children: [
        Container(width: double.infinity, height: 160,
          decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.gradientBlueLight, AppColors.mainBlue]), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
          child: SafeArea(child: Stack(children: [
            Positioned(top: 10, left: 10, child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 22), onPressed: () => Navigator.pop(context))),
            const Center(child: Padding(padding: EdgeInsets.only(top: 20), child: Text("Term Of Service", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)))),
          ]))),
        const SizedBox(height: 30),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            Container(padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("Dengan Menggunakan aplikasi ini Anda setuju untuk:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)), const SizedBox(height: 20),
                _buildNumberedPoint("1", "Tidak menyalahgunakan layanan"),
                _buildNumberedPoint("2", "Tidak melanggar Hukum"),
                _buildNumberedPoint("3", "Menjaga Keamanan akun Anda"),
                const SizedBox(height: 25),
                const Text("Kami Berhak:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), const SizedBox(height: 15),
                _buildArrowPoint("Menghapus akun anda jika melanggar aturan"),
                _buildArrowPoint("Mengubah Layanan sewaktu-waktu"),
              ])),
            const SizedBox(height: 20),
            Container(width: double.infinity, padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade300)),
              child: const Center(child: Text("Terakhir di Perbarui: 29-03-2026", style: TextStyle(fontSize: 13, color: Colors.black87)))),
          ])),
      ]),
    );
  }

  Widget _buildNumberedPoint(String num, String text) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [
    Container(width: 22, height: 22, decoration: const BoxDecoration(color: AppColors.mainBlue, shape: BoxShape.circle), child: Center(child: Text(num, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)))),
    const SizedBox(width: 12), Text(text, style: const TextStyle(fontSize: 14)),
  ]));

  Widget _buildArrowPoint(String text) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Icon(Icons.trending_flat, size: 20, color: Colors.black), const SizedBox(width: 10), Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
  ]));
}
