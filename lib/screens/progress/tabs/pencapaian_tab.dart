import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/auth_service.dart';
import '../plan_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/network_provider.dart';

class PencapaianTab extends ConsumerStatefulWidget {
  const PencapaianTab({super.key});

  @override
  ConsumerState<PencapaianTab> createState() => _PencapaianTabState();
}

class _PencapaianTabState extends ConsumerState<PencapaianTab> {
  bool _loading = true;
  String _error = '';
  List<String> _userAchievements = [];
  final PlanService _planService = PlanService();

  static const List<Map<String, dynamic>> _allAchievements = [
    {'id': 'FIRST_STEP', 'icon': '⭐', 'title': 'First Step', 'subtitle': 'Lakukan pelacakan harian pertama', 'xp': 50},
    {'id': 'GLUCOSE_TRACKER', 'icon': '🩸', 'title': 'Glucose Tracker', 'subtitle': 'Masukan data gula darah pertama', 'xp': 50},
    {'id': 'STREAK_7', 'icon': '🔥', 'title': 'Week Warrior', 'subtitle': 'Aktif 7 hari berturut-turut', 'xp': 100},
    {'id': 'STREAK_14', 'icon': '💪', 'title': 'Consistency Master', 'subtitle': 'Aktif 14 hari berturut-turut', 'xp': 200},
    {'id': 'STREAK_30', 'icon': '🏆', 'title': 'Monthly Master', 'subtitle': 'Aktif 30 hari berturut-turut', 'xp': 500},
    {'id': 'LEVEL_5', 'icon': '🌟', 'title': 'Level 5 Achiever', 'subtitle': 'Mencapai Level 5', 'xp': 300},
    {'id': 'LEVEL_10', 'icon': '👑', 'title': 'Level 10 Master', 'subtitle': 'Mencapai Level 10', 'xp': 500},
    {'id': 'PROGRAM_COMPLETED', 'icon': '🚀', 'title': 'Program Completed', 'subtitle': 'Menyelesaikan program 90 Hari', 'xp': 1000},
  ];

  @override
  void initState() {
    super.initState();
    _fetchAchievements();
  }

  Future<void> _fetchAchievements() async {
    try {
      final user = AuthService().currentUser;
      if (user != null) {
        final planData = await _planService.getPlanData(user.uid);
        if (mounted) {
          setState(() {
            if (planData['achievements'] != null) {
              _userAchievements = List<String>.from(planData['achievements']);
            }
            _loading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Gagal memuat pencapaian: ${e.toString()}';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(networkProvider, (previous, next) {
      if (previous == NetworkStatus.offline && next == NetworkStatus.online) {
        if (!mounted) return;
        setState(() => _loading = true);
        _fetchAchievements();
      }
    });

    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    // We intentionally ignore showing raw errors to the user.
    // If there's a network error, it will gracefully show the empty achievements state.

    final earned = _allAchievements.where((a) => _userAchievements.contains(a['id'])).toList();
    final locked = _allAchievements.where((a) => !_userAchievements.contains(a['id'])).toList();

    return Column(
      children: [
        // Container: Diraih
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.emoji_events_outlined, color: Color(0xFFD97706), size: 20),
                const SizedBox(width: 8),
                Text('Diraih ', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                Text('(${earned.length})', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF10B981))),
              ]),
              const SizedBox(height: 20),
              if (earned.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Belum ada pencapaian.\nSelesaikan tugas harian untuk meraih lencana!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey[400]),
                    ),
                  ),
                )
              else
                _buildEarnedGrid(earned),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Container: Belum Diraih
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text('Belum Diraih ', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                Text('(${locked.length})', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[500])),
              ]),
              const SizedBox(height: 16),
              if (locked.isEmpty)
                Center(
                  child: Text(
                    'Luar biasa! Anda telah meraih semua pencapaian.',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.green[600]),
                  ),
                )
              else
                ...locked.map((item) => _buildLockedAchievedCard(
                  icon: item['icon'] as String,
                  title: item['title'] as String,
                  subtitle: item['subtitle'] as String,
                  xp: '+ ${item['xp']} XP',
                )),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildEarnedGrid(List<Map<String, dynamic>> earned) {
    // Membangun grid 2 kolom
    List<Widget> rows = [];
    for (int i = 0; i < earned.length; i += 2) {
      Widget left = _buildAchievedCard(
        icon: earned[i]['icon'] as String,
        title: earned[i]['title'] as String,
        subtitle: earned[i]['subtitle'] as String,
        xp: '+${earned[i]['xp']} XP',
      );
      
      Widget right = (i + 1 < earned.length)
        ? _buildAchievedCard(
            icon: earned[i + 1]['icon'] as String,
            title: earned[i + 1]['title'] as String,
            subtitle: earned[i + 1]['subtitle'] as String,
            xp: '+${earned[i + 1]['xp']} XP',
          )
        : const SizedBox.shrink(); // Empty space if odd

      rows.add(
        Row(
          children: [
            Expanded(child: left),
            const SizedBox(width: 16),
            Expanded(child: right),
          ],
        ),
      );
      if (i + 2 < earned.length) {
        rows.add(const SizedBox(height: 16));
      }
    }
    return Column(children: rows);
  }

  Widget _buildAchievedCard({required String icon, required String title, required String subtitle, required String xp}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(color: const Color(0xFFEBF5FF), borderRadius: BorderRadius.circular(16)),
      child: Column(children: [
        Text(icon, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 12),
        Text(title, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF1D4ED8))),
        const SizedBox(height: 4),
        Text(subtitle, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[600])),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFF1E88E5), borderRadius: BorderRadius.circular(12)),
          child: Text(xp, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ]),
    );
  }

  Widget _buildLockedAchievedCard({required String icon, required String title, required String subtitle, required String xp}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
          child: Center(child: Text(icon, style: const TextStyle(fontSize: 20)))),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[700])),
          Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[400])),
        ])),
        Text(xp, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[400])),
      ]),
    );
  }
}
