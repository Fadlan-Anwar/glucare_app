import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
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
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20), onPressed: () => Navigator.pop(context)),
        title: const Text("Profile Settings", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Account Settings", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: AppColors.lightBlueBg, borderRadius: BorderRadius.circular(20)),
            child: Column(children: [
              _SettingItem(icon: Icons.edit_outlined, title: "Edit Profile Details", onTap: () => Navigator.pushNamed(context, '/edit-profile')),
              const Divider(color: Colors.white, thickness: 1),
              _SettingItem(
                icon: Icons.key_outlined,
                title: "Change Password",
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen())),
              ),
              const Divider(color: Colors.white, thickness: 1),
              _SettingItem(icon: Icons.notifications_none_outlined, title: "Notification Preference", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPreferenceScreen()))),
            ])),
          const SizedBox(height: 30),
          const Text("App Information & Legal", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: AppColors.lightBlueBg, borderRadius: BorderRadius.circular(20)),
            child: Column(children: [
              _SettingItem(icon: Icons.lock_outline, title: "Privacy Policy", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()))),
              const Divider(color: Colors.white, thickness: 1),
              _SettingItem(icon: Icons.description_outlined, title: "Terms of Service", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()))),
              const Divider(color: Colors.white, thickness: 1),
              _SettingItem(icon: Icons.help_outline, title: "Help & Support", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen()))),
            ])),
          const SizedBox(height: 50),
          _buildLogoutButton(context),
        ]),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) => SizedBox(width: double.infinity,
    child: Container(decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.gradientBlueLight, AppColors.mainBlue]), borderRadius: BorderRadius.circular(15)),
      child: ElevatedButton(onPressed: () => _showLogoutDialog(context),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 15)),
        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.logout, color: Colors.white), SizedBox(width: 10), Text("Logout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]))));

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout, color: AppColors.mainBlue),
            SizedBox(width: 10),
            Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              await AuthService.logout();
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon; final String title; final VoidCallback onTap;
  const _SettingItem({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: onTap, child: Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppColors.mainBlue, size: 20)),
        const SizedBox(width: 15), Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)), const Spacer(), const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black54),
      ])));
  }
}
