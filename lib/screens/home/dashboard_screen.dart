import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Konten dashboard — tanpa Scaffold/bottomNav sendiri.
/// Dibungkus oleh MainNavShell.
class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGray,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        child: const Icon(Icons.smart_toy_outlined, color: AppColors.mainBlue, size: 30),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // --- 1. HEADER PROFIL ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('assets/images/profile_user.png'),
                        backgroundColor: Colors.blueGrey,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Good Morning",
                              style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text(
                            "Hello, Fadlan!",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Badge(
                    label: Text("1"),
                    child: Icon(Icons.notifications_none_outlined, size: 28),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // --- 2. BANNER STATUS RISIKO ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.mainBlue,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mainBlue.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Status Risiko",
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 8),
                    const Text(
                      "Belum Ada Data Risiko",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Yuk mulai penilaian untuk melihat kondisi kesehatan Anda saat ini.",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/analysis'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.mainBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Cek Risiko Sekarang",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_ios, size: 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- 3. ROW STREAK & INTERVENSI ---
              Row(
                children: [
                  _buildStatCard("Streak", "0", "Hari Aktif",
                      Icons.local_fire_department, Colors.orange),
                  const SizedBox(width: 15),
                  _buildStatCard("Intervensi", "0%", "Hari 0/90",
                      Icons.trending_up, Colors.blue),
                ],
              ),

              const SizedBox(height: 30),

              // --- 4. REMINDER PREVIEW ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("⏰ Reminder Preview",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                      onPressed: () {},
                      child: const Text("Kelola",
                          style: TextStyle(color: AppColors.mainBlue))),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    _buildReminderItem("07:30", "Cek Gula Darah Pagi",
                        Colors.red, Icons.bloodtype),
                    const Divider(height: 1),
                    _buildReminderItem("13:00", "Makan Siang Sehat",
                        Colors.green, Icons.restaurant),
                    const Divider(height: 1),
                    _buildReminderItem("19:00", "Aktivitas Fisik Sore",
                        Colors.orange, Icons.directions_run),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, String sub, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 12),
            Text(value,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 10),
            Container(
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(2)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderItem(
      String time, String task, Color iconCol, IconData icon) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: iconCol.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8)),
        child: Text(time,
            style: TextStyle(
                color: iconCol, fontWeight: FontWeight.bold, fontSize: 12)),
      ),
      title: Text(task,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: Icon(icon, color: iconCol, size: 20),
    );
  }
}
