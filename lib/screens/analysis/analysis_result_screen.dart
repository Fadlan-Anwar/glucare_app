import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../home/dashboard_screen.dart';

class AnalysisResultScreen extends StatelessWidget {
  final double hba1c;
  final int gulaDarah;
  final double berat;
  final double tinggi;

  const AnalysisResultScreen({
    super.key,
    required this.hba1c,
    required this.gulaDarah,
    required this.berat,
    required this.tinggi,
  });

  @override
  Widget build(BuildContext context) {
    // Set hasRiskData to true so the Dashboard updates
    DashboardContent.hasRiskDataNotifier.value = true;

    return Scaffold(
      backgroundColor: AppColors.bgGray,
      // --- MENU BAWAH (BOTTOM NAVIGATION BAR) ---
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Biru
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 30),
              decoration: const BoxDecoration(
                color: AppColors.mainBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    "Hasil Analisis",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Skor risiko prediabetes personalmu",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            // Area Konten Putih
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // --- KARTU SKOR UTAMA ---
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red.shade100, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.report_problem, color: AppColors.mainRed, size: 50),
                        const SizedBox(height: 10),
                        const Text(
                          "68%",
                          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: AppColors.mainRed),
                        ),
                        const Text(
                          "● Risiko Tinggi",
                          style: TextStyle(color: AppColors.mainRed, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const Text(
                          "Indikasi Prediabetes/Diabetes",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 25),
                        const Divider(height: 1, color: Color(0xFFEEEEEE)),
                        const SizedBox(height: 20),
                        // Mini Statistik
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMiniStat("30 thn", "Usia Kronologis"),
                            _buildMiniStat("42 thn", "Usia Metabolik"),
                            _buildMiniStat("42%", "Risiko 5 Thn"),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Segera konsultasikan ke dokter. Program intervensi 90 hari GluCare sangat direkomendasikan.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // --- FAKTOR RISIKO SECTION ---
                  _buildSectionTitle("Faktor Risiko Teridentifikasi"),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        _buildRiskItem("HbA1c ≥ 6.5% — rentang diabetes"),
                        _buildRiskItem("Gula puasa normal"),
                        _buildRiskItem("BMI ≥ 27.5 — obesitas"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // --- INTERPRETASI LAB SECTION ---
                  _buildSectionTitle("🔬 Interpretasi Lab"),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue.shade100, width: 1.5),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("HbA1c 11.1%: 🔴 Diabetes", style: TextStyle(fontSize: 14, color: Colors.black87)),
                        SizedBox(height: 5),
                        Text("BMI 30.9.1 kg/m²: 🔴 Obesitas", style: TextStyle(fontSize: 14, color: Colors.black87)),
                        SizedBox(height: 5),
                        Text("Gula Puasa 11 mg/dL: 🟢 Normal", style: TextStyle(fontSize: 14, color: Colors.black87)),
                      ],
                    ),
                  ),

                const SizedBox(height: 35),

                  // --- TOMBOL-TOMBOL BAWAH ---
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/recommendation', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainBlue,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Lihat Rencana Intervensi",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      side: const BorderSide(color: Colors.grey, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "Assessment Ulang",
                      style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pembantu untuk mini statistik
  Widget _buildMiniStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
        const SizedBox(height: 3),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  // Widget pembantu untuk judul section
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 5),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }

  // Widget pembantu untuk item faktor risiko
  Widget _buildRiskItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 18),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87))),
        ],
      ),
    );
  }
}
