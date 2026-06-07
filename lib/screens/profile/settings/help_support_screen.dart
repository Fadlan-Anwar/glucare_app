import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final List<_FAQItem> _allFAQs = [
    _FAQItem(
      question: "Bagaimana cara melakukan analisis risiko?",
      answer: "Pilih menu 'Analisis AI' pada halaman utama, lalu pilih 'Data Klinis' untuk hasil lab atau 'Mode Kuesioner' untuk menganalisis risiko diabetes berdasarkan gaya hidup Anda.",
    ),
    _FAQItem(
      question: "Bagaimana cara Login?",
      answer: "Masukkan Email dan Password yang telah terdaftar pada halaman login, lalu klik tombol 'Masuk'. Anda juga dapat masuk menggunakan Google.",
    ),
    _FAQItem(
      question: "Lupa Password",
      answer: "Klik tombol 'Lupa Password' pada halaman login, masukkan email terdaftar Anda, dan ikuti instruksi pemulihan yang dikirim ke email tersebut.",
    ),
    _FAQItem(
      question: "Bagaimana cara mengubah foto profil?",
      answer: "Buka menu 'Profil' di navigasi bawah, klik 'Edit Profil', lalu ketuk foto profil Anda untuk mengambil foto baru atau memilih gambar dari galeri Anda.",
    ),
    _FAQItem(
      question: "Apakah data kesehatan saya aman?",
      answer: "Ya, seluruh data klinis, kuesioner, dan informasi pribadi Anda disimpan dengan enkripsi aman di database kami dan tidak akan dibagikan kepada pihak ketiga.",
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredFAQs = _allFAQs
        .where((faq) =>
            faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            faq.answer.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF111827), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Pusat Bantuan",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF111827),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search field
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF111827)),
                decoration: InputDecoration(
                  hintText: "Cari bantuan...",
                  hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, color: Color(0xFF9CA3AF), size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = "";
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
            ),
            const SizedBox(height: 28),
            
            Text(
              "PERTANYAAN POPULER",
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: const Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 12),

            if (filteredFAQs.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
                ),
                child: Text(
                  "Bantuan tidak ditemukan",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: const Color(0xFF6B7280),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
                ),
                child: Column(
                  children: List.generate(filteredFAQs.length, (index) {
                    return _buildFAQTile(
                      filteredFAQs[index],
                      showBorder: index < filteredFAQs.length - 1,
                    );
                  }),
                ),
              ),

            const SizedBox(height: 28),
            
            Text(
              "HUBUNGI KONTAK KAMI",
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: const Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
              ),
              child: Column(
                children: [
                  _buildContactTile(
                    Icons.email_outlined,
                    "Kirim Email",
                    "Glucare@gmail.com",
                    showBorder: true,
                  ),
                  _buildContactTile(
                    Icons.chat_bubble_outline_rounded,
                    "Hubungi WhatsApp",
                    "+62 812-3456-7890",
                    showBorder: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQTile(_FAQItem faq, {required bool showBorder}) {
    return Container(
      decoration: BoxDecoration(
        border: showBorder ? const Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1.5)) : null,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: const Color(0xFF4B5563),
          collapsedIconColor: Colors.grey[400],
          title: Text(
            faq.question,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF374151),
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          expandedAlignment: Alignment.topLeft,
          children: [
            Text(
              faq.answer,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: const Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile(IconData icon, String label, String value, {required bool showBorder}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: showBorder ? const Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 1.5)) : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4B5563), size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Colors.grey[400], size: 20),
        ],
      ),
    );
  }
}

class _FAQItem {
  final String question;
  final String answer;

  _FAQItem({required this.question, required this.answer});
}
