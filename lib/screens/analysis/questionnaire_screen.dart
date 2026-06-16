import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_Question> _questions = [
    _Question(
      question: "Usia Anda saat ini?",
      options: ["20-29 Tahun", "30-39 Tahun", "40+ Tahun"],
    ),
    _Question(
      question: "Ada anggota keluarga dengan diabetes?",
      options: ["Ada", "Tidak ada", "Tidak Tahu"],
    ),
    _Question(
      question: "Seberapa sering Anda berolahraga per minggu?",
      options: ["Tidak pernah", "1-2 kali", "3+ kali"],
    ),
    _Question(
      question: "Seberapa sering konsumsi minuman manis atau makanan olahan?",
      options: ["Setiap hari", "Beberapa kali dalam seminggu", "Sangat jarang"],
    ),
    _Question(
      question: "Bagaimana ukuran lingkar pinggang Anda?",
      options: ["Normal", "Agak Besar", "Besar (Gemuk perut)"],
    ),
    _Question(
      question: "Apakah Anda sering haus berlebih, sering buang air kecil, dan mudah lelah?",
      options: ["Iya", "Tidak terlalu", "Tidak sama sekali"],
    ),
    _Question(
      question: "Berapa jam Anda tidur per-malam?",
      options: ["<5 jam", "5-6 jam", "7-8 jam"],
    ),
    _Question(
      question: "Bagaimana tingkat stress harian Anda?",
      options: ["Tinggi", "Sedang", "Rendah"],
    ),
  ];

  late List<int> _selectedAnswers;

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List.filled(_questions.length, -1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectAnswer(int questionIndex, int answerIndex) {
    setState(() {
      _selectedAnswers[questionIndex] = answerIndex;
    });
    
    // Automatically proceed to next page
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        _nextPage();
      }
    });
  }

  void _nextPage() {
    if (_currentPage < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushNamed(
        context, 
        '/analysis-result',
        arguments: {
          'isKuesioner': true,
          'answers': List.generate(
            _questions.length, 
            (i) => _questions[i].options[_selectedAnswers[i]]
          ),
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Column(
              children: [
                _buildProgressIndicator(),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(), // Disable swipe to force using buttons
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      return _buildQuestionCard(index);
                    },
                  ),
                ),
                _buildBottomAction(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (Navigator.canPop(context))
                        GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: Container(
                            margin: const EdgeInsets.only(right: 16),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          'Mode Kuesioner',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Masukkan data untuk analisis Ai',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Pertanyaan ${_currentPage + 1} / ${_questions.length}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Row(
            children: List.generate(_questions.length, (index) {
              return Container(
                margin: const EdgeInsets.only(left: 6),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == _currentPage 
                      ? const Color(0xFF1E88E5) 
                      : Colors.grey[300],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(int index) {
    final q = _questions[index];
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              q.question,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(q.options.length, (optIndex) {
              final isSelected = _selectedAnswers[index] == optIndex;
              return GestureDetector(
                onTap: () => _selectAnswer(index, optIndex),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFF1F5F9),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? const Color(0xFF3B82F6) : Colors.grey[400]!,
                            width: isSelected ? 5 : 1.5,
                          ),
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          q.options[optIndex],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF334155),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction() {
    if (_currentPage == 0) return const SizedBox(height: 80); // To keep spacing consistent

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          OutlinedButton(
            onPressed: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              side: BorderSide(color: Colors.grey[300]!),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back, color: Colors.grey[600], size: 16),
                const SizedBox(width: 8),
                Text(
                  'Kembali',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Question {
  final String question;
  final List<String> options;

  _Question({
    required this.question,
    required this.options,
  });
}
