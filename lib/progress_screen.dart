import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color mainBlue = Color(0xFF007BFF);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: mainBlue,
        elevation: 0,
        title: const Text("Progres & Evaluasi", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER BIRU - STREAK & LEVEL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.bottom(25),
              decoration: const BoxDecoration(
                color: mainBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30), 
                  bottomRight: Radius.circular(30)
                ),
              ),
              child: Column(
                children: [
                  const Text("Pantau intervensi metabolik harianmu", 
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildHeaderStat("1 hari", "Streak", Icons.local_fire_department, Colors.orange),
                      _buildHeaderStat("8", "Level", Icons.bolt, Colors.yellow),
                      _buildHeaderStat("4", "Pencapaian", Icons.emoji_events, Colors.redAccent),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // TAB SELECTOR (90 Hari, Pencapaian, Evaluasi)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    _buildTabItem("90 Hari", true),
                    _buildTabItem("Pencapaian", false),
                    _buildTabItem("Evaluasi", false),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // KARTU LINGKARAN PROGRES (5%)
            _buildProgressCircleCard(),

            const SizedBox(height: 20),

            // TARGET HARI INI (GRIID STATS)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Target Hari Ini", 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("Hari 5", style: TextStyle(color: mainBlue.withOpacity(0.7), fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildTargetGrid(),

            const SizedBox(height: 25),
          ],
        ),
      ),

      // BOTTOM NAVBAR
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3, // Index 3 untuk Progres
        selectedItemColor: mainBlue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/dashboard');
          if (index == 1) Navigator.pushReplacementNamed(context, '/analysis');
          if (index == 2) Navigator.pushReplacementNamed(context, '/recommendation');
          if (index == 3) Navigator.pushReplacementNamed(context, '/progress');
          if (index == 4) Navigator.pushReplacementNamed(context, '/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: "Analisis"),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), label: "Rekomendasi"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Progres"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profil"),
        ],
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildHeaderStat(String value, String label, IconData icon, Color iconColor) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }

  Widget _buildTabItem(String title, bool isActive) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF007BFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(title, 
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey, 
              fontWeight: FontWeight.bold,
              fontSize: 12
            )),
        ),
      ),
    );
  }

  Widget _buildProgressCircleCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          // Lingkaran Progres Sederhana
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: 0.05,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF007BFF)),
                ),
              ),
              const Column(
                children: [
                  Text("5%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("selesai", style: TextStyle(fontSize: 8, color: Colors.grey)),
                ],
              )
            ],
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Intervensi 90 Hari", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("Hari ke-5 dari 90", style: TextStyle(color: Colors.grey, fontSize: 13)),
                SizedBox(height: 5),
                Text("85 hari tersisa • Fase 1/3", style: TextStyle(color: Color(0xFF007BFF), fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTargetGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.4,
        children: [
          _buildStatItem("18g", "/ 40g", "Gula", 0.45, Colors.blue, Icons.bloodtype),
          _buildStatItem("22 mnt", "/ 21 mnt", "Aktivitas", 1.0, Colors.teal, Icons.directions_run),
          _buildStatItem("6.5 jam", "/ 8 jam", "Tidur", 0.81, Colors.orange, Icons.sentiment_satisfied),
          _buildStatItem("6 gelas", "/ 8 gelas", "Air", 0.75, Colors.lightBlueAccent, Icons.water_drop),
        ],
      ),
    );
  }

  Widget _buildStatItem(String val, String target, String label, double progress, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 18, color: color.withOpacity(0.7)),
              Text("${(progress * 100).toInt()}%", style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(target, style: const TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          )
        ],
      ),
    );
  }
}