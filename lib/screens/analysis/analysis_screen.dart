import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import 'clinical_mode_screen.dart';
import 'questionnaire_screen.dart';

class AnalysisContent extends StatelessWidget {
  const AnalysisContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Stack(
              children: [
                // Scrollable Content
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildKlinisCard(context),
                      const SizedBox(height: 16),
                      _buildKuesionerCard(context),
                      // Add extra padding at the bottom so content can be scrolled above the illustration if needed
                      const SizedBox(height: 150), 
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analisis Risiko',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pilih metode untuk menghitung skor risikomu',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKlinisCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ClinicalModeScreen()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16), // Agak kecil
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46, // Agak kecil
                  height: 46, // Agak kecil
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.science_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mode Klinis / Lab',
                        style: GoogleFonts.poppins(
                          fontSize: 15, // Agak kecil
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Input hasil lab untuk analisis paling akurat',
                        style: GoogleFonts.poppins(
                          fontSize: 11, // Agak kecil
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _buildChip('Usia', const Color(0xFFDBEAFE), const Color(0xFF1D4ED8)),
                _buildChip('IMT', const Color(0xFFDBEAFE), const Color(0xFF1D4ED8)),
                _buildChip('Gula Darah', const Color(0xFFDBEAFE), const Color(0xFF1D4ED8)),
                _buildChip('Tekanan darah', const Color(0xFFDBEAFE), const Color(0xFF1D4ED8)),
                _buildChip('Kolestrol', const Color(0xFFDBEAFE), const Color(0xFF1D4ED8)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.check_box_rounded, color: Color(0xFF10B981), size: 14),
                const SizedBox(width: 6),
                Text(
                  'Akurasi tertinggi — direkomendasikan',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKuesionerCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const QuestionnaireScreen()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16), // Agak kecil
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46, // Agak kecil
                  height: 46, // Agak kecil
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.assignment_rounded, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mode Kuesioner',
                        style: GoogleFonts.poppins(
                          fontSize: 15, // Agak kecil
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Jawab pertanyaan gaya hidup untuk pemeriksaan cepat',
                        style: GoogleFonts.poppins(
                          fontSize: 11, // Agak kecil
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _buildChip('Pola hidup', const Color(0xFFF3E8FF), const Color(0xFF6D28D9)),
                _buildChip('Pola makan', const Color(0xFFF3E8FF), const Color(0xFF6D28D9)),
                _buildChip('Gejala', const Color(0xFFF3E8FF), const Color(0xFF6D28D9)),
                _buildChip('Aktivitas', const Color(0xFFF3E8FF), const Color(0xFF6D28D9)),
                _buildChip('Keluarga', const Color(0xFFF3E8FF), const Color(0xFF6D28D9)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.description_outlined, color: Color(0xFF6D28D9), size: 14),
                const SizedBox(width: 6),
                Text(
                  'Cocok tanpa data lab',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6D28D9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // Agak kecil
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 10, // Agak kecil
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
