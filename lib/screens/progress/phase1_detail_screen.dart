import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tabs/phase_ringkasan_tab.dart';
import 'tabs/phase_mingguan_tab.dart';
import 'tabs/phase_target_akhir_tab.dart';
import 'phase2_detail_screen.dart';
import 'phase3_detail_screen.dart';


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
          ? PhaseRingkasanTab(phase: _selectedHeaderTab,): _selectedBodyTab == 1? PhaseMingguanTab(phase: _selectedHeaderTab,)
        : PhaseTargetAkhirTab(
            phase: _selectedHeaderTab,
          ),
          ),
        ),
      ]),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
     decoration: BoxDecoration(
  gradient: LinearGradient(
    colors: _selectedHeaderTab == 0
        ? [
            const Color(0xFF1E88E5),
            const Color(0xFF42A5F5),
          ]
        : _selectedHeaderTab == 1
            ? [
                const Color(0xFF8B5CF6),
                const Color(0xFFA78BFA),
              ]
            : [
                const Color(0xFF10B981),
                const Color(0xFF6EE7B7),
              ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
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
                  Text(
  _selectedHeaderTab == 0
      ? 'Sedang Berjalan'
      : 'Belum Mulai', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                ])),
            ]),
            const SizedBox(height: 24),
           Text(_selectedHeaderTab == 0
      ? 'FASE 1 - Hari 1-30'
      : _selectedHeaderTab == 1
          ? 'FASE 2 - Hari 31-60'
          : 'FASE 3 - Hari 61-90', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withValues(alpha: 0.9))),
            const SizedBox(height: 8),
            Row(children: [
             Text(_selectedHeaderTab == 0
      ? '🌱': _selectedHeaderTab == 1
          ? '⚡'
          : '🏆',style: const TextStyle(fontSize: 24),
),
              const SizedBox(width: 8),
              Text(
  _selectedHeaderTab == 0
      ? 'Stabilisasi Dasar'
      : _selectedHeaderTab == 1 
          ? 'Optimalisasi Metabolik'
          : 'Konsolidasi', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            ]),
            const SizedBox(height: 8),
            Text(
  _selectedHeaderTab == 0
      ? 'Bangun fondasi metabolisme yang sehat'
      : _selectedHeaderTab == 1
          ? 'Tingkatkan sensitivitas insulin dan energi'
          : 'Pertahankan pola hidup sehat jangka panjang', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
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

  return GestureDetector(
    onTap: () {
      setState(() {
        _selectedHeaderTab = index;
      });
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? Colors.white
              : Colors.white.withValues(alpha: 0.2),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight:
              isSelected ? FontWeight.bold : FontWeight.w500,
          color: Colors.white,
        ),
      ),
    ),
  );
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
