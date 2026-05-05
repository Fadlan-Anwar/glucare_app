import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../home/dashboard_screen.dart';

class EvaluasiTab extends StatelessWidget {
  const EvaluasiTab({super.key});

  @override
  Widget build(BuildContext context) {
    final data = DashboardContent.analysisDataNotifier.value ?? {};
    final int score = data['score'] as int? ?? 68;
    final String riskStatus = data['riskStatus'] as String? ?? 'Tinggi';
    final Color riskColor = data['riskColor'] as Color? ?? const Color(0xFFDC2626);
    final double hba1c = data['hba1c'] as double? ?? 6.5;
    final double bmi = data['bmi'] as double? ?? 27.5;
    final int gulaDarah = data['gulaDarah'] as int? ?? 126;

    return Column(children: [
      _buildPerbandinganRisiko(score, riskStatus, riskColor),
      const SizedBox(height: 24),
      _buildMetrikMetabolik(score),
      const SizedBox(height: 24),
      _buildFaktorRisiko(hba1c, bmi, gulaDarah),
      const SizedBox(height: 24),
      _buildReAssessmentNotification(),
      const SizedBox(height: 32),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/analysis', (route) => false);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          icon: const Icon(Icons.sync_rounded, color: Colors.white),
          label: Text('Lakukan Re-Assessment', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
      const SizedBox(height: 40),
    ]);
  }

  Widget _buildPerbandinganRisiko(int score, String riskStatus, Color riskColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Perbandingan Risiko', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _buildRisikoCard(title: 'Sekarang', percentage: '$score%', status: riskStatus, date: 'Hari 1', progressColor: riskColor, progressValue: score / 100.0, isCurrent: true)),
          const SizedBox(width: 16),
          Expanded(child: _buildRisikoCard(title: 'Target', percentage: '<50%', status: 'Normal', date: 'Hari 90', progressColor: const Color(0xFF10B981), progressValue: 0.50, isCurrent: false)),
        ]),
        const SizedBox(height: 16),
        Container(
          width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.info_outline_rounded, color: Color(0xFF3B82F6), size: 18),
            const SizedBox(width: 8),
            Text('Ini adalah hasil assessment awal Anda.', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF3B82F6))),
          ]),
        ),
      ]),
    );
  }

  Widget _buildRisikoCard({required String title, required String percentage, required String status, required String date, required Color progressColor, required double progressValue, required bool isCurrent}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrent ? const Color(0xFFF0FDF4) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isCurrent ? const Color(0xFF86EFAC) : Colors.grey[200]!, width: isCurrent ? 1.5 : 1),
        boxShadow: [if (!isCurrent) BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(percentage, style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: progressColor)),
        Text(status, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: progressColor)),
        const SizedBox(height: 12),
        Text(date, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[400])),
        const SizedBox(height: 8),
        ClipRRect(borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: progressValue, backgroundColor: Colors.grey[200], valueColor: AlwaysStoppedAnimation<Color>(progressColor), minHeight: 6)),
      ]),
    );
  }

  Widget _buildMetrikMetabolik(int score) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Metrik Metabolik', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        _buildMetrikRow('Usia Metabolik', 'vs. usia 30', '${30 + (score / 10).round()} tahun'),
        const Divider(height: 24, thickness: 1, color: Color(0xFFF1F5F9)),
        _buildMetrikRow('Risiko 5 Tahun', 'probabilitas progresi', '${(score * 0.6).round()}%'),
        const Divider(height: 24, thickness: 1, color: Color(0xFFF1F5F9)),
        _buildMetrikRow('Mode Assessment', 'Hari 1', 'Klinis (Lab)'),
      ]),
    );
  }

  Widget _buildMetrikRow(String title, String subtitle, String value) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[400])),
      ]),
      Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
    ]);
  }

  Widget _buildFaktorRisiko(double hba1c, double bmi, int gulaDarah) {
    final factors = [
      if (hba1c >= 6.5) 'HbA1c ≥ 6.5% — rentang diabetes'
      else if (hba1c >= 5.7) 'HbA1c 5.7-6.4% — prediabetes',

      if (gulaDarah >= 126) 'Gula puasa ≥ 126 mg/dL — tinggi'
      else if (gulaDarah >= 100) 'Gula puasa 100-125 mg/dL — prediabetes',

      if (bmi >= 27.5) 'BMI ≥ 27.5 — obesitas'
      else if (bmi >= 23) 'BMI 23-27.4 — overweight',

      'Kurang aktivitas fisik harian', // Assume generic default
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Faktor Risiko', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        ...factors.map((f) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.warning_rounded, color: Color(0xFFEF4444), size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(f, style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textMedium, height: 1.5))),
          ]),
        )),
      ]),
    );
  }

  Widget _buildReAssessmentNotification() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.notifications_active_rounded, color: Color(0xFFEF4444), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Waktunya Re-Assessment!',
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF991B1B)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sudah 1 bulan sejak analisis terakhir. Lakukan pengecekan ulang untuk melihat progres kesehatan Anda.',
                  style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFFB91C1C)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
