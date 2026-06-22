import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/user_provider.dart';
import '../auth/auth_provider.dart';
import '../../core/providers/notification_provider.dart';
import 'notification_list_screen.dart';
import '../recommendation/recommendation_screen.dart';
import '../progress/plan_service.dart';
import '../auth/auth_service.dart';
import '../../core/services/notification_service.dart';
import '../../core/providers/network_provider.dart';

int _calculateKuesionerScore(Map<String, dynamic> data) {
  int score = 0;
  
  final usia = data['usia']?.toString();
  if (usia == '30-39 tahun') score += 10;
  else if (usia == '40+ tahun') score += 20;
  
  final riwayatKeluarga = data['riwayat_keluarga']?.toString();
  if (riwayatKeluarga == 'Ya, kakek/nenek') score += 5;
  else if (riwayatKeluarga == 'Ya, orang tua' || riwayatKeluarga == 'Ya, saudara kandung') score += 10;
  
  final berat = data['lingkar_pinggang']?.toString(); // Stored in lingkar_pinggang
  if (berat == 'Sedikit kelebihan') score += 10;
  else if (berat == 'Kelebihan berat badan') score += 15;
  else if (berat == 'Obesitas') score += 20;
  
  final olahraga = data['olahraga']?.toString();
  if (olahraga == '1–2x per minggu') score += 5;
  else if (olahraga == 'Jarang sekali') score += 10;
  else if (olahraga == 'Tidak pernah') score += 15;
  
  final makanan = data['makanan_manis']?.toString();
  if (makanan == 'Cukup sehat') score += 5;
  else if (makanan == 'Sering makan cepat saji') score += 10;
  else if (makanan == 'Banyak gula & gorengan') score += 15;
  
  final tidur = data['jam_tidur']?.toString();
  if (tidur == '5–6 jam') score += 5;
  else if (tidur == 'Kurang dari 5 jam' || tidur == 'Tidak teratur') score += 10;
  
  final stress = data['tingkat_stress']?.toString();
  if (stress == 'Ya') score += 10;
  
  final gejala = data['gejala_diabetes']?.toString();
  if (gejala == 'Kadang-kadang') score += 5;
  else if (gejala == 'Salah satu rutin') score += 10;
  else if (gejala == 'Keduanya rutin') score += 15;
  
  int finalScore = ((score / 115) * 100).round();
  return finalScore > 100 ? 100 : finalScore;
}

class DashboardContent extends ConsumerWidget {
  static final ValueNotifier<bool> hasRiskDataNotifier = ValueNotifier<bool>(false);
  static final ValueNotifier<Map<String, dynamic>?> analysisDataNotifier = ValueNotifier<Map<String, dynamic>?>(null);

  static void clearAnalysisData() {
    hasRiskDataNotifier.value = false;
    analysisDataNotifier.value = null;
  }

  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(networkProvider, (previous, next) {
      if (previous == NetworkStatus.offline && next == NetworkStatus.online) {
        ref.invalidate(latestAnalysisProvider);
        ref.invalidate(planDataProvider);
      }
    });

    final isOffline = ref.watch(networkProvider) == NetworkStatus.offline;
    final latestAnalysisAsync = ref.watch(latestAnalysisProvider);
    final planDataAsync = ref.watch(planDataProvider);
    final planData = planDataAsync.value;

    // Reactively update/clear the static analysis states when data loads or updates
    latestAnalysisAsync.when(
      data: (analysis) {
        if (analysis != null) {
          final type = analysis['type'];
          final data = analysis['data'] as Map<String, dynamic>;
          
          int score = 0;
          double hba1c = 5.0;
          double bmi = 21.0;
          int gulaDarah = 90;
          
          if (type == 'lab') {
            hba1c = (data['hba1c'] as num?)?.toDouble() ?? 5.9;
            gulaDarah = (data['gula_darah_puasa'] as num?)?.toInt() ?? 108;
            final double berat = (data['berat_badan'] as num?)?.toDouble() ?? 72.0;
            final double tinggi = (data['tinggi_badan'] as num?)?.toDouble() ?? 168.0;
            final bool riwayatKeluarga = data['riwayat_keluarga'] == 'Ya';

            final tinggiM = tinggi / 100;
            bmi = berat / (tinggiM * tinggiM);

            if (hba1c >= 6.5) score += 40;
            else if (hba1c >= 5.7) score += 20;

            if (gulaDarah >= 126) score += 30;
            else if (gulaDarah >= 100) score += 15;

            if (bmi >= 27.5) score += 20;
            else if (bmi >= 23) score += 10;

            if (riwayatKeluarga) score += 10;
            if (score > 100) score = 100;
          } else {
            // Questionnaire
            if (data.containsKey('score')) {
              score = (data['score'] as num).toInt();
            } else if (data.containsKey('bmi_category')) {
              final bmiCat = data['bmi_category'] as int? ?? 0;
              final waistCat = data['waist_category'] as int? ?? 0;
              final hyper = data['hypertension'] as int? ?? 0;
              final history = data['overweight_history'] as int? ?? 0;
              if (bmiCat == 1) score += 15;
              if (bmiCat == 2) score += 30;
              if (waistCat == 1) score += 20;
              if (hyper == 1) score += 25;
              if (history == 1) score += 25;
            } else {
              score = _calculateKuesionerScore(data);
            }
            
            // Map proxy values for status indicator labels
            hba1c = score >= 60 ? 6.5 : (score >= 30 ? 5.9 : 5.0);
            gulaDarah = score >= 60 ? 130 : (score >= 30 ? 110 : 90);
            
            if (data.containsKey('bmi_category')) {
              final b = data['bmi_category'] as int? ?? 0;
              bmi = b == 2 ? 30.0 : (b == 1 ? 26.0 : 21.0);
            } else {
              final weight = data['lingkar_pinggang']?.toString();
              bmi = weight == 'Obesitas' ? 30.0 : (weight == 'Kelebihan berat badan' ? 26.0 : (weight == 'Sedikit kelebihan' ? 24.0 : 21.0));
            }
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

          // Override with AI Result if available
          final aiResultEnvelope = analysis['ai_result'];
          if (aiResultEnvelope != null && aiResultEnvelope['aiResult'] != null) {
            final aiRes = aiResultEnvelope['aiResult'];
            final proba = aiRes['predict_proba'] as List<dynamic>? ?? [0, 0, 0];
            double p1 = (proba.length > 1) ? (proba[1] as num).toDouble() : 0.0;
            double p2 = (proba.length > 2) ? (proba[2] as num).toDouble() : 0.0;
            
            score = ((p1 + p2) * 100).round();
            
            final String aiRiskLevel = aiRes['risk_level']?.toString() ?? "Diabetes";
            
            if (aiRiskLevel == "Normal" || aiRiskLevel == "low") {
              riskStatus = 'Normal';
              riskColor = const Color(0xFF10B981); // Green
            } else if (aiRiskLevel == "Prediabetes" || aiRiskLevel == "medium") {
              riskStatus = 'Sedang';
              riskColor = const Color(0xFFF59E0B); // Orange
            } else if (aiRiskLevel == "high" || aiRiskLevel == "Diabetes") {
              riskStatus = 'Tinggi';
              riskColor = const Color(0xFFEF4444); // Red
            }

            // Adjust score based on mode if needed (matching React logic)
            if (aiResultEnvelope['mode'] == 'questionnaire') {
              if (aiRiskLevel == "Normal" || aiRiskLevel == "low") score = 25;
              else if (aiRiskLevel == "Prediabetes" || aiRiskLevel == "medium") score = 55;
              else if (aiRiskLevel == "high" || aiRiskLevel == "Diabetes") score = 85;
            }
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            hasRiskDataNotifier.value = true;
            analysisDataNotifier.value = {
              'score': score,
              'riskStatus': riskStatus,
              'riskColor': riskColor,
              'hba1c': hba1c,
              'bmi': bmi,
              'gulaDarah': gulaDarah,
              'type': type,
            };
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            clearAnalysisData();
          });
        }
      },
      loading: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          clearAnalysisData();
        });
      },
      error: (err, stack) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          clearAnalysisData();
        });
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 20),
            child: _buildHeader(ref),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 36),
                ValueListenableBuilder<bool>(
                  valueListenable: hasRiskDataNotifier,
                  builder: (context, hasRiskData, child) {
                    return ValueListenableBuilder<Map<String, dynamic>?>(
                      valueListenable: analysisDataNotifier,
                      builder: (context, analysisData, child) {
                        return Column(
                          children: [
                            _buildRiskStatusCard(context, hasRiskData && !isOffline),
                            const SizedBox(height: 16),
                            _buildStatsRow(hasRiskData && !isOffline, planData),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                const DailyTrackingDashboardWidget(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);

    return userProfileAsync.when(
      loading: () => Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: 60,
                  color: Colors.grey[200],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 18,
                  width: 120,
                  color: Colors.grey[200],
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
          ),
        ],
      ),
      error: (error, stack) => Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                ValueListenableBuilder<UserData>(
                  valueListenable: UserProvider.userNotifier,
                  builder: (context, userData, child) {
                    return Text(
                      userData.name.isNotEmpty ? 'Hello, ${userData.name}!' : 'Hello, pengguna!',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Consumer(
            builder: (context, ref, child) {
              final unreadCount = ref.watch(unreadNotificationCountProvider);
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationListScreen()),
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Icon(Icons.notifications_none_rounded,
                          color: Colors.grey[700], size: 24),
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 10,
                            minHeight: 10,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      data: (userProfile) {
        final fullName = userProfile?['fullname'] ?? userProfile?['fullName'] ?? (UserProvider.userNotifier.value.name.isNotEmpty ? UserProvider.userNotifier.value.name : 'User');

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ValueListenableBuilder<UserData>(
              valueListenable: UserProvider.userNotifier,
              builder: (context, userData, child) {
                return Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: userData.profileImage != null
                          ? FileImage(userData.profileImage!)
                          : (userData.profileImageUrl != null
                              ? NetworkImage(userData.profileImageUrl!)
                              : const NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png') as ImageProvider),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Good Morning',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Hello, $fullName!',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Level Badge
            Builder(
              builder: (context) {
                final planData = ref.watch(planDataProvider).value;
                final level = planData != null && planData['enrolled'] == true 
                    ? (planData['level'] ?? 1) 
                    : 1;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFB923C), Color(0xFFF59E0B)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF59E0B).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('⚡', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        'Lv.$level',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }
            ),
            const SizedBox(width: 8),
            Consumer(
              builder: (context, ref, child) {
                final unreadCount = ref.watch(unreadNotificationCountProvider);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationListScreen()),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Icon(Icons.notifications_none_rounded,
                            color: Colors.grey[700], size: 20),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 2,
                          top: 2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 10,
                              minHeight: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildRiskStatusCard(BuildContext context, bool hasRiskData) {
    if (hasRiskData) {
      final data = analysisDataNotifier.value ?? {};
      final int score = data['score'] as int? ?? 68;
      final String riskStatus = data['riskStatus'] as String? ?? 'Tinggi';
      final Color riskColor = data['riskColor'] as Color? ?? const Color(0xFFEF4444);
      final double hba1c = data['hba1c'] as double? ?? 6.5;

      String statusText = 'Indikasi Diabetes';
      if (riskStatus == 'Normal' || riskStatus == 'Rendah') {
        statusText = 'Kondisi Normal';
      } else if (riskStatus == 'Sedang') {
        statusText = 'Indikasi Prediabetes';
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: riskColor.value == 0xFFEF4444 
              ? [const Color(0xFFDC2626), const Color(0xFFF43F5E)] // Red/Rose
              : (riskColor.value == 0xFFF59E0B 
                  ? [const Color(0xFFF97316), const Color(0xFFF59E0B)] // Orange/Amber
                  : [const Color(0xFF059669), const Color(0xFF14B8A6)]), // Emerald/Teal
          ),
          boxShadow: [
            BoxShadow(
              color: riskColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STATUS RISIKO',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    statusText,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pantau dan lakukan penilaian berkala untuk mengetahui potensi risiko.',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/progress');
                    },
                    icon: Icon(Icons.query_stats_rounded, size: 18, color: riskColor),
                    label: Text(
                      'Lihat Detail',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: riskColor,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: riskColor,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'SKOR RISIKO',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$score',
                        style: GoogleFonts.inter(
                          fontSize: 48,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -2,
                        ),
                      ),
                      Text(
                        '%',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Default "Belum Ada Data" state
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF1E88E5),
            Color(0xFF42A5F5),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E88E5).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Risiko',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Belum Ada Data Risiko',
            style: GoogleFonts.inter(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yuk mulai penilaian untuk melihat kondisi kesehatan Anda saat ini.',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/analysis', (route) => false);
            },
            icon: const Icon(Icons.arrow_forward_rounded, size: 18, color: Color(0xFF1D4ED8)),
            label: Text(
              'Cek Risiko',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D4ED8),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1D4ED8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(bool hasRiskData, Map<String, dynamic>? planData) {
    int streak = 0;
    int level = 1;
    int xp = 0;
    int xpToNext = 100;
    int day = 0;
    bool isEnrolled = false;

    if (planData != null && planData['enrolled'] == true) {
      isEnrolled = true;
      streak = planData['currentStreak'] ?? 0;
      level = planData['level'] ?? 1;
      xp = planData['xp'] ?? 0;
      xpToNext = planData['xpToNextLevel'] ?? 100;
      day = planData['day'] ?? 1;
    }

    return Row(
      children: [
        Expanded(
          child: _buildSmallStatCard(
            icon: Icons.local_fire_department_rounded,
            title: 'Streak',
            value: '$streak',
            subtitle: 'Hari Aktif',
            progress: isEnrolled ? (streak / 7).clamp(0.0, 1.0) : 0.0,
            progressColors: [const Color(0xFFFB923C), const Color(0xFFEF4444)],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSmallStatCard(
            icon: Icons.show_chart_rounded,
            title: 'Intervensi',
            value: '$day/90',
            subtitle: 'Hari',
            progress: isEnrolled ? (day / 90).clamp(0.0, 1.0) : 0.0,
            progressColors: [const Color(0xFF3B82F6), const Color(0xFF0072CE)],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required double progress,
    required List<Color> progressColors,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: progressColors[0]),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.grey[500],
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(progressColors[0]),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class DailyTrackingDashboardWidget extends ConsumerStatefulWidget {
  const DailyTrackingDashboardWidget({super.key});

  @override
  ConsumerState<DailyTrackingDashboardWidget> createState() => _DailyTrackingDashboardWidgetState();
}

class _DailyTrackingDashboardWidgetState extends ConsumerState<DailyTrackingDashboardWidget> {
  final _planService = PlanService();
  bool _isLoading = true;
  bool _isEnrolled = false;
  Map<String, dynamic>? _planData;

  bool _tidur = false;
  bool _langkah = false;
  bool _nutrisi = false;
  bool _isCompletedToday = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchPlanData();
  }

  Future<void> _fetchPlanData() async {
    final user = AuthService().currentUser;
    if (user == null || user.uid.isEmpty) return;
    try {
      final data = await _planService.getPlanData(user.uid);
      if (mounted) {
        setState(() {
          _planData = data;
          _isEnrolled = data['enrolled'] ?? false;
          if (_isEnrolled && data['todayTracking'] != null) {
            final today = data['todayTracking'];
            _isCompletedToday = true;
            _tidur = today['sleep_hours'] != null;
            _langkah = today['walking_minutes'] != null;
            _nutrisi = today['nutrition_score'] != null;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _toggleTask(String task) {
    if (_isCompletedToday) return;
    setState(() {
      if (task == 'tidur') _tidur = !_tidur;
      else if (task == 'langkah') _langkah = !_langkah;
      else if (task == 'nutrisi') _nutrisi = !_nutrisi;
    });
  }

  Future<void> _submitDaily() async {
    if (_isCompletedToday) return;
    setState(() => _isSubmitting = true);
    try {
      final user = AuthService().currentUser;
      if (user == null) throw Exception('User not log in');
      await _planService.submitDailyTracking(
        userId: user.uid,
        day: _planData?['day'] ?? 1,
        sleepHours: _tidur ? 7.5 : null,
        walkingMinutes: _langkah ? 30 : null,
        nutritionScore: _nutrisi ? 85.0 : null,
      );
      if (mounted) {
        setState(() {
          _isCompletedToday = true;
          _isSubmitting = false;
        });
        ref.invalidate(planDataProvider);
        ref.read(planRefreshProvider.notifier).increment();
        
        // Trigger system notification
        await NotificationService().showNotification(
          id: 1,
          title: 'GluCare Daily Tracking',
          body: 'Progress harianmu berhasil disimpan! Terus pertahankan streak-mu.',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF22C55E).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.star_rounded, color: Color(0xFF22C55E), size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Luar Biasa!',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Progress harianmu disimpan. Terus pertahankan streak-mu!',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan progress.')),
        );
      }
    }
  }

  Widget _buildTaskItem(String task, IconData iconData, Color iconColor, String title) {
    final isChecked = task == 'tidur' ? _tidur : (task == 'langkah' ? _langkah : _nutrisi);
    return InkWell(
      onTap: () => _toggleTask(task),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isChecked ? Colors.grey[100] : iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(iconData, size: 20, color: isChecked ? Colors.grey[400] : iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isChecked ? Colors.grey[400] : const Color(0xFF374151),
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 22, height: 22,
              decoration: BoxDecoration(
                color: isChecked ? const Color(0xFF22C55E) : Colors.transparent,
                border: Border.all(
                  color: isChecked ? const Color(0xFF22C55E) : Colors.grey[300]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: isChecked
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(networkProvider, (previous, next) {
      if (previous == NetworkStatus.offline && next == NetworkStatus.online) {
        if (!mounted) return;
        setState(() => _isLoading = true);
        _fetchPlanData();
      }
    });

    ref.listen(planRefreshProvider, (_, __) {
      _fetchPlanData();
    });

    final isOffline = ref.watch(networkProvider) == NetworkStatus.offline;
    if (_isLoading || !_isEnrolled || isOffline) return const SizedBox.shrink();

    final day = _planData?['day'] ?? 1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Target hari ini',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Hari $day',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0072CE),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Tasks
          _buildTaskItem('tidur', Icons.bedtime_rounded, const Color(0xFF6366F1), 'Tidur Sesuai Target (7.5 Jam)'),
          Divider(height: 1, color: Colors.grey[100]),
          _buildTaskItem('langkah', Icons.directions_walk_rounded, const Color(0xFF10B981), 'Aktivitas Harian (30 Menit)'),
          Divider(height: 1, color: Colors.grey[100]),
          _buildTaskItem('nutrisi', Icons.restaurant_menu_rounded, const Color(0xFFF59E0B), 'Makan Sehat (Sesuai Target)'),

          const SizedBox(height: 16),

          // Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_isCompletedToday || _isSubmitting) ? null : _submitDaily,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0072CE),
                disabledBackgroundColor: Colors.grey[200],
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      _isCompletedToday ? '✓ Selesai Hari Ini' : 'Simpan Progress',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _isCompletedToday ? Colors.grey[500] : Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
