import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'questionnaire_screen.dart'; 
import 'clinical_mode_screen.dart';

/// Konten tab Analisis — tanpa bottomNav sendiri.
/// Dibungkus oleh MainNavShell.
class AnalysisContent extends StatelessWidget {
  const AnalysisContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLightBlue,
      body: Column(
        children: [
          // Header Biru (menggantikan AppBar)
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, bottom: 20),
            decoration: const BoxDecoration(
              color: AppColors.mainBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Column(
              children: [
                Text("Analisis Risiko", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(height: 8),
                Text("Pilih metode untuk menghitung skor risikomu", style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),

          // Konten Kartu
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  _buildAnalysisCard(
                    context,
                    title: "Mode Klinis / Lab",
                    subtitle: "Input hasil lab untuk analisis paling akurat",
                    icon: Icons.biotech_rounded,
                    tags: ["Usia", "IMT", "Gula Darah", "Tekanan darah", "Kolestrol"],
                    isRecommended: true,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ClinicalModeScreen()));
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildAnalysisCard(
                    context,
                    title: "Mode Kuesioner",
                    subtitle: "Jawab pertanyaan gaya hidup untuk pemeriksaan cepat",
                    icon: Icons.assignment_outlined,
                    tags: ["Pola hidup", "Pola makan", "Gejala", "Aktivitas", "Keluarga"],
                    isRecommended: false,
                    footerText: "📋 Cocok tanpa data lab",
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const QuestionnaireScreen()));
                    },
                  ),
                  const SizedBox(height: 30),
                  Image.asset(
                    'assets/images/doctors_illustration.png', 
                    height: 180, fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(height: 180),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required List<String> tags, required bool isRecommended, required VoidCallback onTap, String? footerText}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))]),
      child: Material(color: Colors.transparent, child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(20),
        child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.mainBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: AppColors.mainBlue)),
            const SizedBox(width: 15),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12))])),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ]),
          const SizedBox(height: 15),
          Wrap(spacing: 8, runSpacing: 8, children: tags.map((tag) => _buildTag(tag)).toList()),
          if (isRecommended) ...[const SizedBox(height: 15), Row(children: [const Icon(Icons.check_circle, color: Colors.green, size: 14), const SizedBox(width: 5), Text("Akurasi tertinggi — direkomendasikan", style: TextStyle(color: Colors.green.shade700, fontSize: 11, fontWeight: FontWeight.bold))])],
        ])))));
  }

  Widget _buildTag(String label) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: AppColors.mainBlue.withOpacity(0.08), borderRadius: BorderRadius.circular(15)),
      child: Text(label, style: const TextStyle(color: AppColors.mainBlue, fontSize: 10, fontWeight: FontWeight.w600)));
  }
}
