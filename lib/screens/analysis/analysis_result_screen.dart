import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/dashboard_screen.dart';
import '../auth/auth_service.dart';
import '../auth/auth_provider.dart';
import '../../core/user_provider.dart';

class AnalysisResultScreen extends ConsumerStatefulWidget {
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
  int? _aiScore;
  String _riskLevel = "Normal";
  String _cta = "Jaga pola makan dan aktivitas fisik dengan konsisten.";
  Map<String, dynamic>? _pastArgs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performAnalysisAndSave();
    });
  }

  void _extractScoreFromAiResponse(Map<String, dynamic> response, bool isLab) {
    debugPrint("AI Response: $response");
    try {
      final aiResult = response['aiResult'];
      if (aiResult != null && aiResult is Map) {
         _riskLevel = aiResult['risk_level'] ?? "Normal";
         _cta = aiResult['cta'] ?? _cta;
         
         if (isLab) {
            if (aiResult['predict_proba'] != null) {
               final proba = aiResult['predict_proba'] as List;
               if (proba.length >= 3) {
                  _aiScore = (((proba[1] as num) + (proba[2] as num)) * 100).round();
               }
            }
            if (_aiScore == null) {
                if (_riskLevel == "Diabetes" || _riskLevel == "high") _aiScore = 85;
                else if (_riskLevel == "Prediabetes" || _riskLevel == "medium") _aiScore = 55;
                else _aiScore = 25;
            }
         } else {
             if (_riskLevel == "Diabetes" || _riskLevel == "high") {
                _aiScore = 85;
                _riskLevel = "Diabetes";
             } else if (_riskLevel == "Prediabetes" || _riskLevel == "medium") {
                _aiScore = 55;
                _riskLevel = "Prediabetes";
             } else {
                _aiScore = 25;
                _riskLevel = "Normal";
             }
         }
      }
    } catch (e) {
      debugPrint("Error extracting score: $e");
    }
  }

  Future<void> _performAnalysisAndSave() async {
    final startTime = DateTime.now();
    try {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final authService = AuthService();

      if (args != null) {
        if (args['isPast'] == true) {
          final latest = await ref.read(latestAnalysisProvider.future);
          if (latest != null) {
             final type = latest['type'];
             final data = latest['data'] as Map<String, dynamic>;
             
             final score = data['score'] as int? ?? 0;
             _aiScore = score;
             if (score >= 60) _riskLevel = "high";
             else if (score >= 30) _riskLevel = "medium";
             else _riskLevel = "Normal";

             Map<String, dynamic> generatedArgs = {
                'isPast': true,
                'isLab': type == 'lab',
                'isKuesioner': type != 'lab',
             };
             if (type == 'lab') {
                generatedArgs.addAll(data);
             } else {
                generatedArgs['answers'] = [
                   '',
                   data['riwayat_keluarga'] == 'Ya, kakek/nenek' || data['riwayat_keluarga'] == 'Ya, orang tua' ? 'Ada' : 'Tidak ada',
                   data['olahraga']?.toString() ?? '',
                   data['makanan_manis']?.toString() ?? '',
                   data['lingkar_pinggang']?.toString() ?? '',
                   '', '', 
                   data['tingkat_stress'] == 'Ya' ? 'Tinggi' : 'Rendah',
                ];
                generatedArgs['usia'] = int.tryParse(data['usia']?.toString().split('-')[0] ?? '0') ?? 0;
             }
             if (mounted) {
                setState(() {
                   _pastArgs = generatedArgs;
                });
             }
          }
        } else if (args['isKuesioner'] == true) {
          final answers = args['answers'] as List<String>? ?? [];
          final aiResponse = await authService.getQuestionnairePrediction(
            answers: answers,
          );
          _extractScoreFromAiResponse(aiResponse, false);
        } else if (args['isLab'] == true) {
          final aiResponse = await authService.getClinicalPrediction(
            hba1c: 0.0,
            gulaDarahPuasa: (args['gula_darah_puasa'] as num?)?.toInt() ?? 108,
            beratBadan: (args['berat_badan'] as num?)?.toDouble() ?? 72.0,
            tinggiBadan: (args['tinggi_badan'] as num?)?.toDouble() ?? 168.0,
            lingkarPinggang: (args['lingkar_pinggang'] as num?)?.toDouble() ?? 85.0,
            hdl: (args['hdl'] as num?)?.toDouble() ?? 50.0,
            trigliserida: (args['trigliserida'] as num?)?.toDouble() ?? 150.0,
            sistolik: (args['tekanan_sistolik'] as num?)?.toDouble() ?? 120.0,
            diastolik: (args['tekanan_diastolik'] as num?)?.toDouble() ?? 80.0,
            riwayatKeluarga: '',
            riwayatDiabetes: '',
          );
          _extractScoreFromAiResponse(aiResponse, true);
        }
      }
      ref.invalidate(latestLabResultProvider);
      ref.invalidate(latestAnalysisProvider);
    } catch (e) {
      debugPrint("Error saving assessment to backend: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Analisis AI gagal: $e"),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }

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

    final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final args = _pastArgs ?? routeArgs;
    
    int score = _aiScore ?? 0;
    String riskLevel = _riskLevel;
    String cta = _cta;

    final isKuesioner = args?['isKuesioner'] == true;
    
    List<Map<String, dynamic>> faktorRisiko = [];
    List<Map<String, String>> parametersKlinis = [];

    double hba1c = 0.0;
    double bmi = 0.0;
    int gulaDarah = 0;

    if (isKuesioner) {
       final answers = args?['answers'] as List<String>? ?? [];
       
       if (answers.length >= 8) {
          if (answers[1] == 'Ada') faktorRisiko.add({'text': 'Ada riwayat keluarga diabetes', 'isWarning': true});
          if (answers[2] == 'Tidak pernah') faktorRisiko.add({'text': 'Kurang aktivitas fisik', 'isWarning': true});
          if (answers[3] == 'Setiap hari') faktorRisiko.add({'text': 'Sering konsumsi makanan/minuman manis', 'isWarning': true});
          if (answers[4] == 'Besar (Gemuk perut)' || answers[4] == 'Agak Besar') faktorRisiko.add({'text': 'Lingkar pinggang besar', 'isWarning': true});
          if (answers[7] == 'Tinggi') faktorRisiko.add({'text': 'Tingkat stres tinggi', 'isWarning': true});
       }
       if (faktorRisiko.isEmpty) faktorRisiko.add({'text': 'Gaya hidup relatif sehat', 'isWarning': false});
       
    } else {
       final gdpVal = (args?['gula_darah_puasa'] as num?)?.toDouble() ?? widget.gulaDarah?.toDouble() ?? 0.0;
       final beratVal = (args?['berat_badan'] as num?)?.toDouble() ?? widget.berat ?? 0.0;
       final tinggiVal = (args?['tinggi_badan'] as num?)?.toDouble() ?? widget.tinggi ?? 0.0;
       final hdlVal = (args?['hdl'] as num?)?.toDouble() ?? 0.0;
       final tgVal = (args?['trigliserida'] as num?)?.toDouble() ?? 0.0;
       final sistolikVal = (args?['tekanan_sistolik'] as num?)?.toDouble() ?? 0.0;
       final diastolikVal = (args?['tekanan_diastolik'] as num?)?.toDouble() ?? 0.0;
       
       final tinggiM = tinggiVal / 100;
       final bmiVal = tinggiM > 0 ? beratVal / (tinggiM * tinggiM) : 0.0;
       final tgHdl = hdlVal > 0 ? tgVal / hdlVal : 0.0;

       if (gdpVal >= 126) faktorRisiko.add({'text': 'Gula Darah Puasa (${gdpVal.toInt()} mg/dL) mengindikasikan level Diabetes.', 'isWarning': true});
       else if (gdpVal >= 100) faktorRisiko.add({'text': 'Gula Darah Puasa (${gdpVal.toInt()} mg/dL) berada di zona Prediabetes.', 'isWarning': true});
       
       if (bmiVal >= 27.5) faktorRisiko.add({'text': 'Kategori BMI Obesitas (${bmiVal.toStringAsFixed(1)}) meningkatkan risiko metabolik secara signifikan.', 'isWarning': true});
       else if (bmiVal >= 23) faktorRisiko.add({'text': 'Kategori BMI Overweight (${bmiVal.toStringAsFixed(1)}) memicu risiko metabolik.', 'isWarning': true});
       
       if (tgHdl >= 3) faktorRisiko.add({'text': 'Rasio TG/HDL tinggi (${tgHdl.toStringAsFixed(1)}) mengindikasikan kemungkinan resistensi insulin.', 'isWarning': true});
       if (sistolikVal >= 130 || diastolikVal >= 85) faktorRisiko.add({'text': 'Tekanan darah (${sistolikVal.toInt()}/${diastolikVal.toInt()} mmHg) berada di atas rentang optimal.', 'isWarning': true});
       
       final lingkarPinggang = (args?['lingkar_pinggang'] as num?)?.toDouble() ?? 85.0;
       if (lingkarPinggang > 90) faktorRisiko.add({'text': 'Lingkar pinggang (${lingkarPinggang.toInt()} cm) berisiko tinggi.', 'isWarning': true});

       if (faktorRisiko.isEmpty) faktorRisiko.add({'text': 'Tidak ada parameter klinis spesifik yang memicu risiko tinggi.', 'isWarning': false});

       String gdpStr = "Normal";
       if (gdpVal >= 126) gdpStr = "Diabetes";
       else if (gdpVal >= 100) gdpStr = "Prediabetes";

       String bmiStr = "Normal";
       if (bmiVal < 18.5) bmiStr = "Berat badan kurang";
       else if (bmiVal >= 27.5) bmiStr = "Obesitas";
       else if (bmiVal >= 23) bmiStr = "Overweight";

       int usia = (args?['usia'] as num?)?.toInt() ?? 0;
       if (usia == 0) {
         final birthDateStr = UserProvider.userNotifier.value.birthDate;
         if (birthDateStr.isNotEmpty) {
           try {
              final birthDate = DateTime.parse(birthDateStr);
              final now = DateTime.now();
              usia = now.year - birthDate.year;
              if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
                usia--;
              }
           } catch (e) {
              usia = 0;
           }
         }
       }

       parametersKlinis = [
          {'label': 'Usia', 'value': usia > 0 ? '$usia tahun' : '-'},
          {'label': 'BMI', 'value': '${bmiVal.toStringAsFixed(1)} ($bmiStr)'},
          {'label': 'Gula Darah Puasa', 'value': '${gdpVal.toInt()} mg/dL ($gdpStr)'},
          {'label': 'Tekanan Darah', 'value': '${sistolikVal.toInt()}/${diastolikVal.toInt()} mmHg'},
          {'label': 'HDL', 'value': '${hdlVal.toInt()} mg/dL'},
          {'label': 'Trigliserida', 'value': '${tgVal.toInt()} mg/dL'},
          {'label': 'Rasio TG/HDL', 'value': '${tgHdl.toStringAsFixed(1)}'},
          {'label': 'Lingkar Pinggang', 'value': '${lingkarPinggang.toInt()} cm'},
       ];

       hba1c = 0.0;
       gulaDarah = gdpVal.toInt();
       bmi = bmiVal;
    }

    String riskStatus = 'Normal';
    Color riskColor = const Color(0xFF10B981); // Green
    if (riskLevel == 'Diabetes' || riskLevel == 'high') {
      riskStatus = 'Tinggi';
      riskColor = const Color(0xFFEF4444); // Red
    } else if (riskLevel == 'Prediabetes' || riskLevel == 'medium') {
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
                    if (!isKuesioner && parametersKlinis.isNotEmpty) ...[
                      _buildParameterKlinisCard(parametersKlinis),
                      const SizedBox(height: 16),
                    ],
                    _buildRiskFactorsCard(faktorRisiko),
                    const SizedBox(height: 16),
                    _buildKesimpulanCard(cta),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
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
            riskStatus == 'Tinggi' ? Icons.dangerous_rounded : (riskStatus == 'Sedang' ? Icons.warning_amber_rounded : Icons.health_and_safety_rounded),
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
            riskStatus == 'Tinggi' 
                ? 'Indikasi Prediabetes/Diabetes'
                : (riskStatus == 'Sedang' ? 'Peringatan: Pola hidup perlu diperbaiki' : 'Risiko sangat rendah. Pertahankan!'),
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
        ],
      ),
    );
  }

  Widget _buildRiskFactorsCard(List<Map<String, dynamic>> faktorRisiko) {
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
          ...faktorRisiko.map((f) => _buildRiskFactorItem(f['text'] as String, f['isWarning'] as bool)),
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
              child: Icon(
                isWarning ? Icons.priority_high_rounded : Icons.check_rounded,
                size: 14,
                color: isWarning ? const Color(0xFFEF4444) : const Color(0xFF10B981),
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

  Widget _buildKesimpulanCard(String cta) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, color: Color(0xFFA855F7), size: 20),
              const SizedBox(width: 8),
              Text(
                'Kesimpulan AI',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Text(
              cta,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: const Color(0xFF334155),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParameterKlinisCard(List<Map<String, String>> parameters) {
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
          Row(
            children: [
              const Icon(Icons.biotech_rounded, color: Color(0xFF3B82F6), size: 20),
              const SizedBox(width: 8),
              Text(
                'Parameter Klinis',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...parameters.asMap().entries.map((entry) {
            final index = entry.key;
            final param = entry.value;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        param['label']!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        param['value']!,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
                if (index < parameters.length - 1)
                  const Divider(color: Color(0xFFF1F5F9), height: 1, thickness: 1),
              ],
            );
          }),
        ],
      ),
    );
  }
}
