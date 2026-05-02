import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class EvaluasiTab extends StatelessWidget {
  const EvaluasiTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildPerbandinganRisiko(),
      const SizedBox(height: 24),
      _buildMetrikMetabolik(),
      const SizedBox(height: 24),
      _buildFaktorRisiko(),
      const SizedBox(height: 32),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {},
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

  Widget _buildPerbandinganRisiko() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Perbandingan Risiko', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _buildRisikoCard(title: 'Sekarang', percentage: '93%', status: 'Tinggi', date: '2026-04-11', progressColor: const Color(0xFFDC2626), progressValue: 0.93, isCurrent: true)),
          const SizedBox(width: 16),
          Expanded(child: _buildRisikoCard(title: 'Sebelumnya', percentage: '96%', status: 'Tinggi', date: '2026-04-11', progressColor: const Color(0xFFDC2626), progressValue: 0.96, isCurrent: false)),
        ]),
        const SizedBox(height: 16),
        Container(
          width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(12)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.check_box_rounded, color: Color(0xFF10B981), size: 18),
            const SizedBox(width: 8),
            Text('Skor turun 3 poin — ada perbaikan!', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF10B981))),
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

  Widget _buildMetrikMetabolik() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Metrik Metabolik', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 16),
        _buildMetrikRow('Usia Metabolik', 'vs. usia 42', '42 tahun'),
        const Divider(height: 24, thickness: 1, color: Color(0xFFF1F5F9)),
        _buildMetrikRow('Risiko 5 Tahun', 'probabilitas progresi', '51%'),
        const Divider(height: 24, thickness: 1, color: Color(0xFFF1F5F9)),
        _buildMetrikRow('Mode Assessment', '2026-04-11', 'Kuesioner'),
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

  Widget _buildFaktorRisiko() {
    final factors = [
      'Riwayat keluarga berisiko',
      'Sedentary lifestyle',
      'Konsumsi gula sangat tinggi',
      'Gejala hiperglikemia perlu diperiksa',
      'Kualitas tidur sangat buruk',
      'Stres tinggi (meningkatkan kortisol & resistensi insulin)',
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
}
