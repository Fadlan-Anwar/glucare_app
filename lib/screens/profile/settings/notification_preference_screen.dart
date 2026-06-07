import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPreferenceScreen extends StatefulWidget {
  const NotificationPreferenceScreen({super.key});

  @override
  State<NotificationPreferenceScreen> createState() => _NotificationPreferenceScreenState();
}

class _NotificationPreferenceScreenState extends State<NotificationPreferenceScreen> {
  bool _mealReminders = true;
  bool _medicationAlerts = true;
  bool _dailyTips = true;
  bool _weeklyReports = true;

  @override
  Widget build(BuildContext context) {
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
                    title: "Pengingat Makan",
                    trailing: Switch(
                      value: _mealReminders,
                      activeThumbColor: Colors.white,
                      activeTrackColor: const Color(0xFF007BFF),
                      onChanged: (v) => setState(() => _mealReminders = v),
                    ),
                    showBorder: true,
                  ),
                  _buildItem(
                    title: "Peringatan Konsumsi Obat",
                    trailing: Switch(
                      value: _medicationAlerts,
                      activeThumbColor: Colors.white,
                      activeTrackColor: const Color(0xFF007BFF),
                      onChanged: (v) => setState(() => _medicationAlerts = v),
                    ),
                    showBorder: _medicationAlerts || _dailyTips || _weeklyReports,
                  ),
                  if (_medicationAlerts)
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1.5)),
                      ),
                      child: Row(
                        children: [
                          _buildTimeBadge("08:00 WIB"),
                          const SizedBox(width: 8),
                          _buildTimeBadge("20:00 WIB"),
                        ],
                      ),
                    ),
                  _buildItem(
                    title: "Tips Kesehatan Harian",
                    trailing: Switch(
                      value: _dailyTips,
                      activeThumbColor: Colors.white,
                      activeTrackColor: const Color(0xFF007BFF),
                      onChanged: (v) => setState(() => _dailyTips = v),
                    ),
                    showBorder: true,
                  ),
                  _buildItem(
                    title: "Laporan Mingguan",
                    trailing: Switch(
                      value: _weeklyReports,
                      activeThumbColor: Colors.white,
                      activeTrackColor: const Color(0xFF007BFF),
                      onChanged: (v) => setState(() => _weeklyReports = v),
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
