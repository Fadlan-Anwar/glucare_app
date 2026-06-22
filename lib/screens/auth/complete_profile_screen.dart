import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/user_provider.dart';
import 'auth_service.dart';
import 'auth_provider.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  final _genderController = TextEditingController();
  final _birthDateController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _genderController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  String? _formatBirthDateForDb(String dateStr) {
    if (dateStr.isEmpty) return null;
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateStr)) {
      return dateStr;
    }
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        final day = parts[0];
        final month = parts[1];
        final year = parts[2];
        if (day.length <= 2 && year.length == 4) {
          return '$year-$month-${day.padLeft(2, '0')}';
        }
      }
    } catch (e) {
      debugPrint("Error formatting date for DB: $e");
    }
    return dateStr;
  }

  Future<void> _saveProfile() async {
    if (_genderController.text.isEmpty || _birthDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih jenis kelamin dan tanggal lahir terlebih dahulu'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final authService = AuthService();
      final birthDateDb = _formatBirthDateForDb(_birthDateController.text);
      
      final currentUser = UserProvider.userNotifier.value;

      // Update backend
      await authService.updateProfile(
        fullName: currentUser.name,
        gender: _genderController.text,
        phone: currentUser.phone,
        birthDate: birthDateDb,
      );

      // Update local state
      UserProvider.updateProfile(
        name: currentUser.name,
        email: currentUser.email,
        gender: _genderController.text,
        phone: currentUser.phone,
        birthDate: _birthDateController.text,
        profileImageUrl: currentUser.profileImageUrl,
      );

      ref.invalidate(userProfileProvider);

      setState(() => _isLoading = false);
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Widget _buildInputLabel(String label) => Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(label,
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF4B5563))));

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _genderController.text.isEmpty ? null : _genderController.text,
      hint: Text("Pilih Jenis Kelamin", style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF9CA3AF))),
      style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF111827)),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
        ),
      ),
      icon: const Icon(Icons.expand_more_rounded, color: Color(0xFF9CA3AF)),
      items: ['Laki-laki', 'Perempuan'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: GoogleFonts.poppins(fontSize: 14)),
        );
      }).toList(),
      onChanged: (newValue) {
        if (newValue != null) {
          _genderController.text = newValue;
        }
      },
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return TextFormField(
      controller: _birthDateController,
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.mainBlue,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          String formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
          _birthDateController.text = formattedDate;
        }
      },
      decoration: InputDecoration(
        hintText: "Pilih Tanggal Lahir",
        hintStyle: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF9CA3AF)),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: const Icon(Icons.calendar_today_rounded, color: Color(0xFF9CA3AF), size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 80,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  "Lengkapi Profil Anda",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Satu langkah lagi! Lengkapi data di bawah ini agar kami dapat memberikan analisis gula darah yang akurat.",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                
                _buildInputLabel("Jenis Kelamin *"),
                _buildGenderDropdown(),
                
                _buildInputLabel("Tanggal Lahir *"),
                _buildDatePicker(context),
                
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainBlue,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Simpan & Lanjutkan",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
