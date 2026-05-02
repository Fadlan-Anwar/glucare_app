import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhaseTargetAkhirTab extends StatelessWidget {
  const PhaseTargetAkhirTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 16),
      // Target Akhir Fase 1
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 40, height: 40, decoration: const BoxDecoration(color: Color(0xFFEFF6FF), shape: BoxShape.circle),
              child: const Center(child: Icon(Icons.track_changes_outlined, color: Color(0xFF3B82F6), size: 24))),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('PENCAPAIAN FASE 1', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey[400])),
              Text('Target Akhir Fase 1', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF1F2937))),
            ]),
          ]),
          const SizedBox(height: 20),
          _buildTargetListItem('1', 'Gula darah puasa < 110 mg/dL'),
          _buildTargetListItem('2', 'Berat turun 1-2 kg'),
          _buildTargetListItem('3', 'Konsisten olahraga'),
          _buildTargetListItem('4', 'Tidak ada minuman manis 7 hari berturut turut'),
        ]),
      ),
      const SizedBox(height: 24),
      // Perjalanan 90 Hari
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Perjalanan 90 Hari', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF1F2937))),
          const SizedBox(height: 20),
          _buildTimelineStep(number: '1', title: '🌱 Stabilisasi Dasar', subtitle: 'Hari 1-30 • Gula ≤ 40g/hari', isActive: true, isLast: false),
          _buildTimelineStep(number: '2', title: '⚡ Optimasi Metabolik', subtitle: 'Hari 31-60 • Gula ≤ 30g/hari', isActive: false, isLast: false),
          _buildTimelineStep(number: '3', title: '🏆 Konsolidasi', subtitle: 'Hari 61-90 • Gula ≤ 25g/hari', isActive: false, isLast: true),
        ]),
      ),
      const SizedBox(height: 24),
      // Setelah 90 Hari
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.shield_outlined, color: Color(0xFF3B82F6), size: 20),
            const SizedBox(width: 8),
            Text('Setelah 90 Hari', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF3B82F6))),
          ]),
          const SizedBox(height: 16),
          Text('Penelitian DPP (Diabetes Prevention Program) membuktikan bahwa intervensi gaya hidup terstruktur selama 2-3 bulan dapat mengurangi risiko progresi prediabetes ke diabetes sebesar 58% — lebih efektif dari obat metformin (31%).',
            style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF475569), height: 1.5)),
          const SizedBox(height: 16),
          Wrap(spacing: 8, runSpacing: 8, children: [
            _buildStatTag('↓ 58% risiko'),
            _buildStatTag('↓ HbA1c < 5.7%'),
            _buildStatTag('↑ Kualitas hidup'),
          ]),
        ]),
      ),
      const SizedBox(height: 24),
      // Button
      SizedBox(width: double.infinity,
        child: OutlinedButton(onPressed: () {},
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16),
            side: const BorderSide(color: Color(0xFF8B5CF6), width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Lihat Fase 2: Optimasi Metabolik', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF8B5CF6))),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, color: Color(0xFF8B5CF6), size: 16),
          ]))),
      const SizedBox(height: 40),
    ]);
  }

  Widget _buildTargetListItem(String number, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Row(children: [
        Container(width: 24, height: 24, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Center(child: Text(number, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[400])))),
        const SizedBox(width: 16),
        Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF334155)))),
      ]),
    );
  }

  Widget _buildTimelineStep({required String number, required String title, required String subtitle, required bool isActive, required bool isLast}) {
    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Column(children: [
          Container(width: 32, height: 32,
            decoration: BoxDecoration(color: isActive ? const Color(0xFF1E88E5) : const Color(0xFFF1F5F9), shape: BoxShape.circle),
            child: Center(child: isActive
                ? const Icon(Icons.circle, color: Colors.white, size: 12)
                : Text(number, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500])))),
          if (!isLast) Expanded(child: Container(width: 2, color: const Color(0xFFE2E8F0), margin: const EdgeInsets.symmetric(vertical: 4))),
        ]),
        const SizedBox(width: 16),
        Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 24),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: isActive ? const Color(0xFF1F2937) : Colors.grey[500])),
                if (isActive) ...[
                  const SizedBox(width: 8),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(4)),
                    child: Text('INI', style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: const Color(0xFF3B82F6)))),
                ],
              ]),
              const SizedBox(height: 4),
              Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[400])),
            ])),
            Icon(Icons.chevron_right, color: Colors.grey[300], size: 20),
          ]))),
      ]),
    );
  }

  Widget _buildStatTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF3B82F6))),
    );
  }
}
