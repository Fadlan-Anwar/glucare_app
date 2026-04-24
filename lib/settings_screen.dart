import 'package:flutter/material.dart';

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
        title: const Text(
          "Profile Settings",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Account Settings",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            
            // Container Account Settings
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: lightBlueBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _SettingItem(
                    icon: Icons.edit_outlined, 
                    title: "Edit Profile Details",
                    onTap: () {
                      // Ini perintah buat pindah ke halaman edit profil
                      Navigator.pushNamed(context, '/edit-profile');
                    },
                  ),
                  const Divider(color: Colors.white, thickness: 1),
                  _SettingItem(
                    icon: Icons.key_outlined, 
                    title: "Change Password",
                    onTap: () {
                      // Navigasi ganti password di sini nanti
                    },
                  ),
                  const Divider(color: Colors.white, thickness: 1),
                  _SettingItem(
                    icon: Icons.notifications_none_outlined, 
                    title: "Notification Preference",
                    onTap: () {
                      // Navigasi notifikasi di sini nanti
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              "App Information & Legal",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // Container App Info
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: lightBlueBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _SettingItem(icon: Icons.lock_outline, title: "Privacy Policy", onTap: () {}),
                  const Divider(color: Colors.white, thickness: 1),
                  _SettingItem(icon: Icons.description_outlined, title: "Terms of Service", onTap: () {}),
                  const Divider(color: Colors.white, thickness: 1),
                  _SettingItem(icon: Icons.help_outline, title: "Help & Support", onTap: () {}),
                ],
              ),
            ),

            const SizedBox(height: 50),
            
            // Tombol Logout
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF66B2FF), Color(0xFF007BFF)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Balik ke login dan hapus semua history page sebelumnya
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Logout", 
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Komponen Item Settings yang mendukung interaksi klik
class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap; // Fungsi yang akan dijalankan saat diklik

  const _SettingItem({
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Memanggil fungsi navigasi
      borderRadius: BorderRadius.circular(10), // Biar efek riaknya rapi
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
              title, 
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}