import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/auth_service.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';
import 'notification_preference_screen.dart';
import 'help_support_screen.dart';
import 'change_password_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Pengaturan",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Pengaturan Akun"),
            const SizedBox(height: 12),
            _buildSettingsGroup([
              _SettingItemData(
                icon: Icons.edit_outlined,
                title: "Edit Profil",
                onTap: () => Navigator.pushNamed(context, '/edit-profile'),
                showBorder: true,
              ),
              _SettingItemData(
                icon: Icons.lock_outline_rounded,
                title: "Ubah Kata Sandi",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen())),
                showBorder: true,
              ),
              _SettingItemData(
                icon: Icons.notifications_none_rounded,
                title: "Preferensi Notifikasi",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPreferenceScreen())),
                showBorder: false,
              ),
            ]),
            const SizedBox(height: 32),
            _buildSectionTitle("Informasi & Legal"),
            const SizedBox(height: 12),
            _buildSettingsGroup([
              _SettingItemData(
                icon: Icons.privacy_tip_outlined,
                title: "Kebijakan Privasi",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen())),
                showBorder: true,
              ),
              _SettingItemData(
                icon: Icons.description_outlined,
                title: "Syarat & Ketentuan",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsOfServiceScreen())),
                showBorder: true,
              ),
              _SettingItemData(
                icon: Icons.help_outline_rounded,
                title: "Pusat Bantuan",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen())),
                showBorder: false,
              ),
            ]),
            const SizedBox(height: 48),
            _buildLogoutButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: const Color(0xFF9CA3AF),
      ),
    );
  }

  Widget _buildSettingsGroup(List<_SettingItemData> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
      ),
      child: Column(
        children: items.map((item) => _buildSettingItem(item)).toList(),
      ),
    );
  }

  Widget _buildSettingItem(_SettingItemData item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(item.showBorder ? 0 : 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: item.showBorder ? const Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1.5)) : null,
        ),
        child: Row(
          children: [
            Icon(item.icon, color: const Color(0xFF4B5563), size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF4B5563),
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutDialog(context),
        icon: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 20),
        label: Text(
          "Keluar Akun",
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFDC2626),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFEF2F2),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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

class _SettingItemData {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showBorder;

  _SettingItemData({
    required this.icon,
    required this.title,
    required this.onTap,
    this.showBorder = false,
  });
}
