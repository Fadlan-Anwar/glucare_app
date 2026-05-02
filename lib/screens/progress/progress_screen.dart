import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tabs/hari_90_tab.dart';
import 'tabs/pencapaian_tab.dart';
import 'tabs/evaluasi_tab.dart';

/// Konten tab Progres — tanpa bottomNav sendiri.
class ProgressContent extends StatefulWidget {
  const ProgressContent({super.key});

  @override
  State<ProgressContent> createState() => _ProgressContentState();
}

class _ProgressContentState extends State<ProgressContent> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabs(),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _selectedTabIndex == 0
                  ? const Hari90Tab()
                  : _selectedTabIndex == 1
                      ? const PencapaianTab()
                      : const EvaluasiTab(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progres & Evaluasi',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pantau intervensi metabolik harianmu',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildHeaderMetricCard('🔥', '1 hari', 'Streak')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildHeaderMetricCard('⚡', '8', 'Level')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildHeaderMetricCard('🏅', '4', 'Pencapaian')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderMetricCard(String emoji, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
        children: [
          _buildTab(0, '📅 90 Hari'),
          const SizedBox(width: 12),
          _buildTab(1, '🏆 Pencapaian'),
          const SizedBox(width: 12),
          _buildTab(2, '🎯 Evaluasi'),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String text) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1D4ED8) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
