import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.settingsBg,
      body: Column(children: [
        Container(width: double.infinity, height: 160,
          decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.gradientBlueLight, AppColors.mainBlue]), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
          child: SafeArea(child: Stack(children: [
            Positioned(top: 10, left: 10, child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 22), onPressed: () => Navigator.pop(context))),
            const Center(child: Padding(padding: EdgeInsets.only(top: 20), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.help_outline, color: Colors.black, size: 28), SizedBox(width: 10), Text("Help & Support", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold))]))),
          ]))),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children: [
          TextField(decoration: InputDecoration(hintText: "Cari bantuan...", prefixIcon: const Icon(Icons.search, color: Colors.grey), filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(vertical: 15), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
          const SizedBox(height: 25),
          Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildFAQItem("Bagaimana cara Login?", "Masukan Email & Pasword lalu Klik Login"),
              const Divider(height: 30),
              _buildFAQItem("Lupa Password", "Klik \"Forgot Pasword\" Lalu ikuti intruksi."),
            ])),
          const SizedBox(height: 25),
          Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(children: [
              _buildContactItem(Icons.email_outlined, "Email:", "layanannusahealt228@gmail.com"), const SizedBox(height: 15),
              _buildContactItem(Icons.phone_android, "Whatsapp:", "+62812-XXXX-XXXX"),
            ])),
          const SizedBox(height: 30),
          SizedBox(width: double.infinity, child: Container(
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.gradientBlueLight, AppColors.mainBlue]), borderRadius: BorderRadius.circular(15)),
            child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 15)),
              child: const Text("HUBUNGI KAMI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))))),
        ]))),
      ]),
    );
  }

  Widget _buildFAQItem(String question, String answer) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [const Icon(Icons.help, size: 18, color: Colors.blue), const SizedBox(width: 8), Text(question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))]),
    const SizedBox(height: 10),
    Row(children: [const Icon(Icons.trending_flat, size: 18, color: Colors.blue), const SizedBox(width: 10), Expanded(child: Text(answer, style: const TextStyle(fontSize: 13)))]),
  ]);

  Widget _buildContactItem(IconData icon, String label, String value) => Row(children: [
    Icon(icon, color: Colors.blue, size: 24), const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)), Text(value, style: const TextStyle(fontSize: 13, color: Colors.blue, decoration: TextDecoration.underline))])),
  ]);
}
