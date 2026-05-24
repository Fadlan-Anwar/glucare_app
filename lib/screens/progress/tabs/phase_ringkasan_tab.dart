import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhaseRingkasanTab extends StatelessWidget {
  final int phase;

  late final Map<String, dynamic> data;

  PhaseRingkasanTab({
  super.key,
  required this.phase,
}) {
  if (phase == 1) {
    data = {
      'title': 'Dasar Ilmiah Fase 2',
      'description':
          'Di fase ini, tubuh sudah memiliki fondasi. Kita tingkatkan intensitas untuk memaksimalkan GLUT4 (transporter glukosa) di otot rangka. Latihan kekuatan 2x/minggu meningkatkan penyerapan glukosa otot hingga 35% (JCEM, 2022).',

      'target1': '≤ 30g/hari',
      'target2': 'Workout 45 menit',
      'target3': '8 jam tidur',
      'target4': '3L air putih',

      'fokus1': 'Intermittent Fasting',
      'fokus2': 'High Protein',
      'fokus3': 'Workout Konsisten',
      'fokus4': 'Recovery Tubuh',
    };
  } else if (phase == 2) {
    data = {
      'title': 'Dasar Ilmiah Fase 3',
      'description':
          'Penelitian menunjukkan perlu 66 hari rata-rata untuk membentuk kebiasaan baru secara neurokognitif (European Journal of Social Psychology). Fase 3 adalah "semen" yang mengunci perubahan positif menjadi autopilot.',

      'target1': '≤ 25g/hari',
      'target2': 'HIIT/Cardio',
      'target3': 'Tidur Stabil',
      'target4': 'Maintain Weight',

      'fokus1': 'Healthy Lifestyle',
      'fokus2': 'Recovery',
      'fokus3': 'Maintain Progress',
      'fokus4': 'Konsistensi',
    };
  } else {
    data = {
      'title': 'Dasar Ilmiah Fase 1',
      'description':
          'Fase pertama berfokus pada memutus siklus resistensi insulin kronis.',

      'target1': '≤ 40g/hari',
      'target2': '150 mnt/minggu',
      'target3': '7 jam/malam',
      'target4': '8 gelas/hari',

      'fokus1': 'Stop Minuman Manis',
      'fokus2': 'Kurangi Gula',
      'fokus3': 'Konsisten Waktu Makan',
      'fokus4': 'Log Makanan',
    };
  }
}

  @override
  Widget build(BuildContext context) {

   Map<String, dynamic> data;

if (phase == 1) {
  data = {
    'title': 'Dasar Ilmiah Fase 2',
    'description':
        'Fase kedua fokus meningkatkan metabolisme dan energi tubuh.',

    'target1': '≤ 30g/hari',
    'target2': 'Workout 45 menit',
    'target3': '8 jam tidur',
    'target4': '3L air putih',

    'fokus1': 'Intermittent Fasting',
    'fokus2': 'High Protein',
    'fokus3': 'Workout Konsisten',
    'fokus4': 'Recovery Tubuh',
  };
} else if (phase == 2) {
  data = {
    'title': 'Dasar Ilmiah Fase 3',
    'description':
        'Fase ketiga fokus mempertahankan hasil dan konsistensi.',

    'target1': '≤ 25g/hari',
    'target2': 'HIIT/Cardio',
    'target3': 'Tidur Stabil',
    'target4': 'Maintain Weight',

    'fokus1': 'Healthy Lifestyle',
    'fokus2': 'Recovery',
    'fokus3': 'Maintain Progress',
    'fokus4': 'Konsistensi',
  };
} else {
  data = {
    'title': 'Dasar Ilmiah Fase 1',
    'description':
        'Fase pertama berfokus pada memutus siklus resistensi insulin kronis.',

    'target1': '≤ 40g/hari',
    'target2': '150 mnt/minggu',
    'target3': '7 jam/malam',
    'target4': '8 gelas/hari',

    'fokus1': 'Stop Minuman Manis',
    'fokus2': 'Kurangi Gula',
    'fokus3': 'Konsisten Waktu Makan',
    'fokus4': 'Log Makanan',
  };
}
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 16),
      _buildDasarIlmiah(),
      const SizedBox(height: 24),
      _buildTargetHarian(),
      const SizedBox(height: 24),
      _buildFokusUtama(),
      const SizedBox(height: 24),
      _buildReAssessmentBtn(),
      const SizedBox(height: 40),
    ]);
  }

  Widget _buildDasarIlmiah() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF0F9FF), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE0F2FE))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.science_outlined, color: Color(0xFF0284C7), size: 18),
          const SizedBox(width: 8),
          Text(data['title'], style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF0284C7))),
        ]),
        const SizedBox(height: 12),
        Text(data['description'], style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF334155), height: 1.5)),
      ]),
    );
  }

  Widget _buildTargetHarian() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Target Harian', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1F2937))),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(child: _buildTargetCard(icon: '🍬', title: 'Gula Harian', value: data['target1'],subtitle: 'Kurangi bertahap dari kebiasaan')),
        const SizedBox(width: 16),
        Expanded(child: _buildTargetCard(icon: '🏃♂️', title: 'Aktivitas',value: data['target2'],subtitle: 'Kurangi 10g dari fase sebelumnya')),
      ]),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(child: _buildTargetCard(icon: '😴', title: 'Tidur',value: data['target3'],subtitle: 'Jadwal tidur konsisten')),
        const SizedBox(width: 16),
        Expanded(child: _buildTargetCard(icon: '💧', title: 'Air Putih', value: data['target4'],subtitle: 'Hidrasi optimal untuk metabolisme')),
      ]),
    ]);
  }

  Widget _buildTargetCard({required String icon, required String title, required String value, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 8),
        Text(title, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500])),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1F2937))),
        const SizedBox(height: 6),
        Text(subtitle, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[400], height: 1.3)),
      ]),
    );
  }

  Widget _buildFokusUtama() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Fokus Utama', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1F2937))),
      const SizedBox(height: 16),
      _buildFokusItem(icon: '🍬', title: data['fokus1'], subtitle: '↓ 40% spike gula', color: const Color(0xFF3B82F6), bgColor: const Color(0xFFEFF6FF)),
      _buildFokusItem(icon: '🥤', title: data['fokus2'], subtitle: '↓ 26% risiko T2DM', color: const Color(0xFF10B981), bgColor: const Color(0xFFECFDF5)),
      _buildFokusItem(icon: '⏰', title: data['fokus3'], subtitle: '↑ Ritme Insulin', color: const Color(0xFF8B5CF6), bgColor: const Color(0xFFF5F3FF)),
      _buildFokusItem(icon: '📖', title: data['fokus4'], subtitle: '↑ Kesadaran pola makan', color: const Color(0xFFF59E0B), bgColor: const Color(0xFFFFFBEB)),
    ]);
  }

  Widget _buildFokusItem({required String icon, required String title, required String subtitle, required Color color, required Color bgColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: ClipRRect(borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(border: Border(left: BorderSide(color: color, width: 4))),
          child: Padding(padding: const EdgeInsets.all(16),
            child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Center(child: Text(icon, style: const TextStyle(fontSize: 18)))),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF1F2937))),
                Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
              ])),
              Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey[400]),
            ])),
        ),
      ),
    );
  }

  Widget _buildReAssessmentBtn() {
    return SizedBox(width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B82F6), padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
        icon: const Icon(Icons.sync_rounded, color: Colors.white),
        label: Text('Lakukan Re-Assessment', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}
