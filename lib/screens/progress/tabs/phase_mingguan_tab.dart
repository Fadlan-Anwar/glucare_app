import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhaseMingguanTab extends StatelessWidget {
  const PhaseMingguanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Setiap minggu memiliki tema dan 4 tugas spesifik. Ketuk untuk melihat detail.',
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        _buildMingguCard('W1', 'Minggu 1', 'Mulai & Ukur'),
        _buildMingguCard('W2', 'Minggu 2', 'Bangun Kebiasaan'),
        _buildMingguCard('W3', 'Minggu 3', 'Tingkatkan Konsistensi'),
        _buildMingguCard('W4', 'Minggu 4', 'Evaluasi & Perkuat'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F9FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0F2FE)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Text('💡', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text('Tips Konsistensi', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF0284C7))),
            ]),
            const SizedBox(height: 8),
            Text(
              'Lakukan tugas di waktu yang sama setiap hari. Pemasangan kebiasaan baru dengan rutinitas lama (habit stacking) meningkatkan keberhasilan 3x lipat.',
              style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF334155), height: 1.5),
            ),
          ]),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildMingguCard(String w, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text(w, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF94A3B8)))),
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1F2937))),
          Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500])),
        ])),
        Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey[300]),
      ]),
    );
  }
}
