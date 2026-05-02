import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ClinicalModeScreen extends StatefulWidget {
  const ClinicalModeScreen({super.key});
  @override
  State<ClinicalModeScreen> createState() => _ClinicalModeScreenState();
}

class _ClinicalModeScreenState extends State<ClinicalModeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLightBlue,
      appBar: AppBar(
        backgroundColor: AppColors.mainBlue, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20), onPressed: () => Navigator.pop(context)),
        title: const Text("Analisis Risiko", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: double.infinity, padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
            decoration: const BoxDecoration(color: AppColors.mainBlue, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
            child: Column(children: [
              const Text("Masukkan data untuk analisis AI", style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 20),
              ClipRRect(borderRadius: BorderRadius.circular(10), child: const LinearProgressIndicator(value: 0.5, backgroundColor: Colors.white24, valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent), minHeight: 8)),
            ]),
          ),
          Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Masukkan hasil pemeriksaan laboratorium terbaru Anda.", style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 20),
            _buildInputCard("HbA1c (%)", "5.9", "%", "Normal < 5.7% · Prediabetes 5.7–6.4% · DM ≥ 6.5%"),
            _buildInputCard("Gula Darah Puasa (mg/dL)", "108", "mg/dL", "Normal < 100 · Prediabetes 100–125 · DM ≥ 126"),
            _buildInputCard("Berat Badan (kg)", "72", "kg", "Untuk kalkulasi BMI"),
            _buildInputCard("Tinggi Badan (cm)", "168", "cm", "BMI Asia: Normal < 23 · Overweight 23–27.4"),
            _buildSelectionCard("Riwayat Keluarga Diabetes", ["Ya", "Tidak", "Tidak Tahu"]),
            const SizedBox(height: 30),
            SizedBox(width: double.infinity, height: 55, child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/analysis-result'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.mainBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 2),
              child: const Text("Analisis Sekarang", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)))),
            const SizedBox(height: 20),
          ])),
        ]),
      ),
    );
  }

  Widget _buildInputCard(String label, String hint, String unit, String info) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20), padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.withValues(alpha: 0.1))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),
        TextField(decoration: InputDecoration(hintText: hint, suffixText: unit, suffixStyle: const TextStyle(color: AppColors.mainBlue, fontWeight: FontWeight.bold), filled: true, fillColor: AppColors.bgLightBlue, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12)), keyboardType: TextInputType.number),
        const SizedBox(height: 8),
        Text(info, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ]));
  }

  Widget _buildSelectionCard(String label, List<String> options) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.withValues(alpha: 0.1))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 15),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: options.map((opt) => Expanded(child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5), padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: opt == "Tidak Tahu" ? Colors.grey[100] : Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey[200]!)),
          child: Center(child: Text(opt, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
        ))).toList()),
      ]));
  }
}
