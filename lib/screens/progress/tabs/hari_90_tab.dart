import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../phase_detail_screen.dart';

class Hari90Tab extends StatefulWidget {
  const Hari90Tab({super.key});
  @override
  State<Hari90Tab> createState() => _Hari90TabState();
}

class _Hari90TabState extends State<Hari90Tab> {
  final List<bool> _taskToggles = List.generate(6, (_) => false);
  final List<bool> _reminderToggles = List.generate(6, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildIntervensi90Hari(), const SizedBox(height: 24),
      _buildTargetHariIni(), const SizedBox(height: 24),
      _buildFaseIntervensi(), const SizedBox(height: 24),
      _buildLevelXP(), const SizedBox(height: 24),
      _buildTugasHarian(), const SizedBox(height: 24),
      _buildAktivitasChart(), const SizedBox(height: 24),
      _buildReAssessmentBanner(), const SizedBox(height: 24),
      _buildPengingat(), const SizedBox(height: 40),
    ]);
  }

  Widget _buildIntervensi90Hari() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 5))]),
      child: Row(children: [
        SizedBox(width: 70, height: 70, child: Stack(fit: StackFit.expand, children: [
          CircularProgressIndicator(value: 0.05, strokeWidth: 6, backgroundColor: Colors.grey[200], valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5))),
          Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('5%', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            Text('Selesai', style: GoogleFonts.poppins(fontSize: 8, color: AppColors.textMedium)),
          ])),
        ])),
        const SizedBox(width: 20),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Intervensi 90 Hari', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 4),
          Text('Hari ke-5 dari 90', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMedium)),
          const SizedBox(height: 8),
          Text('85 hari tersisa • Fase 1/3', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF1E88E5))),
          const SizedBox(height: 6),
          ClipRRect(borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(value: 0.05, backgroundColor: Colors.grey[200], valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5)), minHeight: 4)),
        ])),
      ]),
    );
  }

  Widget _buildTargetHariIni() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Target Hari Ini', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        Text('Hari 5', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF1E88E5))),
      ]),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(child: _buildTargetCard(icon: '🩸', title: '18g', subtitle: '/ <30g', label: 'Gula', progress: 0.49, percentText: '49%', color: const Color(0xFF1E88E5))),
        const SizedBox(width: 16),
        Expanded(child: _buildTargetCard(icon: '🏃', title: '22 mnt', subtitle: '/ 30 mnt', label: 'Aktivitas', progress: 1.0, percentText: '100%', color: const Color(0xFF06B6D4))),
      ]),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(child: _buildTargetCard(icon: '😴', title: '6.5 jam', subtitle: '/ 8 jam', label: 'Tidur', progress: 0.81, percentText: '81%', color: const Color(0xFFF59E0B))),
        const SizedBox(width: 16),
        Expanded(child: _buildTargetCard(icon: '💧', title: '6 gelas', subtitle: '/ 8 gelas', label: 'Air', progress: 0.75, percentText: '75%', color: const Color(0xFF3B82F6))),
      ]),
    ]);
  }

  Widget _buildTargetCard({required String icon, required String title, required String subtitle, required String label, required double progress, required String percentText, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          Text(percentText, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
        ]),
        const SizedBox(height: 12),
        Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMedium)),
        const SizedBox(height: 12),
        ClipRRect(borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[200], valueColor: AlwaysStoppedAnimation<Color>(color), minHeight: 4)),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMedium)),
      ]),
    );
  }

  Widget _buildFaseIntervensi() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Fase Intervensi', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        const SizedBox(height: 16),
        _buildFaseStep(number: '1', title: 'Stabilisasi Dasar', days: 'Hari 1-30', isActive: true,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PhaseDetailScreen())),
          content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: [_buildFaseChip('📉 <40g'), _buildFaseChip('🏃 20 mnt'), _buildFaseChip('😴 7 jam')]),
            const SizedBox(height: 12),
            Text('Ketuk untuk detail →', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF1E88E5))),
          ])),
        const SizedBox(height: 16),
        _buildFaseStep(number: '2', title: 'Optimalisasi Metabolik', days: 'Hari 31-60', isActive: false, onTap: () {},
          content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [_buildFaseChip('📉 <30g'), _buildFaseChip('🏃 200 mnt'), _buildFaseChip('😴 7.5 jam')]),
            const SizedBox(height: 8),
            Text('Ketuk untuk detail →', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF1E88E5))),
          ])),
        const SizedBox(height: 16),
        _buildFaseStep(number: '3', title: 'Konsolidasi', days: 'Hari 61-90', isActive: false, onTap: () {},
          content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [_buildFaseChip('📉 <25g'), _buildFaseChip('🏃 250 mnt'), _buildFaseChip('😴 8 jam')]),
            const SizedBox(height: 8),
            Text('Ketuk untuk detail →', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF1E88E5))),
          ])),
      ]),
    );
  }

  Widget _buildFaseStep({required String number, required String title, required String days, required bool isActive, required Widget content, VoidCallback? onTap}) {
    return GestureDetector(onTap: onTap, child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? const Color(0xFF1E88E5) : const Color(0xFFF1F5F9), width: isActive ? 1.5 : 1.0),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 36, height: 36,
          decoration: BoxDecoration(color: isActive ? const Color(0xFF1E88E5) : Colors.grey[200], shape: BoxShape.circle),
          child: Center(child: Text(number, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: isActive ? Colors.white : Colors.grey[600])))),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: isActive ? AppColors.textDark : Colors.grey[600])),
            if (isActive) ...[const SizedBox(width: 8),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFF1E88E5), borderRadius: BorderRadius.circular(10)),
                child: Text('AKTIF', style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)))],
          ]),
          Text(days, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500])),
          content,
        ])),
      ]),
    ));
  }

  Widget _buildFaseChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFFFFBEB), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFFDE68A))),
      child: Text(text, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFFD97706))));
  }

  Widget _buildLevelXP() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Level & XP', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFFFFBEB), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFFDE68A))),
            child: Text('⚡ Level 8', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFD97706)))),
        ]),
        const SizedBox(height: 16),
        ClipRRect(borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: 2150 / 2400, backgroundColor: Colors.grey[200], valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)), minHeight: 8)),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('2150 / 2400 XP', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMedium)),
          Text('250 XP lagi ke Level 9', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFFD97706))),
        ]),
      ]),
    );
  }

  Widget _buildTugasHarian() {
    final tasks = [
      {'icon': '🏃', 'title': 'Jalan kaki 30 menit', 'xp': '+20 XP'},
      {'icon': '🩸', 'title': 'Batasi gula < 25g hari ini', 'xp': '+30 XP'},
      {'icon': '💧', 'title': 'Minum air 8 gelas', 'xp': '+15 XP'},
      {'icon': '💊', 'title': 'Konsumsi obat / suplemen', 'xp': '+20 XP'},
      {'icon': '😴', 'title': 'Tidur 7-8 jam malam ini', 'xp': '+25 XP'},
      {'icon': '🥗', 'title': 'Makan sayur + protein tanpa goreng', 'xp': '+30 XP'},
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Tugas Harian', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          Text('82%', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1E88E5))),
        ]),
        const SizedBox(height: 16),
        ...List.generate(tasks.length, (i) {
          final t = tasks[i]; final done = _taskToggles[i];
          return GestureDetector(onTap: () => setState(() => _taskToggles[i] = !_taskToggles[i]),
            child: Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                Container(width: 24, height: 24,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: done ? const Color(0xFF10B981) : Colors.grey[400]!, width: 2), color: done ? const Color(0xFF10B981) : Colors.transparent),
                  child: done ? const Icon(Icons.check, size: 16, color: Colors.white) : null),
                const SizedBox(width: 12),
                Text(t['icon']!, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 12),
                Expanded(child: Text(t['title']!, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: done ? Colors.grey[500] : AppColors.textDark, decoration: done ? TextDecoration.lineThrough : null))),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFFFFBEB), borderRadius: BorderRadius.circular(12)),
                  child: Text(t['xp']!, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFFD97706)))),
              ])));
        }),
      ]),
    );
  }

  Widget _buildAktivitasChart() {
    final data = [40.0, 65.0, 30.0, 75.0, 45.0, 60.0, 40.0];
    final labels = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Aktivitas 7 Hari Terakhir', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(7, (i) => Column(children: [
            Container(width: 32, height: data[i], decoration: BoxDecoration(color: const Color(0xFF60A5FA), borderRadius: BorderRadius.circular(6))),
            const SizedBox(height: 8),
            Text(labels[i], style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500])),
          ]))),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Rendah', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500])),
          Text('Menit aktif/hari', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF1E88E5))),
          Text('Tinggi', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500])),
        ]),
      ]),
    );
  }

  Widget _buildReAssessmentBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFFFFBEB), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFFDE68A))),
      child: Row(children: [
        const Icon(Icons.sync_rounded, color: Color(0xFFD97706), size: 24),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Re-Assessment Metabolik', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1F2937))),
          Text('Belum pernah assessment', style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFFD97706))),
        ])),
        const Icon(Icons.chevron_right_rounded, color: Color(0xFFD97706)),
      ]),
    );
  }

  Widget _buildPengingat() {
    final reminders = [
      {'icon': '☀️', 'title': 'Cek pagi', 'subtitle': 'Log glukosa & berat badan', 'time': '07:00'},
      {'icon': '🏃', 'title': 'Olahraga', 'subtitle': 'Pengingat aktivitas fisik', 'time': '07:30'},
      {'icon': '🥗', 'title': 'Makan Sehat', 'subtitle': 'Pilihan makan siang sehat', 'time': '12:00'},
      {'icon': '💊', 'title': 'Suplemen', 'subtitle': 'Konsumsi suplemen harian', 'time': '20:00'},
      {'icon': '😴', 'title': 'Waktu Tidur', 'subtitle': 'Istirahat untuk metabolisme', 'time': '22:00'},
      {'icon': '💧', 'title': 'Minum Air', 'subtitle': 'Target 8 gelas per hari', 'time': '10:00'},
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Pengingat', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          Text('6 aktif', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF1E88E5))),
        ]),
        const SizedBox(height: 16),
        ...List.generate(reminders.length, (i) {
          final r = reminders[i]; final isOn = _reminderToggles[i];
          return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey[100]!), borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                child: Center(child: Text(r['icon']!, style: const TextStyle(fontSize: 20)))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r['title']!, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                Text(r['subtitle']!, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500])),
              ])),
              Text(r['time']!, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400])),
              const SizedBox(width: 12),
              Switch(value: isOn, onChanged: (v) => setState(() => _reminderToggles[i] = v), activeColor: const Color(0xFF1E88E5)),
            ]));
        }),
      ]),
    );
  }
}
