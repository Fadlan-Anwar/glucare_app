import 'package:flutter/material.dart';

// --- 1. HALAMAN PRIVACY POLICY (SESUAI GAMBAR 1) ---
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color mainBlue = Color(0xFF007BFF);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF), // Background biru sangat muda
      body: Column(
        children: [
          // Header Biru dengan Judul (Style konsisten dengan Notification)
          Container(
            width: double.infinity,
            height: 150,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF66B2FF), mainBlue],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Privacy Policy",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 30),

          // Konten Privacy Policy dalam Kotak Putih (Sesuai Gambar 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Privacy Policy",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Kami menghargai privasi Anda. Informasi yang kami kumpulkan:",
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 10),
                  _buildBulletPoint("Data akun (Nama, Email)"),
                  _buildBulletPoint("Data Pengguna Aplikasi"),
                  const SizedBox(height: 20),
                  const Text(
                    "Kami menggunakan Data untuk:",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildBulletPoint("Meningkatkan Layanan"),
                  _buildBulletPoint("Memberikan Pengalaman pengguna yang lebih"),
                  const SizedBox(height: 20),
                  const Text(
                    "Keamanan Data",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Kami menjaga data Anda dengan keamanan sistem yang terbaik",
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                  const SizedBox(height: 30),
                  const Center(
                    child: Text(
                      "Apabila ada pertanyaan hubungi kami disini",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.email_outlined, color: mainBlue, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        "nusahealt228@gmaul.com", // Typo gmaul disesuaikan dengan gambar
                        style: TextStyle(color: Colors.blue[700], fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 8, color: Colors.blue),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 2. UPDATE SETTINGS SCREEN ---
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color lightBlueBg = Color(0xFFCDE4FF);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Profile Settings", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Account Settings", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: lightBlueBg, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  _SettingItem(icon: Icons.edit_outlined, title: "Edit Profile Details", onTap: () {}),
                  const Divider(color: Colors.white),
                  _SettingItem(icon: Icons.key_outlined, title: "Change Password", onTap: () {}),
                  const Divider(color: Colors.white),
                  _SettingItem(icon: Icons.notifications_none_outlined, title: "Notification Preference", onTap: () {}),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text("App Information & Legal", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: lightBlueBg, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  // --- TOMBOL PRIVACY POLICY SEKARANG SUDAH AKTIF ---
                  _SettingItem(
                    icon: Icons.lock_outline, 
                    title: "Privacy Policy", 
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                      );
                    },
                  ),
                  const Divider(color: Colors.white),
                  _SettingItem(icon: Icons.description_outlined, title: "Terms of Service", onTap: () {}),
                  const Divider(color: Colors.white),
                  _SettingItem(icon: Icons.help_outline, title: "Help & Support", onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Item Setting yang sama seperti sebelumnya
class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _SettingItem({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: Colors.blue, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black54),
      contentPadding: EdgeInsets.zero,
    );
  }
}