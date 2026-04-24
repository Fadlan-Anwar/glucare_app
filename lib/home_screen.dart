import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  final String userName;
  const HomeContent({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // --- HEADER BIRU ---
          Container(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 35),
            decoration: const BoxDecoration(
              color: Color(0xFF007BFF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35), 
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 26, 
                  backgroundColor: Colors.white, 
                  child: Icon(Icons.person, color: Color(0xFF007BFF), size: 30),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Selamat Pagi,", 
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                    Text("Halo, $userName!", 
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.notifications_none, color: Colors.white, size: 28),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              children: [
                // --- KARTU STATUS RISIKO ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF007BFF), 
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Status Risiko", 
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 5),
                      const Text("Belum Ada Data", 
                        style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/analysis'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, 
                            foregroundColor: const Color(0xFF007BFF),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Text("Cek Risiko Sekarang >", 
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // --- STATISTIK (STREAK & INTERVENSI) ---
                Row(
                  children: [
                    _buildStatCard("Streak", "0", "Hari Aktif", Icons.local_fire_department, Colors.orange),
                    const SizedBox(width: 15),
                    _buildStatCard("Intervensi", "0%", "Progres 90 Hari", Icons.trending_up, Colors.blue),
                  ],
                ),

                const SizedBox(height: 25),

                // --- REMINDER PREVIEW ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Reminder Preview", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          TextButton(
                            onPressed: () {}, 
                            child: const Text("Kelola", style: TextStyle(color: Colors.blue, fontSize: 13))
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildReminderItem("07:30", "Cek Gula Darah Pagi", Colors.blue),
                      _buildReminderItem("13:00", "Makan Siang Sehat", Colors.blue),
                      _buildReminderItem("19:00", "Aktivitas Fisik Sore", Colors.blue),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String val, String sub, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20), 
                const SizedBox(width: 8), 
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 12),
            Text(val, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderItem(String time, String title, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Text(time, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(width: 15),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}