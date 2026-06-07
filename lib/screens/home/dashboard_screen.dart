import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/user_provider.dart';
import '../auth/auth_provider.dart';

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
    final latestAnalysisAsync = ref.watch(latestAnalysisProvider);

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
            score = _calculateKuesionerScore(data);
            
            // Map proxy values for status indicator labels
            hba1c = score >= 60 ? 6.5 : (score >= 30 ? 5.9 : 5.0);
            gulaDarah = score >= 60 ? 130 : (score >= 30 ? 110 : 90);
            
            final weight = data['lingkar_pinggang']?.toString();
            bmi = weight == 'Obesitas' ? 30.0 : (weight == 'Kelebihan berat badan' ? 26.0 : (weight == 'Sedikit kelebihan' ? 24.0 : 21.0));
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
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                ValueListenableBuilder<bool>(
                  valueListenable: hasRiskDataNotifier,
                  builder: (context, hasRiskData, child) {
                    return ValueListenableBuilder<Map<String, dynamic>?>(
                      valueListenable: analysisDataNotifier,
                      builder: (context, analysisData, child) {
                        return Column(
                          children: [
                            _buildRiskStatusCard(context, hasRiskData),
                            const SizedBox(height: 24),
                            _buildStatsRow(hasRiskData),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 32),
                _buildReminderSection(),
                const SizedBox(height: 40),
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
          Stack(
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
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      data: (userProfile) {
        final fullName = userProfile?['fullname'] ?? userProfile?['fullName'] ?? (UserProvider.userNotifier.value.name.isNotEmpty ? UserProvider.userNotifier.value.name : 'User');

        return Row(
          children: [
            ValueListenableBuilder<UserData>(
              valueListenable: UserProvider.userNotifier,
              builder: (context, userData, child) {
                return Container(
                  width: 50,
                  height: 50,
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
                children: [
                  Text(
                    'Good Morning',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Hello, $fullName!',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Stack(
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
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
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

      String label = 'Normal';
      if (hba1c >= 6.5) label = 'Diabetes';
      else if (hba1c >= 5.7) label = 'Prediabetes';

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              riskColor, 
              riskColor.withValues(alpha: 0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: riskColor.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status Risiko',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '$score',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '%',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Risiko $riskStatus',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              score >= 60 
                  ? 'Fokus hari ini: Jaga pola makan & capai target kalori Anda.'
                  : 'Fokus hari ini: Pertahankan kebiasaan sehat Anda.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.9),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Navigate to recommendation plan
                    Navigator.pushNamedAndRemoveUntil(context, '/recommendation', (route) => false);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Lihat Rencana Hari Ini',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFB91C1C),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded,
                          color: Color(0xFFB91C1C), size: 20),
                    ],
                  ),
                ),
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3B82F6),
            Color(0xFF1D4ED8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
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
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yuk mulai penilaian untuk melihat kondisi kesehatan Anda saat ini.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Navigate to Analysis tab
                  Navigator.pushNamedAndRemoveUntil(context, '/analysis', (route) => false);
                },
                borderRadius: BorderRadius.circular(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Cek Risiko Sekarang',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1D4ED8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right_rounded,
                        color: Color(0xFF1D4ED8), size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(bool hasRiskData) {
    return Row(
      children: [
        Expanded(
          child: _buildSmallStatCard(
            icon: Icons.local_fire_department_rounded,
            iconColor: Colors.orange,
            title: 'Streak',
            value: hasRiskData ? '1' : '0',
            subtitle: 'Hari Aktif',
            progressWidget: Row(
              children: List.generate(
                  7,
                  (index) => Container(
                        width: 14,
                        height: 6,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: (hasRiskData && index == 0)
                              ? Colors.orange
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      )),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSmallStatCard(
            icon: Icons.trending_up_rounded,
            iconColor: Colors.blue,
            title: 'Intervensi',
            value: hasRiskData ? '1%' : '0%',
            subtitle: hasRiskData ? 'Hari 1/90' : 'Hari 0/90',
            progressWidget: Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(2),
              ),
              child: Row(
                children: [
                  Container(
                    width: hasRiskData ? 12 : 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
    required Widget progressWidget,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
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
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 12),
          progressWidget,
        ],
      ),
    );
  }

  Widget _buildReminderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.alarm_on_rounded,
                      color: Colors.redAccent, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Reminder Preview',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              Text(
                'Kelola',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3B82F6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildReminderItem('07:30', 'Cek Gula Darah Pagi', Colors.red,
              Icons.water_drop_rounded),
          const Divider(height: 24, thickness: 1, color: Color(0xFFF1F5F9)),
          _buildReminderItem('13:00', 'Makan Siang Sehat', Colors.green,
              Icons.restaurant_rounded),
          const Divider(height: 24, thickness: 1, color: Color(0xFFF1F5F9)),
          _buildReminderItem('19:00', 'Aktivitas Fisik Sore', Colors.orange,
              Icons.directions_run_rounded),
        ],
      ),
    );
  }

  Widget _buildReminderItem(
      String time, String title, Color color, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            time,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ),
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
