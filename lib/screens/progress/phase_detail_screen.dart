import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tabs/phase_ringkasan_tab.dart';
import 'tabs/phase_mingguan_tab.dart';
import 'tabs/phase_target_akhir_tab.dart';

class PhaseDetailScreen extends StatefulWidget {
  const PhaseDetailScreen({super.key});
  @override
  State<PhaseDetailScreen> createState() => _PhaseDetailScreenState();
}

class _PhaseDetailScreenState extends State<PhaseDetailScreen> {
  int _selectedHeaderTab = 0;
  int _selectedBodyTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _buildHeader(context),
        _buildBodyTabs(),
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _selectedBodyTab == 0
                ? const PhaseRingkasanTab()
                : _selectedBodyTab == 1
                    ? const PhaseMingguanTab()
                    : const PhaseTargetAkhirTab(),
          ),
        ),
      ]),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: SafeArea(bottom: false,
        child: Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              GestureDetector(onTap: () => Navigator.maybePop(context),
                child: Container(padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.chevron_left, color: Colors.white))),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                child: Row(children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFFDE047), shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text('Sedang Berjalan', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                ])),
            ]),
            const SizedBox(height: 24),
            Text('FASE 1 - Hari 1-30', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withValues(alpha: 0.9))),
            const SizedBox(height: 8),
            Row(children: [
              const Text('🌱', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text('Stabilisasi Dasar', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            ]),
            const SizedBox(height: 8),
            Text('Bangun fondasi metabolisme yang sehat', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(child: _buildHeaderTab(0, 'Fase 1')),
              const SizedBox(width: 12),
              Expanded(child: _buildHeaderTab(1, 'Fase 2')),
              const SizedBox(width: 12),
              Expanded(child: _buildHeaderTab(2, 'Fase 3')),
            ]),
          ])),
      ),
    );
  }

  Widget _buildHeaderTab(int index, String text) {
    final isSelected = _selectedHeaderTab == index;
    return GestureDetector(onTap: () => setState(() => _selectedHeaderTab = index),
      child: Container(padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.2))),
        alignment: Alignment.center,
        child: Text(text, style: GoogleFonts.poppins(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: Colors.white))));
  }

  Widget _buildBodyTabs() {
    return Padding(padding: const EdgeInsets.all(20),
      child: Row(children: [
        _buildBodyTab(0, 'Ringkasan'),
        const SizedBox(width: 12),
        _buildBodyTab(1, 'Mingguan'),
        const SizedBox(width: 12),
        _buildBodyTab(2, 'Target Akhir'),
      ]));
  }

  Widget _buildBodyTab(int index, String text) {
    final isSelected = _selectedBodyTab == index;
    return GestureDetector(onTap: () => setState(() => _selectedBodyTab = index),
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E88E5) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey[200]!)),
        child: Text(text, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : Colors.grey[600]))));
  }
}
