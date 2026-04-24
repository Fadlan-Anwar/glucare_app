import 'package:flutter/material.dart';
import 'analysis_result_screen.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String? _selectedOption;

  final List<Map<String, dynamic>> _questions = [
    {"question": "Usia Anda saat ini?", "options": ["20-29 Tahun", "30-39 Tahun", "40+ Tahun"]},
    {"question": "Ada anggota Keluarga dengan diabetes?", "options": ["Ya", "Tidak", "Tidak Tahu"]},
    {"question": "Seberapa sering Anda berolahraga per minggu?", "options": ["Tidak Pernah", "1-2 kali", "3+ kali"]},
    {"question": "Seberapa sering konsumsi minuman manis?", "options": ["Setiap hari", "Berapa kali seminggu", "Jarang"]},
    {"question": "Bagaimana ukuran lingkar pinggang Anda?", "options": ["Normal", "Agak Besar", "Besar"]},
    {"question": "Apakah Anda sering haus berlebih?", "options": ["Sering", "Kadang-kadang", "Tidak pernah"]},
    {"question": "Berapa jam Anda tidur per malam?", "options": ["< 6 jam", "5 - 6 jam", "7 - 8 jam"]},
    {"question": "Bagaimana tingkat stres harian Anda?", "options": ["Tinggi", "Sedang", "Rendah"]},
  ];

  void _handleNext() {
    if (_selectedOption == null) return;
    if (_currentPage < 7) {
      setState(() {
        _currentPage++;
        _selectedOption = null;
      });
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AnalysisResultScreen(hba1c: 0.0, gulaDarah: 0, berat: 0.0, tinggi: 1.0)));
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color mainBlue = Color(0xFF007BFF);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // --- MENU BAWAH (BOTTOM NAVIGATION BAR) ---
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: mainBlue,
        unselectedItemColor: Colors.grey,
        currentIndex: 1, // Indeks 1 adalah menu 'Analisis'
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analisis'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), label: 'Rekomendasi'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progres'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
      body: Stack(
        children: [
          // Header Biru
          Container(
            height: 250,
            decoration: const BoxDecoration(
              color: mainBlue,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20), onPressed: () => Navigator.pop(context)),
                      const Expanded(child: Center(child: Text("Analisis Risiko", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)))),
                      const SizedBox(width: 40),
                    ],
                  ),
                  const Text("Masukkan data untuk analisis Ai", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (_currentPage + 1) / 8,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                        minHeight: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Kartu Pertanyaan
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 130),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Pertanyaan ${_currentPage + 1} / 8", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                      Row(
                        children: List.generate(8, (i) => Container(
                          margin: const EdgeInsets.only(left: 4),
                          width: 7, height: 7,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: _currentPage == i ? Colors.white : Colors.white38),
                        )),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_questions[_currentPage]['question'], style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        ...(_questions[_currentPage]['options'] as List<String>).map((opt) {
                          bool isSelected = _selectedOption == opt;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedOption = opt),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isSelected ? mainBlue : Colors.grey.shade200, width: 1.5),
                                color: isSelected ? mainBlue.withOpacity(0.05) : Colors.transparent,
                              ),
                              child: Row(
                                children: [
                                  Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? mainBlue : Colors.grey, size: 20),
                                  const SizedBox(width: 12),
                                  Text(opt, style: const TextStyle(fontSize: 15)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        const Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: _selectedOption == null ? null : _handleNext,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _currentPage == 7 ? mainBlue : Colors.white,
                              foregroundColor: _currentPage == 7 ? Colors.white : Colors.black,
                              elevation: 0,
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Text(_currentPage == 7 ? "Lihat Hasil" : "Selanjutnya"),
                              const Icon(Icons.arrow_forward, size: 16),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}