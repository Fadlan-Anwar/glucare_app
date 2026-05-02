import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.settingsBg,
      body: Column(children: [
        Container(width: double.infinity, height: 160,
          decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.gradientBlueLight, AppColors.mainBlue]), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
          child: SafeArea(child: Stack(children: [
            Positioned(top: 10, left: 10, child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 22), onPressed: () => Navigator.pop(context))),
            const Center(child: Padding(padding: EdgeInsets.only(top: 20), child: Text("Privacy Policy", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)))),
          ]))),
        const SizedBox(height: 30),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Privacy Policy", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 15),
              const Text("Kami menghargai privasi Anda. Informasi yang kami kumpulkan:", style: TextStyle(fontSize: 14, height: 1.5)), const SizedBox(height: 10),
              _buildBullet("Data akun (Nama, Email)"), _buildBullet("Data Pengguna Aplikasi"), const SizedBox(height: 20),
              const Text("Kami menggunakan Data untuk:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), const SizedBox(height: 10),
              _buildBullet("Meningkatkan Layanan"), _buildBullet("Memberikan Pengalaman pengguna yang lebih"), const SizedBox(height: 20),
              const Text("Keamanan Data", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), const SizedBox(height: 8),
              const Text("Kami menjaga data Anda dengan keamanan sistem yang terbaik", style: TextStyle(fontSize: 13)), const SizedBox(height: 30),
              const Center(child: Text("Apabila ada pertanyaan hubungi kami disini", style: TextStyle(fontSize: 12, color: Colors.grey))), const SizedBox(height: 10),
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.email_outlined, color: AppColors.mainBlue, size: 18), SizedBox(width: 8), Text("nusahealt228@gmaul.com", style: TextStyle(color: AppColors.mainBlue, fontWeight: FontWeight.bold))]),
            ]))),
      ]),
    );
  }

  Widget _buildBullet(String text) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [const Icon(Icons.circle, size: 8, color: Colors.blue), const SizedBox(width: 10), Text(text, style: const TextStyle(fontSize: 14))]));
}
