import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    double progress = 5 / 90;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),

            const SizedBox(height: 15),

            _buildTabs(),

            const SizedBox(height: 15),

            _buildProgressCard(progress),

            const SizedBox(height: 20),

            _sectionTitle("Target Hari Ini"),
            _buildTargetGrid(),

            const SizedBox(height: 10),

            _sectionTitle("Fase Intervensi"),
            _buildFaseSection(),

            const SizedBox(height: 10),

            _sectionTitle("Level & XP"),
            _buildLevelSection(),

            const SizedBox(height: 10),

            _sectionTitle("Tugas Harian", trailing: "0/6"),
            _buildTaskSection(),

            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNav(context),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Progres & Evaluasi",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text("Pantau intervensi metabolik harianmu",
              style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(child: _statCard("🔥", "1 hari", "Streak")),
              const SizedBox(width: 10),
              Expanded(child: _statCard("⚡", "8", "Level")),
              const SizedBox(width: 10),
              Expanded(child: _statCard("🏅", "4", "Pencapaian")),
            ],
          )
        ],
      ),
    );
  }

  Widget _statCard(String icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 5),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }

  // ================= TAB =================
  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            _tab("90 Hari", 0),
            _tab("Pencapaian", 1),
            _tab("Evaluasi", 2),
          ],
        ),
      ),
    );
  }

  Widget _tab(String text, int index) {
    bool active = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: active ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= PROGRESS =================
  Widget _buildProgressCard(double progress) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                ),
              ),
              Text("${(progress * 100).toInt()}%"),
            ],
          ),
          const SizedBox(width: 20),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Intervensi 90 Hari",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Hari ke-5 dari 90",
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text("85 hari tersisa • Fase 1/3",
                  style: TextStyle(color: Colors.blue, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  // ================= TARGET =================
  Widget _sectionTitle(String title, {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          if (trailing != null)
            Text(trailing,
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTargetGrid() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.45,
        children: [
          _targetCard("Gula", "18g", "/40g", 0.45, Colors.blue),
          _targetCard("Aktivitas", "22 mnt", "/21 mnt", 1.0, Colors.teal),
          _targetCard("Tidur", "6.5 jam", "/8 jam", 0.8, Colors.orange),
          _targetCard("Air", "6 gelas", "/8 gelas", 0.75, Colors.lightBlue),
        ],
      ),
    );
  }

  Widget _targetCard(
      String title, String value, String target, double progress, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${(progress * 100).toInt()}%",
              style: TextStyle(color: color, fontSize: 10)),
          const SizedBox(height: 5),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Text(target,
              style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 5),

          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                color: color,
              );
            },
          ),

          const SizedBox(height: 5),
          Text(title,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  // ================= FASE =================
  Widget _buildFaseSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _faseItem(1, true),
          _faseItem(2, false),
          _faseItem(3, false),
        ],
      ),
    );
  }

  Widget _faseItem(int index, bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: active ? Colors.blue.withOpacity(0.08) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
        border: active ? Border.all(color: Colors.blue) : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: active ? Colors.blue : Colors.grey,
            child: Text("$index",
                style:
                    const TextStyle(color: Colors.white, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Stabilisasi Dasar",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text("Hari 1–30",
                    style: TextStyle(fontSize: 11, color: Colors.grey)),
                SizedBox(height: 5),
                Text("🍬 ≤40g   🏃 150 mnt   😴 7 jam",
                    style: TextStyle(fontSize: 10)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ================= LEVEL =================
  Widget _buildLevelSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Level & XP"),
              Text("⚡ Level 8", style: TextStyle(color: Colors.orange)),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(value: 0.08, color: Colors.orange),
          const SizedBox(height: 5),
          const Text("195 / 2400 XP"),
        ],
      ),
    );
  }

  // ================= TASK =================
  Widget _buildTaskSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          _taskItem("Jalan kaki 30 menit", "+25 XP"),
          _taskItem("Batasi gula < 25g hari ini", "+30 XP"),
        ],
      ),
    );
  }

  Widget _taskItem(String text, String xp) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.radio_button_unchecked, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
          Text(xp, style: const TextStyle(color: Colors.orange)),
        ],
      ),
    );
  }

  // ================= NAV =================
  Widget _bottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 3,
      type: BottomNavigationBarType.fixed,
      onTap: (i) {
        if (i == 0) Navigator.pushReplacementNamed(context, '/dashboard');
        if (i == 4) Navigator.pushReplacementNamed(context, '/profile');
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Analisis"),
        BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: "Rekomendasi"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Progres"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
      ],
    );
  }
}