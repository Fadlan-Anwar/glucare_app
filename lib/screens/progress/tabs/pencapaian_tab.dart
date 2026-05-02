import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class PencapaianTab extends StatelessWidget {
  const PencapaianTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                Text('(4)', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF10B981))),
              ]),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: _buildAchievedCard(icon: '⭐', title: 'First Step!', subtitle: 'Selesaikan tugas pertama', xp: '+50 XP')),
                const SizedBox(width: 16),
                Expanded(child: _buildAchievedCard(icon: '🩺', title: 'Health Aware', subtitle: 'Selesaikan risk assessment', xp: '+150 XP')),
              ]),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: _buildAchievedCard(icon: '📅', title: 'Planner Pro', subtitle: 'Buat rencana 90 hari', xp: '+80 XP')),
                const SizedBox(width: 16),
                Expanded(child: _buildAchievedCard(icon: '📊', title: 'Progress Check', subtitle: 'Lakukan re-assessment', xp: '+200 XP')),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 24),
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
                Text('(5)', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[500])),
              ]),
              const SizedBox(height: 16),
              _buildLockedAchievedCard(icon: '🔥', title: '3 Days Strong', subtitle: '3 hari berturut-turut aktif', xp: '+ 100 XP'),
              _buildLockedAchievedCard(icon: '💪', title: 'Week Warrior', subtitle: '7 hari berturut-turut', xp: '+ 200 XP'),
              _buildLockedAchievedCard(icon: '🏆', title: 'Monthly Master', subtitle: '30 hari berturut-turut', xp: '+ 500 XP'),
              _buildLockedAchievedCard(icon: '✨', title: 'Makan Sehat', subtitle: 'Pilihan makan siang sehat', xp: '+ 600 XP'),
              _buildLockedAchievedCard(icon: '🎯', title: 'Makan Sehat', subtitle: 'Pilihan makan siang sehat', xp: '+ 700 XP'),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
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
