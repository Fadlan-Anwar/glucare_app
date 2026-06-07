import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClinicalModeScreen extends StatefulWidget {
  const ClinicalModeScreen({super.key});

  @override
  State<ClinicalModeScreen> createState() => _ClinicalModeScreenState();
}

class _ClinicalModeScreenState extends State<ClinicalModeScreen> {
  final TextEditingController _hba1cController = TextEditingController(text: '5.9');
  final TextEditingController _gulaDarahController = TextEditingController(text: '108');
  final TextEditingController _beratBadanController = TextEditingController(text: '72');
  final TextEditingController _tinggiBadanController = TextEditingController(text: '168');

  String _riwayatKeluarga1 = 'Ya';
  String _riwayatKeluarga2 = 'Ya';

  @override
  void dispose() {
    _hba1cController.dispose();
    _gulaDarahController.dispose();
    _beratBadanController.dispose();
    _tinggiBadanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Masukkan hasil pemeriksaan laboratorium terbaru Anda.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLabResultsCard(),
                  const SizedBox(height: 16),
                  _buildFamilyHistoryCard1(),
                  const SizedBox(height: 16),
                  _buildFamilyHistoryCard2(),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to result screen with arguments
                        Navigator.pushNamed(
                          context, 
                          '/analysis-result',
                          arguments: {
                            'isLab': true,
                            'hba1c': double.tryParse(_hba1cController.text) ?? 5.9,
                            'gulaDarah': int.tryParse(_gulaDarahController.text) ?? 108,
                            'berat': double.tryParse(_beratBadanController.text) ?? 72,
                            'tinggi': double.tryParse(_tinggiBadanController.text) ?? 168,
                            'riwayatKeluarga': _riwayatKeluarga1 == 'Ya' || _riwayatKeluarga2 == 'Ya',
                            'riwayatKeluargaText': _riwayatKeluarga1,
                            'riwayatDiabetesText': _riwayatKeluarga2,
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Analisis Sekarang',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
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
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (Navigator.canPop(context))
                        GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: Container(
                            margin: const EdgeInsets.only(right: 16),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          'Data Klinis',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Masukkan data untuk analisis Ai',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
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

  Widget _buildLabResultsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(
            title: 'HbA1c (%)',
            controller: _hba1cController,
            suffix: '%',
            subtext: 'Normal < 5.7% · Prediabetes 5.7-6.4% · DM ≥ 6.5%',
          ),
          const SizedBox(height: 20),
          _buildInputField(
            title: 'Gula Darah Puasa (mg/dL)',
            controller: _gulaDarahController,
            suffix: 'mg/dl',
            subtext: 'Normal < 100 · Prediabetes 100-125 · DM ≥ 126',
          ),
          const SizedBox(height: 20),
          _buildInputField(
            title: 'Berat Badan (kg)',
            controller: _beratBadanController,
            suffix: 'kg',
            subtext: 'Untuk kalkulasi BMI',
          ),
          const SizedBox(height: 20),
          _buildInputField(
            title: 'Tinggi Badan (cm)',
            controller: _tinggiBadanController,
            suffix: 'cm',
            subtext: 'BMI Asia: Normal < 23 · Overweight 23-27.4 · Obese ≥ 27.5',
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String title,
    required TextEditingController controller,
    required String suffix,
    required String subtext,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey[500],
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    isDense: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  suffix,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtext,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildFamilyHistoryCard1() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Riwayat Keluarga Diabetes',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildSelectOption1('Ya')),
              const SizedBox(width: 8),
              Expanded(child: _buildSelectOption1('Tidak')),
              const SizedBox(width: 8),
              Expanded(child: _buildSelectOption1('Tidak Tahu')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectOption1(String text) {
    final isSelected = _riwayatKeluarga1 == text;
    return GestureDetector(
      onTap: () => setState(() => _riwayatKeluarga1 = text),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFBFDBFE) : Colors.transparent,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF334155),
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyHistoryCard2() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pernah Didiagnosis Hipertensi',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildSelectOption2('Ya')),
              const SizedBox(width: 8),
              Expanded(child: _buildSelectOption2('Tidak')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectOption2(String text) {
    final isSelected = _riwayatKeluarga2 == text;
    return GestureDetector(
      onTap: () => setState(() => _riwayatKeluarga2 = text),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFBFDBFE) : Colors.transparent,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFF334155),
          ),
        ),
      ),
    );
  }
}
