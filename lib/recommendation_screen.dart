import 'package:flutter/material.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  // Variabel untuk melacak tab mana yang sedang aktif
  String activeTab = "Semua";

  @override
  Widget build(BuildContext context) {
    const Color mainBlue = Color(0xFF007BFF);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: Column(
        children: [
          // --- HEADER BIRU (Persis Gambar) ---
          Container(
            padding: const EdgeInsets.fromLTRB(25, 60, 25, 30),
            decoration: const BoxDecoration(
              color: mainBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Rencana Intervensi",
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Skor risiko prediabetes personalmu",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTopStat(Icons.opacity, "18g", "Gula", Colors.red),
                    _buildTopStat(Icons.directions_run, "22 mnt", "Aktivitas", Colors.orange),
                    _buildTopStat(Icons.dark_mode, "6.5 jam", "Tidur", Colors.yellow),
                    _buildTopStat(Icons.local_drink, "6 gelas", "Air", Colors.lightBlueAccent),
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.white, size: 20),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Rencana 90 Hari — Hari 5", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text("3 fase intervensi terstruktur", style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- TAB FILTER (Bisa Digeser Horizontal) ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              children: [
                _buildFilterChip("Semua", "10", Icons.star),
                _buildFilterChip("Aktivitas", "2", Icons.directions_run),
                _buildFilterChip("Nutrisi", "3", Icons.restaurant),
                _buildFilterChip("Tidur", "2", Icons.bedtime),
                _buildFilterChip("Terapi", "1", Icons.medical_services),
                _buildFilterChip("Edukasi", "2", Icons.auto_awesome),
              ],
            ),
          ),

          // --- LIST KONTEN BERDASARKAN TAB ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                if (activeTab == "Semua" || activeTab == "Aktivitas") ...[
                  _buildTaskCard("Aktivitas", "Prioritas Tinggi", "Jalan Kaki 30 Menit Setelah Makan", Icons.directions_walk, Colors.green),
                  _buildTaskCard("Aktivitas", "", "Latihan Kekuatan 2x Seminggu", Icons.fitness_center, Colors.teal),
                ],
                if (activeTab == "Semua" || activeTab == "Nutrisi") ...[
                  _buildTaskCard("Nutrisi", "Prioritas Tinggi", "Metode Piring Harvard (Plate Method)", Icons.restaurant, Colors.orange),
                  _buildTaskCard("Nutrisi", "Prioritas Tinggi", "Eliminasi Minuman Manis & Ultra-Processed Food", Icons.block, Colors.redAccent),
                  _buildTaskCard("Nutrisi", "", "Pilih Karbohidrat Indeks Glikemik Rendah", Icons.grain, Colors.amber),
                ],
                if (activeTab == "Semua" || activeTab == "Tidur") ...[
                  _buildTaskCard("Tidur", "", "Konsisten Jadwal Tidur 7-8 jam", Icons.bedtime, Colors.indigo),
                  _buildTaskCard("Tidur", "", "Hindari Layar 1 Jam Sebelum Tidur", Icons.phonelink_off, Colors.blueGrey),
                ],
                if (activeTab == "Semua" || activeTab == "Terapi") ...[
                  _buildTaskCard("Terapi", "Prioritas Tinggi", "Rutin Minum Obat", Icons.medication, Colors.pink),
                ],
                if (activeTab == "Semua" || activeTab == "Edukasi") ...[
                  _buildTaskCard("Edukasi", "", "Memahami Resistensi Insulin", Icons.psychology, Colors.cyan),
                  _buildTaskCard("Edukasi", "", "Target HbA1c untuk Fase Prediabetes", Icons.bar_chart, Colors.blue),
                ],
                
                const SizedBox(height: 10),
                // --- FOOTER PERINGATAN (Penting Diketahui) ---
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F7F9),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFFB2EBF2)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Color(0xFF00838F), size: 18),
                          SizedBox(width: 8),
                          Text("Penting Diketahui", style: TextStyle(color: Color(0xFF00838F), fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Rekomendasi ini bersifat edukatif berdasarkan panduan klinis ADA dan WHO. Konsultasikan kondisi Anda dengan dokter atau ahli gizi terdaftar sebelum memulai program intervensi.",
                        style: TextStyle(color: Color(0xFF00838F), fontSize: 11, height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        selectedItemColor: mainBlue,
        onTap: (index) {
       if (index == 0) Navigator.pushReplacementNamed(context, '/dashboard');
          if (index == 1) Navigator.pushReplacementNamed(context, '/analysis');
          if (index == 2) Navigator.pushReplacementNamed(context, '/recommendation');
          if (index == 3) Navigator.pushReplacementNamed(context, '/progress'); // Pindah ke Progres
          if (index == 4) Navigator.pushReplacementNamed(context, '/profile');
        },
        // ---------------------------------------------

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: "Analisis"),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), label: "Rekomendasi"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Progres"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profil")
        ],
      ),
    );
  }

  Widget _buildTopStat(IconData icon, String value, String label, Color color) {
    return Container(
      width: 75,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String count, IconData icon) {
    bool isSelected = activeTab == label;
    return GestureDetector(
      onTap: () => setState(() => activeTab = label),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF007BFF) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [if (isSelected) BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.orange),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: isSelected ? Colors.white24 : Colors.grey.shade100, shape: BoxShape.circle),
              child: Text(count, style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(String category, String priority, String title, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.08), borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(category, style: TextStyle(color: iconColor, fontWeight: FontWeight.bold, fontSize: 11)),
                    if (priority.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(4)),
                        child: Text(priority, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 9)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.black26),
        ],
      ),
    );
  }
}