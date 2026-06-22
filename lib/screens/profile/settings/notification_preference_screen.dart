import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/providers/notification_provider.dart';

class NotificationPreferenceScreen extends ConsumerWidget {
  const NotificationPreferenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDailyReminderOn = ref.watch(dailyReminderProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF111827), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Preferensi Notifikasi",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF111827),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "PENGATURAN NOTIFIKASI",
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: const Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
              ),
              child: Column(
                children: [
                  _buildItem(
                    title: "Pengingat Target Harian",
                    trailing: Switch(
                      value: isDailyReminderOn,
                      activeThumbColor: Colors.white,
                      activeTrackColor: const Color(0xFF007BFF),
                      onChanged: (val) async {
                        await ref.read(dailyReminderProvider.notifier).toggle(val);
                        if (val) {
                          await NotificationService().scheduleDailyReminder();
                        } else {
                          await NotificationService().cancelDailyReminder();
                        }
                      },
                    ),
                    showBorder: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required String title,
    required Widget trailing,
    required bool showBorder,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: showBorder ? const Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1.5)) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF374151),
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildTimeBadge(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time_filled_rounded, size: 14, color: Color(0xFF4B5563)),
          const SizedBox(width: 6),
          Text(
            time,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }
}
