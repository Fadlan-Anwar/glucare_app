import 'package:flutter/material.dart';
import 'questionnaire_screen.dart'; 
import 'clinical_mode_screen.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color mainBlue = Color(0xFF007BFF);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: mainBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Analisis Risiko",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          // 1. Header Biru
          Container(
            height: 160,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: mainBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          // 2. Konten Kartu
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Text(
                      "Pilih metode untuk menghitung skor risikomu",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ClinicalModeScreen()),
                            );
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const QuestionnaireScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                        // Ilustrasi Gambar
                        Image.asset(
                          'assets/images/doctors_illustration.png', 
                          height: 180,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const SizedBox(height: 180),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // 3. MENU BAWAH YANG SUDAH BISA DIKLIK (FIXED)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: mainBlue,
        unselectedItemColor: Colors.grey,
        currentIndex: 1, // Angka 1 karena kita di halaman Analisis
        onTap: (index) {
          // Logika pindah halaman
          if (index == 0) Navigator.pushReplacementNamed(context, '/dashboard');
          if (index == 1) Navigator.pushReplacementNamed(context, '/analysis');
          if (index == 2) Navigator.pushReplacementNamed(context, '/recommendation');
          if (index == 3) Navigator.pushReplacementNamed(context, '/progress');
          if (index == 4) Navigator.pushReplacementNamed(context, '/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Analisis"),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), label: "Rekomendasi"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Progres"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profil"),
        ],
      ),
    );
  }

  // Widget pembantu kartu
  Widget _buildAnalysisCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<String> tags,
    required bool isRecommended,
    required VoidCallback onTap,
    String? footerText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF007BFF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: const Color(0xFF007BFF)),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 15),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags.map((tag) => _buildTag(tag)).toList(),
                ),
                if (isRecommended) ...[
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 14),
                      const SizedBox(width: 5),
                      Text("Akurasi tertinggi — direkomendasikan", 
                        style: TextStyle(color: Colors.green.shade700, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF007BFF).withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(label, style: const TextStyle(color: Color(0xFF007BFF), fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }
}