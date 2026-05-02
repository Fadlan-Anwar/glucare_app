import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Konten tab Profil — tanpa bottomNav sendiri.
class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        automaticallyImplyLeading: false, // Tidak ada tombol back di tab
        title: const Text("Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.settings, color: Colors.black), onPressed: () => Navigator.pushNamed(context, '/settings'))],
      ),
      body: Column(children: [
        const SizedBox(height: 20),
        Center(child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: AppColors.mainBlue, shape: BoxShape.circle),
          child: const CircleAvatar(radius: 50, backgroundColor: Colors.grey, backgroundImage: AssetImage('assets/images/profile_user.png')))),
        const SizedBox(height: 40),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.lightBlueBg, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))]),
            child: Column(children: [
              _buildProfileItem(Icons.person, "Nama", "Fadlan"),
              const Divider(color: Colors.white54, thickness: 1),
              _buildProfileItem(Icons.male, "Jenis Kelamin", "laki-laki"),
              const Divider(color: Colors.white54, thickness: 1),
              _buildProfileItem(Icons.phone_android, "Nomor Hp", "+6281234567890"),
              const Divider(color: Colors.white54, thickness: 1),
              _buildProfileItem(Icons.email, "Email", "fadlanf553@gmail.com"),
            ]))),
      ]),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: AppColors.mainBlue, size: 20)),
        const SizedBox(width: 15),
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ]));
  }
}
