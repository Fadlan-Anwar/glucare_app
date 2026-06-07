import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../home/dashboard_screen.dart';
import '../../auth/auth_service.dart';

class EvaluasiTab extends StatefulWidget {
  const EvaluasiTab({super.key});

  @override
  State<EvaluasiTab> createState() => _EvaluasiTabState();
}

class _EvaluasiTabState extends State<EvaluasiTab> {
  // AI Prediction States
  String _scenario = 'healthy'; // 'healthy' or 'sedentary'
  List<Map<String, dynamic>> _simulatedData = [];
  Map<String, dynamic>? _prediction;
  bool _loading = false;
  String _error = '';
  bool _showLogs = false;
  bool _showAdvanced = false;

  @override
  void initState() {
    super.initState();
    _simulatedData = _generateSimulatedData(_scenario);
  }

  List<Map<String, dynamic>> _generateSimulatedData(String type) {
    final List<Map<String, dynamic>> records = [];
    const double baseline = 125.0;
    final random = Random();

    for (int i = 0; i < 30; i++) {
      if (type == 'healthy') {
        // Glucose decreases, high steps, good sleep, low carbs, increasing streak
        final double glucoseMean = 125.0 - i * 0.9 - random.nextDouble() * 2.0;
        final int steps = 7500 + i * 85 + random.nextInt(400);
        final double sleepHours = 7.2 + (i % 2 == 0 ? 0.5 : -0.2) + random.nextDouble() * 0.4;
        final double carbsG = 160.0 - i * 1.6 - random.nextDouble() * 8.0;
        records.add({
          'day_idx': i,
          'glucose_mean': glucoseMean < 85.0 ? 85.0 : double.parse(glucoseMean.toStringAsFixed(1)),
          'steps': steps > 15000 ? 15000 : steps,
          'sleep_hours': sleepHours > 10.0 ? 10.0 : (sleepHours < 4.0 ? 4.0 : double.parse(sleepHours.toStringAsFixed(1))),
          'carbs_g': carbsG < 50.0 ? 50.0 : double.parse(carbsG.toStringAsFixed(1)),
          'target_sleep_met': sleepHours >= 7.0 ? 1.0 : 0.0,
          'target_steps_met': steps >= 8000 ? 1.0 : 0.0,
          'streak': i + 1,
          'baseline_glucose': baseline,
        });
      } else {
        // Glucose stays high, low steps, bad sleep, high carbs, low streak
        final double glucoseMean = 125.0 + i * 0.4 + random.nextDouble() * 4.0;
        final int steps = 2500 + (i % 5 == 0 ? 1500 : 0) + random.nextInt(200);
        final double sleepHours = 5.5 - (i % 2 == 0 ? 0.7 : -0.3) + random.nextDouble() * 0.3;
        final double carbsG = 230.0 + i * 0.9 + random.nextDouble() * 12.0;
        records.add({
          'day_idx': i,
          'glucose_mean': glucoseMean > 170.0 ? 170.0 : double.parse(glucoseMean.toStringAsFixed(1)),
          'steps': steps < 1000 ? 1000 : steps,
          'sleep_hours': sleepHours > 10.0 ? 10.0 : (sleepHours < 3.0 ? 3.0 : double.parse(sleepHours.toStringAsFixed(1))),
          'carbs_g': carbsG > 400.0 ? 400.0 : double.parse(carbsG.toStringAsFixed(1)),
          'target_sleep_met': sleepHours >= 7.0 ? 1.0 : 0.0,
          'target_steps_met': steps >= 8000 ? 1.0 : 0.0,
          'streak': (i / 10).round() < 0 ? 0 : (i / 10).round(),
          'baseline_glucose': baseline,
        });
      }
    }
    return records;
  }

  void _handleScenarioChange(String type) {
    setState(() {
      _scenario = type;
      _simulatedData = _generateSimulatedData(type);
      _prediction = null;
      _error = '';
    });
  }

  Future<void> _handleRunPrediction() async {
    setState(() {
      _loading = true;
      _error = '';
      _prediction = null;
    });

    try {
      final authService = AuthService();
      final user = authService.currentUser;
      final patientName = user?.displayName ?? "Pasien Glucare";

      final result = await authService.getAiPrediction(
        patientId: patientName,
        records: _simulatedData,
      );

      setState(() {
        _prediction = result;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = DashboardContent.analysisDataNotifier.value ?? {};
    final int score = data['score'] as int? ?? 68;
    final String riskStatus = data['riskStatus'] as String? ?? 'Tinggi';
    final Color riskColor = data['riskColor'] as Color? ?? const Color(0xFFDC2626);
    final double hba1c = data['hba1c'] as double? ?? 6.5;
    final double bmi = data['bmi'] as double? ?? 27.5;
    final int gulaDarah = data['gulaDarah'] as int? ?? 126;

    return Column(
      children: [
        _buildPerbandinganRisiko(score, riskStatus, riskColor),
        const SizedBox(height: 24),
        _buildMetrikMetabolik(score),
        const SizedBox(height: 24),
        _buildFaktorRisiko(hba1c, bmi, gulaDarah),
        const SizedBox(height: 24),
        _buildAiPredictorPlayground(),
        const SizedBox(height: 24),
        _buildReAssessmentNotification(),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/analysis', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            icon: const Icon(Icons.sync_rounded, color: Colors.white),
            label: Text(
              'Lakukan Re-Assessment',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildPerbandinganRisiko(int score, String riskStatus, Color riskColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Perbandingan Risiko', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildRisikoCard(
                  title: 'Sekarang',
                  percentage: '$score%',
                  status: riskStatus,
                  date: 'Hari 1',
                  progressColor: riskColor,
                  progressValue: score / 100.0,
                  isCurrent: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildRisikoCard(
                  title: 'Target',
                  percentage: '<50%',
                  status: 'Normal',
                  date: 'Hari 90',
                  progressColor: const Color(0xFF10B981),
                  progressValue: 0.50,
                  isCurrent: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline_rounded, color: Color(0xFF3B82F6), size: 18),
                const SizedBox(width: 8),
                Text(
                  'Ini adalah hasil assessment awal Anda.',
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF3B82F6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRisikoCard({
    required String title,
    required String percentage,
    required String status,
    required String date,
    required Color progressColor,
    required double progressValue,
    required bool isCurrent,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrent ? const Color(0xFFF0FDF4) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isCurrent ? const Color(0xFF86EFAC) : Colors.grey[200]!, width: isCurrent ? 1.5 : 1),
        boxShadow: [
          if (!isCurrent)
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(percentage, style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: progressColor)),
          Text(status, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: progressColor)),
          const SizedBox(height: 12),
          Text(date, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[400])),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetrikMetabolik(int score) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Metrik Metabolik', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 16),
          _buildMetrikRow('Usia Metabolik', 'vs. usia 30', '${30 + (score / 10).round()} tahun'),
          const Divider(height: 24, thickness: 1, color: Color(0xFFF1F5F9)),
          _buildMetrikRow('Risiko 5 Tahun', 'probabilitas progresi', '${(score * 0.6).round()}%'),
          const Divider(height: 24, thickness: 1, color: Color(0xFFF1F5F9)),
          _buildMetrikRow('Mode Assessment', 'Hari 1', 'Klinis (Lab)'),
        ],
      ),
    );
  }

  Widget _buildMetrikRow(String title, String subtitle, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[400])),
          ],
        ),
        Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
      ],
    );
  }

  Widget _buildFaktorRisiko(double hba1c, double bmi, int gulaDarah) {
    final factors = [
      if (hba1c >= 6.5) 'HbA1c ≥ 6.5% — rentang diabetes' else if (hba1c >= 5.7) 'HbA1c 5.7-6.4% — prediabetes',
      if (gulaDarah >= 126)
        'Gula puasa ≥ 126 mg/dL — tinggi'
      else if (gulaDarah >= 100)
        'Gula puasa 100-125 mg/dL — prediabetes',
      if (bmi >= 27.5) 'BMI ≥ 27.5 — obesitas' else if (bmi >= 23) 'BMI 23-27.4 — overweight',
      'Kurang aktivitas fisik harian', // Assume generic default
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Faktor Risiko', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 16),
          ...factors.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_rounded, color: Color(0xFFEF4444), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      f,
                      style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textMedium, height: 1.5),
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

  Widget _buildAiPredictorPlayground() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('🧠', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deteksi Dini AI 90-Hari',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'XGBoost Model Prediction',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E88E5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Analisis prognosis hari ke-90 menggunakan data log pemantauan 30 hari pertama.',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const Divider(height: 24, thickness: 1, color: Color(0xFFF1F5F9)),

          // Scenario selector
          _buildScenarioSelector(),
          const SizedBox(height: 16),

          // Stats summary
          _buildLogsSummaryGrid(),
          const SizedBox(height: 16),

          // Collapsible logs
          _buildCollapsibleLogs(),
          const SizedBox(height: 20),

          // Predict Button
          _buildPredictButton(),

          // Error output if any
          if (_error.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildErrorAlert(),
          ],

          // Prediction output if loaded
          if (_prediction != null) ...[
            const SizedBox(height: 20),
            _buildPredictionResults(),
          ],
        ],
      ),
    );
  }

  Widget _buildScenarioSelector() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _handleScenarioChange('healthy'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: _scenario == 'healthy' ? const Color(0xFFD1FAE5) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _scenario == 'healthy' ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  '🟢 Gaya Hidup Sehat',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _scenario == 'healthy' ? const Color(0xFF065F46) : Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => _handleScenarioChange('sedentary'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: _scenario == 'sedentary' ? const Color(0xFFFEF3C7) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _scenario == 'sedentary' ? const Color(0xFFF59E0B) : const Color(0xFFE2E8F0),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  '🟡 Sedentary',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _scenario == 'sedentary' ? const Color(0xFF92400E) : Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogsSummaryGrid() {
    double avgGlucose = 0.0;
    double avgSteps = 0.0;
    double avgSleep = 0.0;
    int targetDaysMet = 0;

    if (_simulatedData.isNotEmpty) {
      double totalGlucose = 0.0;
      int totalSteps = 0;
      double totalSleep = 0.0;
      for (var r in _simulatedData) {
        totalGlucose += (r['glucose_mean'] as num).toDouble();
        totalSteps += r['steps'] as int;
        totalSleep += (r['sleep_hours'] as num).toDouble();
        if ((r['target_steps_met'] as num) == 1.0 && (r['target_sleep_met'] as num) == 1.0) {
          targetDaysMet++;
        }
      }
      avgGlucose = totalGlucose / 30;
      avgSteps = totalSteps / 30;
      avgSleep = totalSleep / 30;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SAMPEL LOG PEMANTAUAN 30 HARI',
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey[400],
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.2,
          children: [
            _buildSummaryCard('Rerata Gula Darah', '${avgGlucose.toStringAsFixed(1)} mg/dL'),
            _buildSummaryCard(
              'Rerata Langkah',
              '${avgSteps.round().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} / hari',
            ),
            _buildSummaryCard('Rerata Jam Tidur', '${avgSleep.toStringAsFixed(1)} jam'),
            _buildSummaryCard('Target Terpenuhi', '$targetDaysMet / 30 Hari', color: const Color(0xFF1E88E5)),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, {Color? color}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 9,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color ?? AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsibleLogs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _showLogs = !_showLogs;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rincian Log Harian',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E88E5),
                ),
              ),
              Row(
                children: [
                  Text(
                    _showLogs ? 'Sembunyikan' : 'Tampilkan Rincian (30 Hari)',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: const Color(0xFF1E88E5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    _showLogs ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: const Color(0xFF1E88E5),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (_showLogs) ...[
          const SizedBox(height: 10),
          Container(
            height: 220,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columnSpacing: 16,
                    horizontalMargin: 12,
                    headingRowHeight: 36,
                    dataRowMinHeight: 32,
                    dataRowMaxHeight: 32,
                    headingRowColor: WidgetStateProperty.all(const Color(0xFFF1F5F9)),
                    columns: [
                      _buildTableColumn('Hari'),
                      _buildTableColumn('Rerata Gula'),
                      _buildTableColumn('Langkah'),
                      _buildTableColumn('Tidur'),
                      _buildTableColumn('Karbo'),
                      _buildTableColumn('Streak'),
                    ],
                    rows:
                        _simulatedData.map((row) {
                          final day = (row['day_idx'] as int) + 1;
                          final glucose = row['glucose_mean'];
                          final steps = row['steps'] as int;
                          final sleep = row['sleep_hours'];
                          final carbs = row['carbs_g'];
                          final streak = row['streak'];
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  'Hari ke-$day',
                                  style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataCell(Text('$glucose mg/dL', style: GoogleFonts.poppins(fontSize: 11))),
                              DataCell(
                                Text(
                                  steps.toString().replaceAllMapped(
                                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                    (Match m) => '${m[1]}.',
                                  ),
                                  style: GoogleFonts.poppins(fontSize: 11),
                                ),
                              ),
                              DataCell(Text('$sleep jam', style: GoogleFonts.poppins(fontSize: 11))),
                              DataCell(Text('${carbs}g', style: GoogleFonts.poppins(fontSize: 11))),
                              DataCell(Text('🔥 $streak', style: GoogleFonts.poppins(fontSize: 11))),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  DataColumn _buildTableColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF475569),
        ),
      ),
    );
  }

  Widget _buildPredictButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _loading ? null : _handleRunPrediction,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B82F6),
          disabledBackgroundColor: const Color(0xFF3B82F6).withValues(alpha: 0.6),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _loading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Menganalisis data log 30 hari...',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Text(
                'Jalankan Evaluasi Prediktif AI',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildErrorAlert() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Gagal mendapatkan prediksi AI: $_error',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: const Color(0xFF991B1B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionResults() {
    if (_prediction == null) return const SizedBox.shrink();

    final String predictedStatus = _prediction!['predicted_status'] ?? 'Membaik';
    final String earlyWarningRisk = _prediction!['early_warning_risk'] ?? 'LOW_RISK_DAY90';
    final String modelName = _prediction!['model_name'] ?? 'XGBoost';
    final int predictionDay = _prediction!['prediction_day'] ?? 30;

    final double probMembaik = (_prediction!['probability_membaik'] as num?)?.toDouble() ?? 0.0;
    final double probMemburuk = (_prediction!['probability_memburuk_stagnan'] as num?)?.toDouble() ?? 0.0;

    final bool isLowRisk = earlyWarningRisk == 'LOW_RISK_DAY90' || predictedStatus == 'Membaik';

    final Color riskBg = isLowRisk ? const Color(0xFFECFDF5) : const Color(0xFFFFFBEB);
    final Color riskBorder = isLowRisk ? const Color(0xFFA7F3D0) : const Color(0xFFFDE68A);
    final Color riskText = isLowRisk ? const Color(0xFF065F46) : const Color(0xFF92400E);
    final Color riskTagBg = isLowRisk ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'HASIL ANALISIS PREDIKSI AI (HARI KE-90)',
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey[400],
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),

        // Main Risk Status Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: riskBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: riskBorder, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        isLowRisk ? '✅' : '⚠️',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Prognosis: $predictedStatus',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: riskText,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: riskTagBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isLowRisk ? 'Lolos' : 'Waspada',
                                style: GoogleFonts.poppins(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: riskText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isLowRisk
                              ? 'Luar biasa! AI memproyeksikan kondisi metabolik Anda membaik pada hari ke-90. Pertahankan pola hidup sehat.'
                              : 'Peringatan Dini! AI memproyeksikan kondisi Anda stagnan/memburuk pada hari ke-90. Segera sesuaikan gaya hidup Anda.',
                          style: GoogleFonts.poppins(
                            fontSize: 10.5,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Dianalisis menggunakan Model ML $modelName pada Hari ke-$predictionDay.',
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Probabilities Bar Chart Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DISTRIBUSI PROBABILITAS KEMAJUAN',
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              _buildProbabilityProgress('Kondisi Membaik', probMembaik, const Color(0xFF10B981)),
              const SizedBox(height: 12),
              _buildProbabilityProgress('Kondisi Memburuk / Stagnan', probMemburuk, const Color(0xFFF59E0B)),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Advanced Metrics breakdown Accordion
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _showAdvanced = !_showAdvanced;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '🛠️ LIHAT METRIK FITUR LANJUTAN MODEL',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF475569),
                      ),
                    ),
                    Icon(
                      _showAdvanced ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: const Color(0xFF475569),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            if (_showAdvanced && _prediction!['features_used'] != null) ...[
              const SizedBox(height: 8),
              _buildAdvancedFeaturesGrid(_prediction!['features_used'] as Map<String, dynamic>),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildProbabilityProgress(String label, double value, Color color) {
    final int percent = (value * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '$percent%',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedFeaturesGrid(Map<String, dynamic> features) {
    final double baselineGlucose = (features['baseline_glucose'] as num?)?.toDouble() ?? 0.0;
    final double meanGlucose = (features['glucose_month1_mean'] as num?)?.toDouble() ?? 0.0;
    final double stdGlucose = (features['glucose_month1_std'] as num?)?.toDouble() ?? 0.0;
    final double slopeGlucose = (features['glucose_slope_month1'] as num?)?.toDouble() ?? 0.0;

    final double meanSteps = (features['steps_month1_mean'] as num?)?.toDouble() ?? 0.0;
    final double stepsAdherence = (features['steps_adherence_m1'] as num?)?.toDouble() ?? 0.0;
    final double sleepAdherence = (features['sleep_adherence_m1'] as num?)?.toDouble() ?? 0.0;
    final int maxStreak = (features['max_streak_m1'] as num?)?.toInt() ?? 0;

    final double corrSteps = (features['corr_steps_glucose_m1'] as num?)?.toDouble() ?? 0.0;
    final double corrSleep = (features['corr_sleep_glucose_m1'] as num?)?.toDouble() ?? 0.0;
    final double corrCarbs = (features['corr_carbs_glucose_m1'] as num?)?.toDouble() ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Block 1: Glucose Stats
          Text(
            'Statistik Gula (Bulan 1)',
            style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF1E88E5)),
          ),
          const SizedBox(height: 6),
          _buildAdvancedMetricRow('Baseline Gula:', '${baselineGlucose.toStringAsFixed(0)} mg/dL'),
          _buildAdvancedMetricRow('Rerata Gula M1:', '${meanGlucose.toStringAsFixed(1)} mg/dL'),
          _buildAdvancedMetricRow('Deviasi Gula:', '± ${stdGlucose.toStringAsFixed(2)}'),
          _buildAdvancedMetricRow(
            'Kemiringan (Slope) Tren:',
            slopeGlucose.toStringAsFixed(3),
            valueColor: slopeGlucose < 0 ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
          ),

          const Divider(height: 16, thickness: 0.8, color: Color(0xFFF1F5F9)),

          // Block 2: Activity & Adherence
          Text(
            'Aktivitas & Kepatuhan',
            style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF1E88E5)),
          ),
          const SizedBox(height: 6),
          _buildAdvancedMetricRow(
            'Rerata Langkah M1:',
            meanSteps.round().toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]}.',
            ),
          ),
          _buildAdvancedMetricRow('Kepatuhan Langkah:', '${(stepsAdherence * 100).toStringAsFixed(0)}%'),
          _buildAdvancedMetricRow('Kepatuhan Tidur:', '${(sleepAdherence * 100).toStringAsFixed(0)}%'),
          _buildAdvancedMetricRow('Streak Terpanjang:', '🔥 $maxStreak Hari', valueColor: const Color(0xFFEA580C)),

          const Divider(height: 16, thickness: 0.8, color: Color(0xFFF1F5F9)),

          // Block 3: Correlations
          Text(
            'Koefisien Korelasi Gula',
            style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF1E88E5)),
          ),
          const SizedBox(height: 6),
          _buildAdvancedMetricRow(
            'Korelasi Langkah & Gula:',
            corrSteps.toStringAsFixed(3),
            valueColor: corrSteps < 0 ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
          ),
          _buildAdvancedMetricRow(
            'Korelasi Tidur & Gula:',
            corrSleep.toStringAsFixed(3),
            valueColor: corrSleep < 0 ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
          ),
          _buildAdvancedMetricRow(
            'Korelasi Karbo & Gula:',
            corrCarbs.toStringAsFixed(3),
            valueColor: corrCarbs > 0 ? const Color(0xFFF59E0B) : const Color(0xFF10B981),
          ),

          const SizedBox(height: 6),
          Text(
            '*Nilai korelasi negatif (-) menunjukkan peningkatan aktivitas/tidur berhasil menurunkan gula darah.',
            style: GoogleFonts.poppins(fontSize: 8, color: Colors.grey[500], height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedMetricRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500]),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: valueColor ?? AppColors.textDark),
          ),
        ],
      ),
    );
  }

  Widget _buildReAssessmentNotification() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.notifications_active_rounded, color: Color(0xFFEF4444), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Waktunya Re-Assessment!',
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF991B1B)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sudah 1 bulan sejak analisis terakhir. Lakukan pengecekan ulang untuk melihat progres kesehatan Anda.',
                  style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFFB91C1C)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
