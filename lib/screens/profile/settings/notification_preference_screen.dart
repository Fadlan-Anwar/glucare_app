import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class NotificationPreferenceScreen extends StatefulWidget {
  const NotificationPreferenceScreen({super.key});

  @override
  State<NotificationPreferenceScreen> createState() => _NotificationPreferenceScreenState();
}

class _NotificationPreferenceScreenState extends State<NotificationPreferenceScreen> {
  bool _mealReminders = true;
  bool _weeklyReports = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Container(width: double.infinity, height: 160,
          decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.gradientBlueLight, AppColors.mainBlue]), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
          child: SafeArea(child: Stack(children: [
            Positioned(top: 10, left: 10, child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 22), onPressed: () => Navigator.pop(context))),
            const Center(child: Padding(padding: EdgeInsets.only(top: 20), child: Text("Notification Preference", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)))),
          ]))),
        const SizedBox(height: 30),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.lightBlueBg, borderRadius: BorderRadius.circular(25)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Notification Preference", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 20),
              _buildItem("Meal Reminders", Switch(value: _mealReminders, activeColor: Colors.white, activeTrackColor: AppColors.mainBlue, onChanged: (v) => setState(() => _mealReminders = v))),
              _buildItem("Medication Alerts", _buildChip("Set-time")),
              _buildItem("Daily Health Tips", _buildChip("Medication Name")),
              _buildItem("weekly Resports", Switch(value: _weeklyReports, activeColor: Colors.white, activeTrackColor: AppColors.mainBlue, onChanged: (v) => setState(() => _weeklyReports = v))),
            ]))),
      ]),
    );
  }

  Widget _buildItem(String title, Widget trailing) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontSize: 14)), trailing]));

  Widget _buildChip(String label) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(15)), child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)));
}
