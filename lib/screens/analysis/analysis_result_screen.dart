import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/dashboard_screen.dart';
import '../auth/auth_service.dart';
import '../auth/auth_provider.dart';

class AnalysisResultScreen extends ConsumerStatefulWidget {
  // Keeping constructor matching main.dart for compatibility, but ignoring values
  final double? hba1c;
  final int? gulaDarah;
  final double? berat;
  final double? tinggi;

  const AnalysisResultScreen({
    super.key,
    this.hba1c,
    this.gulaDarah,
    this.berat,
    this.tinggi,
  });

  @override
  ConsumerState<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends ConsumerState<AnalysisResultScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performAnalysisAndSave();
    });
  }

  Future<void> _performAnalysisAndSave() async {
    final startTime = DateTime.now();

    try {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final authService = AuthService();

      if (args != null) {
        if (args['isKuesioner'] == true) {
          // Send questionnaire data to Express backend
          await authService.submitKuesionerData(
            usia: args['usia'] ?? '',
            riwayatKeluarga: args['riwayatKeluargaText'] ?? '',
            olahraga: args['olahragaText'] ?? '',
            makananManis: args['makananManisText'] ?? '',
            lingkarPinggang: args['beratBadanText'] ?? '', // Mapping weight text to lingkar_pinggang as a proxy
            gejalaDiabetes: args['gejalaText'] ?? '', // Mapping lifestyle text to gejala_diabetes
            jamTidur: args['tidurText'] ?? '',
            tingkatStress: args['hipertensiText'] ?? '', // Mapping hypertension text to tingkat_stress
          );
        } else if (args['isLab'] == true) {
          // Send lab data to Express backend
          await authService.submitLabData(
            hba1c: args['hba1c'] as double? ?? 5.9,
            gulaDarahPuasa: args['gulaDarah'] as int? ?? 108,
            beratBadan: args['berat'] as double? ?? 72.0,
            tinggiBadan: args['tinggi'] as double? ?? 168.0,
            riwayatKeluarga: args['riwayatKeluargaText'] ?? 'Ya',
            riwayatDiabetes: args['riwayatDiabetesText'] ?? 'Ya',
          );
        }
      }
      ref.invalidate(latestLabResultProvider);
      ref.invalidate(latestAnalysisProvider);
    } catch (e) {
      debugPrint("Error saving assessment to backend: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Analisis berhasil, namun gagal sinkronisasi ke server: $e"),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }

    // Ensure the loading animation runs for at least 2.5 seconds
    final elapsed = DateTime.now().difference(startTime);
    final remaining = const Duration(milliseconds: 2500) - elapsed;
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Menganalisis Data Anda...',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'AI sedang memproses indikator klinis\ndan riwayat kesehatan Anda',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    int score = 0;
    double hba1c = 5.0;
    double bmi = 21.0;
    int gulaDarah = 90;
    bool riwayatKeluarga = true;

    final isKuesioner = args?['isKuesioner'] == true;

    if (isKuesioner) {
      int kuesionerPoints = 0;
      
      final usia = args?['usia']?.toString();
      if (usia == '30-39 tahun') kuesionerPoints += 10;
      else if (usia == '40+ tahun') kuesionerPoints += 20;
      
      final riwayat = args?['riwayatKeluargaText']?.toString();
      if (riwayat == 'Ya, kakek/nenek') kuesionerPoints += 5;
      else if (riwayat == 'Ya, orang tua' || riwayat == 'Ya, saudara kandung') kuesionerPoints += 10;
      
      final beratText = args?['beratBadanText']?.toString();
      if (beratText == 'Sedikit kelebihan') kuesionerPoints += 10;
      else if (beratText == 'Kelebihan berat badan') kuesionerPoints += 15;
      else if (beratText == 'Obesitas') kuesionerPoints += 20;
      
      final olahraga = args?['olahragaText']?.toString();
      if (olahraga == '1–2x per minggu') kuesionerPoints += 5;
      else if (olahraga == 'Jarang sekali') kuesionerPoints += 10;
      else if (olahraga == 'Tidak pernah') kuesionerPoints += 15;
      
      final makanan = args?['makananManisText']?.toString();
      if (makanan == 'Cukup sehat') kuesionerPoints += 5;
      else if (makanan == 'Sering makan cepat saji') kuesionerPoints += 10;
      else if (makanan == 'Banyak gula & gorengan') kuesionerPoints += 15;
      
      final tidur = args?['tidurText']?.toString();
      if (tidur == '5–6 jam') kuesionerPoints += 5;
      else if (tidur == 'Kurang dari 5 jam' || tidur == 'Tidak teratur') kuesionerPoints += 10;
      
      final stress = args?['hipertensiText']?.toString();
      if (stress == 'Ya') kuesionerPoints += 10;
      
      final gejala = args?['gejalaText']?.toString();
      if (gejala == 'Kadang-kadang') kuesionerPoints += 5;
      else if (gejala == 'Salah satu rutin') kuesionerPoints += 10;
      else if (gejala == 'Keduanya rutin') kuesionerPoints += 15;
      
      score = ((kuesionerPoints / 115) * 100).round();
      if (score > 100) score = 100;
      
      // Map proxy values for UI cards in result screen
      hba1c = score >= 60 ? 6.5 : (score >= 30 ? 5.9 : 5.0);
      gulaDarah = score >= 60 ? 130 : (score >= 30 ? 110 : 90);
      bmi = beratText == 'Obesitas' ? 30.0 : (beratText == 'Kelebihan berat badan' ? 26.0 : (beratText == 'Sedikit kelebihan' ? 24.0 : 21.0));
      riwayatKeluarga = riwayat == 'Ya, kakek/nenek' || riwayat == 'Ya, orang tua' || riwayat == 'Ya, saudara kandung';
    } else {
      final double rawHba1c = args?['hba1c'] as double? ?? widget.hba1c ?? 5.9;
      final int rawGulaDarah = args?['gulaDarah'] as int? ?? widget.gulaDarah ?? 108;
      final double rawBerat = args?['berat'] as double? ?? widget.berat ?? 72.0;
      final double rawTinggi = args?['tinggi'] as double? ?? widget.tinggi ?? 168.0;
      final bool rawRiwayatKeluarga = args?['riwayatKeluarga'] as bool? ?? true;
      
      hba1c = rawHba1c;
      gulaDarah = rawGulaDarah;
      riwayatKeluarga = rawRiwayatKeluarga;
      
      final tinggiM = rawTinggi / 100;
      bmi = rawBerat / (tinggiM * tinggiM);

      if (hba1c >= 6.5) score += 40;
      else if (hba1c >= 5.7) score += 20;

      if (gulaDarah >= 126) score += 30;
      else if (gulaDarah >= 100) score += 15;

      if (bmi >= 27.5) score += 20;
      else if (bmi >= 23) score += 10;

      if (riwayatKeluarga) score += 10;
      if (score > 100) score = 100;
    }

    String riskStatus = 'Normal';
    Color riskColor = const Color(0xFF10B981); // Green
    if (score >= 60) {
      riskStatus = 'Tinggi';
      riskColor = const Color(0xFFEF4444); // Red
    } else if (score >= 30) {
      riskStatus = 'Sedang';
      riskColor = const Color(0xFFF59E0B); // Orange
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Container(
              color: const Color(0xFFF8F9FB),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildRiskCard(score, riskStatus, riskColor),
                    const SizedBox(height: 16),
                    _buildRiskFactorsCard(hba1c, bmi, gulaDarah, riwayatKeluarga),
                    const SizedBox(height: 16),
                    _buildLabInterpretationCard(hba1c, bmi, gulaDarah),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to progress/intervention screen
                        DashboardContent.hasRiskDataNotifier.value = true;
                        DashboardContent.analysisDataNotifier.value = {
                          'score': score,
                          'riskStatus': riskStatus,
                          'riskColor': riskColor,
                          'hba1c': hba1c,
                          'bmi': bmi,
                          'gulaDarah': gulaDarah,
                        };
                        Navigator.pushNamedAndRemoveUntil(context, '/recommendation', (route) => false);
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
                        'Lihat Rencana Intervensi',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Assessment Ulang',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hasil Analisis',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Skor risiko prediabetes personalmu',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskCard(int score, String riskStatus, Color riskColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: riskColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            score >= 60 ? Icons.warning_rounded : (score >= 30 ? Icons.info_outline_rounded : Icons.check_circle_outline_rounded),
            color: riskColor,
            size: 64,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$score',
                style: GoogleFonts.poppins(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: riskColor,
                ),
              ),
              Text(
                '%',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: riskColor,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: riskColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Risiko $riskStatus',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: riskColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            score >= 60 
                ? 'Indikasi Prediabetes/Diabetes'
                : (score >= 30 ? 'Peringatan: Pola hidup perlu diperbaiki' : 'Risiko sangat rendah. Pertahankan!'),
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 100.0,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(riskColor),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildMetricBox('30 thn', 'Usia Kronologis', riskColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricBox('${30 + (score / 10).round()} thn', 'Usia Metabolik', riskColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricBox('${(score * 0.6).round()}%', 'Risiko 5 Thn', riskColor),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            score >= 60 
                ? 'Segera konsultasikan ke dokter. Program intervensi 90 hari GluCare sangat direkomendasikan.'
                : (score >= 30 ? 'Mulai terapkan gaya hidup sehat untuk mencegah progresi ke diabetes.' : 'Kondisi kesehatan Anda optimal. Terus pertahankan pola makan dan aktivitas fisik yang baik!'),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBox(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 9,
              color: color.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRiskFactorsCard(double hba1c, double bmi, int gulaDarah, bool riwayatKeluarga) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Faktor Risiko Teridentifikasi',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          if (hba1c >= 6.5) _buildRiskFactorItem('HbA1c ≥ 6.5% — rentang diabetes', true)
          else if (hba1c >= 5.7) _buildRiskFactorItem('HbA1c 5.7-6.4% — prediabetes', true)
          else _buildRiskFactorItem('HbA1c normal ($hba1c%)', false),

          if (gulaDarah >= 126) _buildRiskFactorItem('Gula puasa ≥ 126 mg/dL — tinggi', true)
          else if (gulaDarah >= 100) _buildRiskFactorItem('Gula puasa 100-125 mg/dL — prediabetes', true)
          else _buildRiskFactorItem('Gula puasa normal', false),

          if (bmi >= 27.5) _buildRiskFactorItem('BMI ≥ 27.5 — obesitas', true)
          else if (bmi >= 23) _buildRiskFactorItem('BMI 23-27.4 — overweight', true)
          else _buildRiskFactorItem('BMI normal', false),

          if (riwayatKeluarga) _buildRiskFactorItem('Ada riwayat diabetes di keluarga', true),
        ],
      ),
    );
  }

  Widget _buildRiskFactorItem(String text, bool isWarning) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: isWarning ? const Color(0xFFFEE2E2) : const Color(0xFFD1FAE5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                isWarning ? '!' : '✓',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isWarning ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFF475569),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabInterpretationCard(double hba1c, double bmi, int gulaDarah) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🔬', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(
                'Interpretasi Lab',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D4ED8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildLabItem('HbA1c $hba1c%:', hba1c >= 6.5 ? '🔴' : (hba1c >= 5.7 ? '🟠' : '🟢'), hba1c >= 6.5 ? 'Diabetes' : (hba1c >= 5.7 ? 'Prediabetes' : 'Normal')),
          const SizedBox(height: 6),
          _buildLabItem('BMI ${bmi.toStringAsFixed(1)} kg/m²:', bmi >= 27.5 ? '🔴' : (bmi >= 23 ? '🟠' : '🟢'), bmi >= 27.5 ? 'Obesitas' : (bmi >= 23 ? 'Overweight' : 'Normal')),
          const SizedBox(height: 6),
          _buildLabItem('Gula Puasa $gulaDarah mg/dL:', gulaDarah >= 126 ? '🔴' : (gulaDarah >= 100 ? '🟠' : '🟢'), gulaDarah >= 126 ? 'Diabetes' : (gulaDarah >= 100 ? 'Prediabetes' : 'Normal')),
        ],
      ),
    );
  }

  Widget _buildLabItem(String label, String icon, String status) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: const Color(0xFF1D4ED8),
          ),
        ),
        const SizedBox(width: 6),
        Text(icon, style: const TextStyle(fontSize: 10)),
        const SizedBox(width: 4),
        Text(
          status,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: const Color(0xFF1D4ED8),
          ),
        ),
      ],
    );
  }
}
