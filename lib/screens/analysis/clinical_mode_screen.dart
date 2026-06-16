import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/auth_service.dart';

class ClinicalModeScreen extends StatefulWidget {
  const ClinicalModeScreen({super.key});

  @override
  State<ClinicalModeScreen> createState() => _ClinicalModeScreenState();
}

class _ClinicalModeScreenState extends State<ClinicalModeScreen> {
  final TextEditingController _usiaController = TextEditingController();
  final TextEditingController _gulaDarahController = TextEditingController();
  final TextEditingController _beratBadanController = TextEditingController();
  final TextEditingController _tinggiBadanController = TextEditingController();
  final TextEditingController _lingkarPinggangController = TextEditingController();
  final TextEditingController _hdlController = TextEditingController();
  final TextEditingController _trigliseridaController = TextEditingController();
  final TextEditingController _sistolikController = TextEditingController();
  final TextEditingController _diastolikController = TextEditingController();
  
  int _calculatedAge = 0;
  double _progress = 0.0;
  int _filledFields = 0;

  @override
  void initState() {
    super.initState();
    _calculateAge();
    
    final controllers = [
      _gulaDarahController, _beratBadanController, _tinggiBadanController,
      _lingkarPinggangController, _hdlController, _trigliseridaController,
      _sistolikController, _diastolikController
    ];
    for (var c in controllers) {
      c.addListener(_updateProgress);
    }
  }

  void _updateProgress() {
    int filled = 0;
    if (_gulaDarahController.text.isNotEmpty) filled++;
    if (_beratBadanController.text.isNotEmpty) filled++;
    if (_tinggiBadanController.text.isNotEmpty) filled++;
    if (_lingkarPinggangController.text.isNotEmpty) filled++;
    if (_hdlController.text.isNotEmpty) filled++;
    if (_trigliseridaController.text.isNotEmpty) filled++;
    if (_sistolikController.text.isNotEmpty) filled++;
    if (_diastolikController.text.isNotEmpty) filled++;
    
    setState(() {
      _filledFields = filled;
      _progress = filled / 8;
    });
  }

  void _calculateAge() {
    final user = AuthService().currentUser;
    if (user != null && user.birthDate != null && user.birthDate!.isNotEmpty) {
      try {
        final birthDate = DateTime.parse(user.birthDate!);
        final today = DateTime.now();
        int age = today.year - birthDate.year;
        if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
          age--;
        }
        setState(() {
          _calculatedAge = age;
          _usiaController.text = age.toString();
        });
      } catch (e) {
        debugPrint("Error parsing birthDate: $e");
      }
    }
  }

  @override
  void dispose() {
    _usiaController.dispose();
    _gulaDarahController.dispose();
    _beratBadanController.dispose();
    _tinggiBadanController.dispose();
    _lingkarPinggangController.dispose();
    _hdlController.dispose();
    _trigliseridaController.dispose();
    _sistolikController.dispose();
    _diastolikController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          _buildProgressBar(),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lengkapi data di bawah ini untuk memulai analisis AI.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),

            _buildSectionHeader('Gula Darah'),
            _buildMobileInputField('Gula Darah Puasa', _gulaDarahController, 'mg/dL', placeholder: 'Contoh: 95'),
            const SizedBox(height: 24),

            _buildSectionHeader('Data Tubuh'),
            Row(
              children: [
                Expanded(child: _buildMobileInputField('Berat Badan', _beratBadanController, 'kg', placeholder: '65')),
                const SizedBox(width: 16),
                Expanded(child: _buildMobileInputField('Tinggi Badan', _tinggiBadanController, 'cm', placeholder: '165')),
              ],
            ),
            const SizedBox(height: 16),
            _buildMobileInputField('Lingkar Pinggang', _lingkarPinggangController, 'cm', placeholder: 'Contoh: 85'),
            const SizedBox(height: 24),

            _buildSectionHeader('Profil Lipid'),
            Row(
              children: [
                Expanded(child: _buildMobileInputField('Kolesterol HDL', _hdlController, 'mg/dL', placeholder: '55')),
                const SizedBox(width: 16),
                Expanded(child: _buildMobileInputField('Trigliserida', _trigliseridaController, 'mg/dL', placeholder: '130')),
              ],
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Tekanan Darah'),
            Row(
              children: [
                Expanded(child: _buildMobileInputField('Sistolik (Atas)', _sistolikController, 'mmHg', placeholder: '120')),
                const SizedBox(width: 16),
                Expanded(child: _buildMobileInputField('Diastolik (Bawah)', _diastolikController, 'mmHg', placeholder: '80')),
              ],
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _progress == 1.0 ? () {
                  Navigator.pushNamed(
                    context, 
                    '/analysis-result',
                    arguments: {
                      'isLab': true,
                      'usia': _calculatedAge > 0 ? _calculatedAge : (int.tryParse(_usiaController.text) ?? 0),
                      'gula_darah_puasa': double.tryParse(_gulaDarahController.text) ?? 0,
                      'berat_badan': double.tryParse(_beratBadanController.text) ?? 0,
                      'tinggi_badan': double.tryParse(_tinggiBadanController.text) ?? 0,
                      'lingkar_pinggang': double.tryParse(_lingkarPinggangController.text) ?? 0,
                      'hdl': double.tryParse(_hdlController.text) ?? 0,
                      'trigliserida': double.tryParse(_trigliseridaController.text) ?? 0,
                      'tekanan_sistolik': double.tryParse(_sistolikController.text) ?? 0,
                      'tekanan_diastolik': double.tryParse(_diastolikController.text) ?? 0,
                    },
                  );
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  disabledBackgroundColor: Colors.grey[300],
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.grey[500],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _progress == 1.0 ? 'Analisis Sekarang' : 'Lengkapi Data ($_filledFields/8)',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
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
                          'Data Klinis',
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
                    'Masukkan data untuk analisis AI',
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

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kelengkapan Data',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[800]),
              ),
              Text(
                '$_filledFields/8 Terisi',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: _progress == 1.0 ? Colors.green : const Color(0xFF3B82F6)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: _progress),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutQuart,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(_progress == 1.0 ? Colors.green : const Color(0xFF3B82F6)),
                  minHeight: 8,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildMobileInputField(String title, TextEditingController controller, String suffix, {String? placeholder}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF1E293B),
                  ),
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    isDense: true,
                  ),
                ),
              ),
              if (suffix.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    suffix,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
