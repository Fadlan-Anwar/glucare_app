import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/user_provider.dart';

class DashboardContent extends StatelessWidget {
  static final ValueNotifier<bool> hasRiskDataNotifier = ValueNotifier<bool>(false);
  static final ValueNotifier<Map<String, dynamic>?> analysisDataNotifier = ValueNotifier<Map<String, dynamic>?>(null);

  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 20),
            child: _buildHeader(),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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

  Widget _buildHeader() {
    return ValueListenableBuilder<UserData>(
      valueListenable: UserProvider.userNotifier,
      builder: (context, userData, child) {
        return Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: userData.profileImage != null
                      ? FileImage(userData.profileImage!)
                      : const NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png')
                          as ImageProvider,
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
                    'Hello, ${userData.name}!',
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
