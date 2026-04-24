import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color mainBlue = Color(0xFF007BFF);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // AKSI: Klik ikon gear untuk ke halaman Profile Settings
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Foto Profil dengan ring warna biru utama
          Center(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: mainBlue,
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                // Pastikan file gambar ini sudah terdaftar di pubspec.yaml
                backgroundImage: AssetImage('assets/images/profile_user.png'),
              ),
            ),
          ),
          const SizedBox(height: 40),
          
          // Card Informasi Profil (Warna Biru Muda CDE4FF)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFCDE4FF), 
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildProfileItem(Icons.person, "Nama", "Fadlan"), // Nama User
                  const Divider(color: Colors.white54, thickness: 1),
                  _buildProfileItem(Icons.male, "Jenis Kelamin", "laki-laki"),
                  const Divider(color: Colors.white54, thickness: 1),
                  _buildProfileItem(Icons.phone_android, "Nomor Hp", "+6281234567890"),
                  const Divider(color: Colors.white54, thickness: 1),
                  _buildProfileItem(Icons.email, "Email", "fadlanf553@gmail.com"), // Email User
                ],
              ),
            ),
          ),
        ],
      ),
      // Navigasi Bawah Aktif
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, // Index 4 untuk tab Profil
        type: BottomNavigationBarType.fixed,
        selectedItemColor: mainBlue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/dashboard');
          if (index == 1) Navigator.pushReplacementNamed(context, '/analysis');
          if (index == 4) Navigator.pushReplacementNamed(context, '/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), label: "Analisis"),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), label: "Rekomendasi"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Progres"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }

  // Widget Helper untuk baris informasi profil
  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF007BFF), size: 20),
          ),
          const SizedBox(width: 15),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}