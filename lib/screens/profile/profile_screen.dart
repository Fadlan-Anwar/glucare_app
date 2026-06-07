import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/user_provider.dart';
import '../auth/auth_service.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "Profil Saya",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF111827),
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder<UserData>(
        valueListenable: UserProvider.userNotifier,
        builder: (context, userData, child) {
          return SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildHeader(context, userData),
                const SizedBox(height: 40),
                _buildSectionTitle('Informasi Pribadi'),
                const SizedBox(height: 12),
                _buildInfoCard(userData),
                const SizedBox(height: 32),
                _buildSectionTitle('Preferensi & Keamanan'),
                const SizedBox(height: 12),
                _buildSettingsCard(context),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserData userData) {
    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: const Color(0xFFF3F4F6),
          child: ClipOval(
            child: userData.profileImage != null
                ? (kIsWeb 
                    ? Image.network(userData.profileImage!.path, fit: BoxFit.cover, width: 96, height: 96)
                    : Image.file(userData.profileImage!, fit: BoxFit.cover, width: 96, height: 96))
                : (userData.profileImageUrl != null && userData.profileImageUrl!.isNotEmpty
                    ? Image.network(userData.profileImageUrl!, fit: BoxFit.cover, width: 96, height: 96)
                    : Image.network(
                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                        fit: BoxFit.cover,
                        width: 96,
                        height: 96,
                      )),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          userData.name,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          userData.email,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => Navigator.pushNamed(context, '/edit-profile'),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Edit Profil',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF374151),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: const Color(0xFF9CA3AF),
        ),
      ),
    );
  }

  Widget _buildInfoCard(UserData userData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
      ),
      child: Column(
        children: [
          _buildInfoTile('Jenis Kelamin', userData.gender, showBorder: true),
          _buildInfoTile('Nomor HP', '+62 ${userData.phone}', showBorder: true),
          _buildInfoTile('Kata Sandi', '********', showBorder: false),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, {bool showBorder = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: showBorder ? const Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1.5)) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF4B5563),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
      ),
      child: Column(
        children: [
          _buildActionTile(Icons.settings_outlined, 'Pengaturan Aplikasi', () {
            Navigator.pushNamed(context, '/settings');
          }, showBorder: true),
          _buildActionTile(Icons.help_outline_rounded, 'Pusat Bantuan', () {}, showBorder: true),
          _buildActionTile(Icons.logout_rounded, 'Keluar', () {
            _showLogoutDialog(context);
          }, isDestructive: true, showBorder: false),
        ],
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title, VoidCallback onTap, {bool showBorder = false, bool isDestructive = false}) {
    final color = isDestructive ? const Color(0xFFEF4444) : const Color(0xFF4B5563);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(showBorder ? 0 : 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: showBorder ? const Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1.5)) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            if (!isDestructive)
              Icon(Icons.chevron_right_rounded, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.logout_rounded, color: Color(0xFFDC2626)),
            const SizedBox(width: 10),
            Text(
              'Keluar',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: const Color(0xFF111827),
              ),
            ),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari akun ini?',
          style: GoogleFonts.poppins(
            color: const Color(0xFF4B5563),
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await AuthService.logout();
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              'Keluar',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
