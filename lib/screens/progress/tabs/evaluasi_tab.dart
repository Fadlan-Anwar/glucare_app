import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../home/dashboard_screen.dart';
import '../../auth/auth_service.dart';
import '../plan_service.dart';

class EvaluasiTab extends StatefulWidget {
  const EvaluasiTab({super.key});

  @override
  State<EvaluasiTab> createState() => _EvaluasiTabState();
}

class _EvaluasiTabState extends State<EvaluasiTab> {
  Map<String, dynamic>? _planData;
  List<Map<String, dynamic>> _dailyData = [];
  List<Map<String, dynamic>> _glucoseData = [];
  bool _loading = true;
  String _error = '';
  final PlanService _planService = PlanService();
  
  Map<String, dynamic>? _prevRisk;

  @override
  void initState() {
    super.initState();
    _fetchRealData();
  }

  Future<void> _fetchRealData() async {
    try {
      final user = AuthService().currentUser;
      if (user != null) {
        final planData = await _planService.getPlanData(user.uid);
        final dailyData = await _planService.getDailyTracking(user.uid);
        final glucoseData = await _planService.getGlucoseTracking(user.uid);
        
        final dataNotifier = DashboardContent.analysisDataNotifier.value ?? {};
        final score = dataNotifier['score'] as int? ?? null;
        final riskStatus = dataNotifier['riskStatus'] as String? ?? null;
        
        if (mounted) {
          setState(() {
            _planData = planData['enrolled'] == true ? planData : null;
            _dailyData = dailyData;
            _glucoseData = glucoseData;
            if (score != null) {
              _prevRisk = {'score': score, 'level': riskStatus};
            }
            _loading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Gagal memuat data: ${e.toString()}';
          _loading = false;
        });
      }
    }
  }

  double _avg(List<double> arr) => arr.isEmpty ? 0 : arr.reduce((a, b) => a + b) / arr.length;

  String _riskLabel(String? level) {
    if (level == null) return "-";
    if (level.toLowerCase() == "normal" || level.toLowerCase() == "low") return "Risiko Rendah";
    if (level.toLowerCase() == "prediabetes" || level.toLowerCase() == "medium") return "Risiko Sedang";
    return "Risiko Tinggi";
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error.isNotEmpty) {
      return Center(child: Text(_error, style: const TextStyle(color: Colors.red)));
    }

    List<double> sleepArr = _dailyData.map((d) => (d['sleep_hours'] as num?)?.toDouble() ?? 0).where((v) => v > 0).toList();
    List<double> walkArr = _dailyData.map((d) => (d['walking_minutes'] as num?)?.toDouble() ?? 0).where((v) => v > 0).toList();
    List<double> nutArr = _dailyData.map((d) => (d['nutrition_score'] as num?)?.toDouble() ?? 0).where((v) => v > 0).toList();
    List<double> glucArr = _glucoseData.map((g) => (g['glucose_value'] as num?)?.toDouble() ?? 0).where((v) => v > 0).toList();

    double sleepTarget = (_planData?['targets']?['sleep'] as num?)?.toDouble() ?? 7;
    double walkTarget = (_planData?['targets']?['walking'] as num?)?.toDouble() ?? 30;
    int currentDay = _planData?['day'] as int? ?? 0;

    double avgSleep = _avg(sleepArr);
    double avgWalk = _avg(walkArr);
    double avgNutrition = _avg(nutArr);
    double avgGlucose = _avg(glucArr);
    double? minGlucose = glucArr.isNotEmpty ? glucArr.reduce(min) : null;
    double? maxGlucose = glucArr.isNotEmpty ? glucArr.reduce(max) : null;

    String sleepStatus = avgSleep >= sleepTarget ? "good" : avgSleep >= sleepTarget * 0.8 ? "ok" : "low";
    String walkStatus = avgWalk >= walkTarget ? "baik" : avgWalk >= walkTarget * 0.6 ? "cukup" : "low";
    String nutStatus = avgNutrition >= 7.5 ? "great" : avgNutrition >= 5 ? "baik" : "needs";

    List<double> glucose30 = glucArr.length >= 30 ? glucArr.sublist(0, 30) : glucArr;
    List<double> glucose90 = glucArr.length > 60 ? glucArr.sublist(60, min(90, glucArr.length)) : [];
    
    double avgGluc30 = _avg(glucose30);
    double avgGluc90 = _avg(glucose90);
    double? glucoseDiff = (avgGluc90 > 0 && avgGluc30 > 0) ? (avgGluc90 - avgGluc30) : null;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Perbandingan Risiko
          _buildSection(
            emoji: '📈', title: 'Perbandingan Risiko',
            child: _prevRisk != null ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Risiko Awal (Pertama)', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500])),
                            const SizedBox(height: 4),
                            Text('${_prevRisk!['score'] ?? "-"}%', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.grey[800])),
                            Text(_riskLabel(_prevRisk!['level']), style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.blue[100]!)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Kondisi Saat Ini', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500])),
                            const SizedBox(height: 4),
                            Text(
                              avgGlucose > 0 ? (avgGlucose >= 126 ? "Tinggi" : avgGlucose >= 100 ? "Sedang" : "Baik") : "-",
                              style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w900, color: const Color(0xFF0072CE)),
                            ),
                            Text(avgGlucose > 0 ? 'Rerata: ${avgGlucose.toStringAsFixed(1)} mg/dL' : 'Belum ada data', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (glucArr.length >= 7 && avgGlucose > 0) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: avgGlucose < 100 ? Colors.green[50] : avgGlucose < 126 ? Colors.orange[50] : Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(avgGlucose < 100 ? "✅" : "⚠️", style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            avgGlucose < 100 ? "Gula darah Anda berada di zona normal. Pertahankan!" :
                            avgGlucose < 126 ? "Gula darah masih di zona prediabetes. Tetap semangat." :
                            "Gula darah masih perlu perhatian lebih. Konsultasikan dengan dokter.",
                            style: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.w500,
                              color: avgGlucose < 100 ? Colors.green[700] : avgGlucose < 126 ? Colors.orange[700] : Colors.red[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ]
              ],
            ) : _buildEmptyState("Lakukan analisis risiko terlebih dahulu untuk melihat perbandingan."),
          ),
          const SizedBox(height: 20),

          // Ringkasan Gula Darah
          _buildSection(
            emoji: '🩸', title: 'Ringkasan Gula Darah',
            child: glucArr.length >= 3 ? GridView.count(
              crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.8,
              children: [
                _buildMetricCard('Rata-rata', avgGlucose.toStringAsFixed(1), 'mg/dL', color: avgGlucose < 100 ? Colors.green[600] : avgGlucose < 126 ? Colors.orange[600] : Colors.red[600]),
                _buildMetricCard('Terendah', minGlucose?.toStringAsFixed(0) ?? '-', 'mg/dL', color: Colors.green[600]),
                _buildMetricCard('Tertinggi', maxGlucose?.toStringAsFixed(0) ?? '-', 'mg/dL', color: Colors.red[500]),
                _buildMetricCard('Data Tercatat', glucArr.length.toString(), 'hari'),
              ],
            ) : _buildEmptyState("Belum terdapat cukup data untuk dilakukan evaluasi. Catat gula darah Anda minimal 3 kali."),
          ),
          const SizedBox(height: 20),

          // Pola Tidur
          _buildSection(
            emoji: '😴', title: 'Pola Tidur',
            child: sleepArr.length >= 3 ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(avgSleep.toStringAsFixed(1), style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.grey[800])),
                            const SizedBox(width: 4),
                            Text('jam/hari', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500])),
                          ],
                        ),
                        Text('Target: $sleepTarget jam', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[400])),
                      ],
                    ),
                    _buildStatusBadge(sleepStatus),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: min(1.0, avgSleep / sleepTarget),
                    minHeight: 8,
                    backgroundColor: Colors.grey[100],
                    valueColor: AlwaysStoppedAnimation(sleepStatus == "good" ? Colors.green : sleepStatus == "ok" ? Colors.orange : Colors.red),
                  ),
                ),
                const SizedBox(height: 8),
                Text('Data dari ${sleepArr.length} hari tracking', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[400])),
              ],
            ) : _buildEmptyState("Belum terdapat cukup data pola tidur. Catat minimal 3 hari tracking."),
          ),
          const SizedBox(height: 20),

          // Aktivitas Fisik
          _buildSection(
            emoji: '🚶', title: 'Aktivitas Fisik',
            child: walkArr.length >= 3 ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(avgWalk.round().toString(), style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.grey[800])),
                            const SizedBox(width: 4),
                            Text('menit/hari', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500])),
                          ],
                        ),
                        Text('Target: $walkTarget menit', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[400])),
                      ],
                    ),
                    _buildStatusBadge(walkStatus),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: min(1.0, avgWalk / walkTarget),
                    minHeight: 8,
                    backgroundColor: Colors.grey[100],
                    valueColor: AlwaysStoppedAnimation(walkStatus == "baik" ? Colors.green : walkStatus == "cukup" ? Colors.orange : Colors.red),
                  ),
                ),
                const SizedBox(height: 8),
                Text('Data dari ${walkArr.length} hari tracking', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[400])),
              ],
            ) : _buildEmptyState("Belum terdapat cukup data aktivitas fisik. Catat minimal 3 hari tracking."),
          ),
          const SizedBox(height: 20),

          // Pola Makan
          _buildSection(
            emoji: '🍎', title: 'Pola Makan',
            child: nutArr.length >= 3 ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(avgNutrition.toStringAsFixed(1), style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.grey[800])),
                            const SizedBox(width: 4),
                            Text('/ 10', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500])),
                          ],
                        ),
                        Text('Skor rata-rata nutrisi harian', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[400])),
                      ],
                    ),
                    _buildStatusBadge(nutStatus),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: min(1.0, avgNutrition / 10),
                    minHeight: 8,
                    backgroundColor: Colors.grey[100],
                    valueColor: AlwaysStoppedAnimation(nutStatus == "great" ? Colors.green : nutStatus == "baik" ? Colors.orange : Colors.red),
                  ),
                ),
                const SizedBox(height: 8),
                Text('Data dari ${nutArr.length} hari tracking', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[400])),
              ],
            ) : _buildEmptyState("Belum terdapat cukup data pola makan. Catat minimal 3 hari tracking."),
          ),
          const SizedBox(height: 20),

          // Evaluasi Hari ke-30
          _buildSection(
            emoji: '📅', title: 'Evaluasi Hari ke-30',
            child: currentDay < 30 ? _buildEmptyState("Evaluasi 1 Bulan akan terbuka setelah Anda menjalani program selama 30 hari. (Saat ini hari ke-$currentDay)") 
            : glucArr.isNotEmpty ? Column(
              children: [
                _buildEvalCard(
                  icon: avgGluc30 < 100 ? "✅" : avgGluc30 < 126 ? "⚠️" : "❌",
                  title: 'Gula Darah',
                  desc: avgGluc30 < 100 ? "Terkendali dan berada di zona normal." : avgGluc30 < 126 ? "Menunjukkan tanda perbaikan, namun masih di zona prediabetes." : "Masih tergolong tinggi, perlu perhatian ekstra.",
                  color: avgGluc30 < 100 ? Colors.green : avgGluc30 < 126 ? Colors.orange : Colors.red,
                ),
                const SizedBox(height: 12),
                _buildEvalCard(
                  icon: avgSleep >= sleepTarget ? "✅" : avgSleep >= sleepTarget * 0.8 ? "⚠️" : "❌",
                  title: 'Pola Tidur',
                  desc: avgSleep >= sleepTarget ? "Waktu istirahat Anda sudah memenuhi target." : avgSleep >= sleepTarget * 0.8 ? "Hampir mencapai target, perbaiki sedikit lagi." : "Waktu tidur masih kurang, tingkatkan kualitas istirahat Anda.",
                  color: avgSleep >= sleepTarget ? Colors.green : avgSleep >= sleepTarget * 0.8 ? Colors.orange : Colors.red,
                ),
                const SizedBox(height: 12),
                _buildEvalCard(
                  icon: avgWalk >= walkTarget ? "✅" : avgWalk >= walkTarget * 0.6 ? "⚠️" : "❌",
                  title: 'Aktivitas Fisik',
                  desc: avgWalk >= walkTarget ? "Sangat baik, target jalan kaki tercapai." : avgWalk >= walkTarget * 0.6 ? "Cukup aktif, namun masih bisa ditingkatkan lagi." : "Aktivitas harian masih rendah, mari lebih banyak bergerak.",
                  color: avgWalk >= walkTarget ? Colors.green : avgWalk >= walkTarget * 0.6 ? Colors.orange : Colors.red,
                ),
                const SizedBox(height: 12),
                _buildEvalCard(
                  icon: avgNutrition >= 7.5 ? "✅" : avgNutrition >= 5 ? "⚠️" : "❌",
                  title: 'Pola Makan',
                  desc: avgNutrition >= 7.5 ? "Pola makan sangat terjaga dan bernutrisi baik." : avgNutrition >= 5 ? "Sudah cukup baik, tetap waspada dengan asupan manis." : "Pola makan masih perlu banyak diperbaiki.",
                  color: avgNutrition >= 7.5 ? Colors.green : avgNutrition >= 5 ? Colors.orange : Colors.red,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0072CE).withOpacity(0.05),
                    border: Border.all(color: const Color(0xFF0072CE).withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.lightbulb, color: Color(0xFF0072CE), size: 20),
                          const SizedBox(width: 8),
                          Text('Kesimpulan 30 Hari Pertama', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0072CE))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Setelah 1 bulan berjalan, ${avgGluc30 < 100 ? "kadar gula darah Anda menunjukkan hasil yang luar biasa dan telah kembali normal." : avgGluc30 < 126 ? "kadar gula darah Anda mulai menunjukkan perbaikan, yang berarti tubuh merespons positif terhadap program ini." : "kadar gula darah Anda masih perlu perhatian ekstra dan penyesuaian gaya hidup yang lebih ketat."} Pertahankan kebiasaan yang ${avgWalk >= walkTarget && avgSleep >= sleepTarget && avgNutrition >= 7.5 ? "sudah berjalan sangat baik ini" : "sudah mulai terbangun ini, dan fokuslah untuk memperbaiki aspek yang belum mencapai target demi hasil yang lebih maksimal di bulan berikutnya"}.',
                        style: GoogleFonts.poppins(fontSize: 12, height: 1.5, color: Colors.grey[800], fontWeight: FontWeight.w500),
                      ),
                      if (glucose30.length < 14) ...[
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        Text(
                          '*Catatan: Evaluasi ini menggunakan ${glucose30.length} data gula darah yang tersedia di bulan pertama. Untuk hasil yang lebih presisi, disarankan mencatat gula darah minimal 2 minggu sekali.',
                          style: GoogleFonts.poppins(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey[500]),
                        )
                      ]
                    ],
                  ),
                )
              ],
            ) : _buildEmptyState("Belum ada data gula darah yang dicatat. Catat hasil pemeriksaan Anda setidaknya 1 kali agar kami dapat memberikan evaluasi."),
          ),
          const SizedBox(height: 20),

          // Evaluasi Akhir Program
          _buildSection(
            emoji: '🏆', title: 'Evaluasi Akhir Program (Hari ke-90)',
            child: currentDay < 60 ? _buildEmptyState("Evaluasi Akhir akan terbuka menjelang akhir program (hari ke-60 hingga 90). (Saat ini hari ke-$currentDay)")
            : glucose30.isNotEmpty && glucose90.isNotEmpty && glucoseDiff != null ? Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildMetricCard('Awal Program', avgGluc30.toStringAsFixed(1), 'mg/dL\n(Bulan 1)', alignCenter: true)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildMetricCard('Akhir Program', avgGluc90.toStringAsFixed(1), 'mg/dL\n(Bulan 3)', color: avgGluc90 < avgGluc30 ? Colors.green[600] : Colors.red[500], alignCenter: true)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        decoration: BoxDecoration(color: glucoseDiff < 0 ? Colors.green[50] : Colors.red[50], borderRadius: BorderRadius.circular(16), border: Border.all(color: glucoseDiff < 0 ? Colors.green[200]! : Colors.red[200]!)),
                        child: Column(
                          children: [
                            Text('PERUBAHAN', style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: glucoseDiff < 0 ? Colors.green[700] : Colors.red[700])),
                            const SizedBox(height: 4),
                            Text('${glucoseDiff > 0 ? "+" : ""}${glucoseDiff.toStringAsFixed(1)}', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w900, color: glucoseDiff < 0 ? Colors.green[600] : Colors.red[600])),
                            Text('mg/dL', style: GoogleFonts.poppins(fontSize: 10, color: glucoseDiff < 0 ? Colors.green[700] : Colors.red[700])),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: glucoseDiff < 0 ? Colors.green[50] : glucoseDiff == 0 ? Colors.grey[50] : Colors.red[50],
                    border: Border.all(color: glucoseDiff < 0 ? Colors.green[200]! : glucoseDiff == 0 ? Colors.grey[200]! : Colors.red[200]!),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(glucoseDiff < 0 ? Icons.task_alt : Icons.warning_rounded, color: glucoseDiff < 0 ? Colors.green[600] : Colors.red[600], size: 20),
                          const SizedBox(width: 8),
                          Text('Kesimpulan Akhir Program', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: glucoseDiff < 0 ? Colors.green[800] : Colors.red[800])),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        glucoseDiff < 0
                          ? 'Selamat! Rata-rata gula darah Anda berhasil turun secara signifikan sebesar ${glucoseDiff.abs().toStringAsFixed(1)} mg/dL selama 90 hari. Program intervensi gaya hidup ini telah memberikan dampak positif yang nyata bagi kesehatan metabolik Anda. Terus pertahankan pola hidup sehat ini ke depannya.'
                          : glucoseDiff == 0
                            ? 'Rata-rata gula darah Anda tidak mengalami perubahan yang signifikan selama 90 hari. Evaluasi kembali rutinitas dan kedisiplinan Anda. Sangat disarankan untuk berkonsultasi dengan dokter guna menyesuaikan strategi kesehatan Anda.'
                            : 'Rata-rata gula darah Anda cenderung naik sebesar ${glucoseDiff.toStringAsFixed(1)} mg/dL selama 90 hari terakhir. Tolong tinjau kembali konsistensi pola makan dan aktivitas fisik Anda. Sangat disarankan untuk segera berkonsultasi dengan dokter Anda.',
                        style: GoogleFonts.poppins(fontSize: 12, height: 1.5, color: Colors.grey[800], fontWeight: FontWeight.w500),
                      ),
                      if (glucose30.length < 14 || glucose90.length < 14) ...[
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        Text(
                          '*Catatan: Kesimpulan ini dihitung menggunakan data yang tersedia dari bulan pertama dan bulan ketiga. Pastikan selalu melakukan pengecekan rutin untuk pantauan yang akurat.',
                          style: GoogleFonts.poppins(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey[500]),
                        )
                      ]
                    ],
                  ),
                )
              ],
            ) : _buildEmptyState("Data gula darah di bulan pertama atau bulan ketiga tidak tersedia untuk melakukan perbandingan akhir program."),
          ),
          
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/rencana'), // Or whatever route
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0072CE),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Lanjut Tracking', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/analisis'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0072CE),
                    side: const BorderSide(color: Color(0xFF0072CE)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Analisis Ulang', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSection({required String emoji, required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[800])),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, String unit, {Color? color, bool alignCenter = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: alignCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500]), textAlign: alignCenter ? TextAlign.center : TextAlign.start),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: alignCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w900, color: color ?? Colors.grey[800])),
              if (unit.isNotEmpty && !unit.contains('\n')) ...[
                const SizedBox(width: 4),
                Text(unit, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500])),
              ]
            ],
          ),
          if (unit.contains('\n'))
            Text(unit.replaceAll('\n', ''), style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500]), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String type) {
    Map<String, Map<String, dynamic>> map = {
      "good": {"text": "Target Tercapai", "color": Colors.green},
      "ok": {"text": "Hampir Tercapai", "color": Colors.orange},
      "low": {"text": "Perlu Ditingkatkan", "color": Colors.red},
      "great": {"text": "Sangat Baik", "color": Colors.green},
      "needs": {"text": "Perlu Diperbaiki", "color": Colors.red},
      "baik": {"text": "Baik", "color": Colors.green},
      "cukup": {"text": "Cukup", "color": Colors.orange},
    };
    final config = map[type] ?? {"text": type, "color": Colors.grey};
    final color = config["color"] as MaterialColor;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        config["text"],
        style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: color[700]),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Text(
      message,
      style: GoogleFonts.poppins(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey[400]),
    );
  }

  Widget _buildEvalCard({required String icon, required String title, required String desc, required MaterialColor color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color[50],
        border: Border.all(color: color[100]!),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Center(child: Text(icon, style: const TextStyle(fontSize: 14))),
              ),
              const SizedBox(width: 12),
              Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }
}
