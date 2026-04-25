import 'package:flutter/material.dart';

// ---------------------------------------------------------
// 1. HALAMAN TERMS OF SERVICE
// ---------------------------------------------------------
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color mainBlue = Color(0xFF007BFF);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 160,
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
                        "Term Of Service",
                        style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Dengan Menggunakan aplikasi ini Anda setuju untuk:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 20),
                      _buildNumberedPoint("1", "Tidak menyalahgunakan layanan"),
                      _buildNumberedPoint("2", "Tidak melanggar Hukum"),
                      _buildNumberedPoint("3", "Menjaga Keamanan akun Anda"),
                      const SizedBox(height: 25),
                      const Text("Kami Berhak:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      _buildArrowPoint("Menghapus akun anda jika melanggar aturan"),
                      _buildArrowPoint("Mengubah Layanan sewaktu-waktu"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade300)),
                  child: const Center(child: Text("Terakhir di Perbarui: 29-03-2026", style: TextStyle(fontSize: 13, color: Colors.black87))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedPoint(String num, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [
      Container(width: 22, height: 22, decoration: const BoxDecoration(color: Color(0xFF007BFF), shape: BoxShape.circle), child: Center(child: Text(num, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)))),
      const SizedBox(width: 12),
      Text(text, style: const TextStyle(fontSize: 14))
    ]),
  );

  Widget _buildArrowPoint(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Icon(Icons.trending_flat, size: 20, color: Colors.black),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 14)))
    ]),
  );
}

// ---------------------------------------------------------
// 2. HALAMAN PRIVACY POLICY
// ---------------------------------------------------------
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color mainBlue = Color(0xFF007BFF);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 160,
            decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF66B2FF), mainBlue]),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(top: 10, left: 10, child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 22), onPressed: () => Navigator.pop(context))),
                  const Center(child: Padding(padding: EdgeInsets.only(top: 20), child: Text("Privacy Policy", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Privacy Policy", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  const Text("Kami menghargai privasi Anda. Informasi yang kami kumpulkan:", style: TextStyle(fontSize: 14, height: 1.5)),
                  const SizedBox(height: 10),
                  _buildBullet("Data akun (Nama, Email)"),
                  _buildBullet("Data Pengguna Aplikasi"),
                  const SizedBox(height: 20),
                  const Text("Kami menggunakan Data untuk:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildBullet("Meningkatkan Layanan"),
                  _buildBullet("Memberikan Pengalaman pengguna yang lebih"),
                  const SizedBox(height: 20),
                  const Text("Keamanan Data", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text("Kami menjaga data Anda dengan keamanan sistem yang terbaik", style: TextStyle(fontSize: 13)),
                  const SizedBox(height: 30),
                  const Center(child: Text("Apabila ada pertanyaan hubungi kami disini", style: TextStyle(fontSize: 12, color: Colors.grey))),
                  const SizedBox(height: 10),
                  const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.email_outlined, color: mainBlue, size: 18),
                    SizedBox(width: 8),
                    Text("nusahealt228@gmaul.com", style: TextStyle(color: mainBlue, fontWeight: FontWeight.bold)),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBullet(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [const Icon(Icons.circle, size: 8, color: Colors.blue), const SizedBox(width: 10), Text(text, style: const TextStyle(fontSize: 14))]),
  );
}

// ---------------------------------------------------------
// 3. HALAMAN NOTIFICATION PREFERENCE
// ---------------------------------------------------------
class NotificationPreferenceScreen extends StatefulWidget {
  const NotificationPreferenceScreen({super.key});

  @override
  State<NotificationPreferenceScreen> createState() => _NotificationPreferenceScreenState();
}

class _NotificationPreferenceScreenState extends State<NotificationPreferenceScreen> {
  bool _mealReminders = true;
  bool _weeklyReports = true;

  @override
  Widget build(BuildContext context) {
    const Color mainBlue = Color(0xFF007BFF);
    const Color lightBlueBg = Color(0xFFCDE4FF);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 160,
            decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF66B2FF), mainBlue]),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(top: 10, left: 10, child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 22), onPressed: () => Navigator.pop(context))),
                  const Center(child: Padding(padding: EdgeInsets.only(top: 20), child: Text("Notification Preference", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: lightBlueBg, borderRadius: BorderRadius.circular(25)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Notification Preference", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _buildItem("Meal Reminders", Switch(value: _mealReminders, activeColor: Colors.white, activeTrackColor: mainBlue, onChanged: (v) => setState(() => _mealReminders = v))),
                  _buildItem("Medication Alerts", _buildChip("Set-time")),
                  _buildItem("Daily Health Tips", _buildChip("Medication Name")),
                  _buildItem("weekly Resports", Switch(value: _weeklyReports, activeColor: Colors.white, activeTrackColor: mainBlue, onChanged: (v) => setState(() => _weeklyReports = v))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title, Widget trailing) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontSize: 14)), trailing]),
  );

  Widget _buildChip(String label) => Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(15)), child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)));
}

// ---------------------------------------------------------
// 4. HALAMAN HELP & SUPPORT
// ---------------------------------------------------------
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color mainBlue = Color(0xFF007BFF);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 160,
            decoration: const BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF66B2FF), mainBlue]),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(top: 10, left: 10, child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 22), onPressed: () => Navigator.pop(context))),
                  const Center(child: Padding(padding: EdgeInsets.only(top: 20), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.help_outline, color: Colors.black), SizedBox(width: 8), Text("Help & Support", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold))]))),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(decoration: InputDecoration(hintText: "Cari bantuan...", prefixIcon: const Icon(Icons.search), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none))),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Column(children: [
                      _buildFAQItem("Bagaimana cara Login?", "Masukan Email & Pasword lalu Klik Login"),
                      const Divider(height: 30),
                      _buildFAQItem("Lupa Password", "Klik \"Forgot Pasword\" Lalu ikuti intruksi."),
                    ]),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Column(children: [
                      _buildContactItem(Icons.email_outlined, "Email:", "layanannusahealt228@gmail.com"),
                      const SizedBox(height: 15),
                      _buildContactItem(Icons.phone_android, "Whatsapp:", "+62812-XXXX-XXXX"),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String q, String a) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [const Icon(Icons.help, size: 18, color: Colors.blue), const SizedBox(width: 8), Text(q, style: const TextStyle(fontWeight: FontWeight.bold))]),
    const SizedBox(height: 10),
    Row(children: [const Icon(Icons.trending_flat, size: 18, color: Colors.blue), const SizedBox(width: 10), Expanded(child: Text(a, style: const TextStyle(fontSize: 13)))])
  ]);

  Widget _buildContactItem(IconData i, String l, String v) => Row(children: [Icon(i, color: Colors.blue), const SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l, style: const TextStyle(fontWeight: FontWeight.bold)), Text(v, style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline))])]);
}

// ---------------------------------------------------------
// 5. HALAMAN SETTINGS UTAMA
// ---------------------------------------------------------
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
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20), onPressed: () => Navigator.pop(context)),
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
                  const Divider(color: Colors.white, thickness: 1),
                  _SettingItem(icon: Icons.key_outlined, title: "Change Password", onTap: () {}),
                  const Divider(color: Colors.white, thickness: 1),
                  _SettingItem(icon: Icons.notifications_none_outlined, title: "Notification Preference", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPreferenceScreen()))),
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
                  _SettingItem(icon: Icons.lock_outline, title: "Privacy Policy", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()))),
                  const Divider(color: Colors.white, thickness: 1),
                  _SettingItem(icon: Icons.description_outlined, title: "Terms of Service", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsOfServiceScreen()))),
                  const Divider(color: Colors.white, thickness: 1),
                  // SEKARANG SUDAH NYAMBUNG KE HELP & SUPPORT
                  _SettingItem(icon: Icons.help_outline, title: "Help & Support", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen()))),
                ],
              ),
            ),
            const SizedBox(height: 50),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) => SizedBox(
    width: double.infinity,
    child: Container(
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF66B2FF), Color(0xFF007BFF)]), borderRadius: BorderRadius.circular(15)),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 15)),
        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.logout, color: Colors.white), SizedBox(width: 10), Text("Logout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
      ),
    ),
  );
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _SettingItem({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: const Color(0xFF007BFF), size: 20)),
          const SizedBox(width: 15),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black54)
        ]),
      ),
    );
  }
}