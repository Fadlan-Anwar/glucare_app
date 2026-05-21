import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../auth/auth_service.dart';
import 'settings/change_email_screen.dart';
import '../../core/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  late TextEditingController _nameController;
  late TextEditingController _genderController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _birthDateController;

  @override
  void initState() {
    super.initState();
    final userData = UserProvider.userNotifier.value;
    _image = userData.profileImage;
    _nameController = TextEditingController(text: userData.name);
    _genderController = TextEditingController(text: userData.gender);
    _emailController = TextEditingController(text: userData.email);
    _phoneController = TextEditingController(text: userData.phone);
    _birthDateController = TextEditingController(text: userData.birthDate);
    
    // Ensure gender has a valid initial value if it's empty
    if (_genderController.text != 'Laki-laki' && _genderController.text != 'Perempuan') {
      _genderController.text = 'Laki-laki';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 50);
      if (pickedFile != null) {
        setState(() => _image = File(pickedFile.path));
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (bc) {
          return Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              padding: const EdgeInsets.all(20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 24),
                      const Text("Ganti Foto",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context))
                    ]),
                const SizedBox(height: 10),
                CircleAvatar(
                    radius: 40,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : const AssetImage('assets/images/profile_user.png')
                            as ImageProvider),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(
                      child: ElevatedButton.icon(
                          onPressed: () => _getImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 18),
                          label: const Text("Ambil Foto",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainBlue))),
                  const SizedBox(width: 10),
                  Expanded(
                      child: ElevatedButton.icon(
                          onPressed: () => _getImage(ImageSource.gallery),
                          icon: const Icon(Icons.image,
                              color: Colors.white, size: 18),
                          label: const Text("Pilih Dari Galeri",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainBlue))),
                ]),
                const SizedBox(height: 10),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() => _image = null);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.red),
                        label: const Text("Hapus Foto",
                            style: TextStyle(color: Colors.red)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE9ECEF),
                            elevation: 0))),
              ]));
        });
  }

  Future<void> _saveProfile() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    final fullName = _nameController.text.trim();
    final gender = _genderController.text;
    final phone = _phoneController.text.trim();
    final birthDate = _birthDateController.text;
    
    debugPrint("Attempting to save profile: name=$fullName, gender=$gender, phone=$phone, birthDate=$birthDate");

    try {
      final authService = AuthService();
      final user = authService.currentUser;
      final currentEmail = UserProvider.userNotifier.value.email;
      final newEmail = _emailController.text.trim();

      // Persist profile image locally if changed
      if (user != null) {
        if (_image != null && _image != UserProvider.userNotifier.value.profileImage) {
          await UserProvider.persistLocalProfileImage(user.uid, _image!);
        } else if (_image == null) {
          await UserProvider.clearLocalProfileImage(user.uid);
        }
      }

      // 1. Update Profile (Name, Gender, etc.)
      await authService.updateProfile(
        fullName: fullName,
        gender: gender,
        phone: phone,
        birthDate: birthDate,
      );

      // 2. Update local state
      UserProvider.updateProfile(
        name: _nameController.text.trim(),
        gender: _genderController.text,
        phone: _phoneController.text.trim(),
        email: newEmail,
        birthDate: _birthDateController.text,
      );

      // 3. Handle Email change if needed (requires password usually)
      if (newEmail != currentEmail) {
        // We update Firestore but Firebase Auth email needs verification/re-auth
        // For now, we'll just show a note if email was changed
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil diperbarui. Untuk mengubah email secara permanen, silakan verifikasi email baru Anda.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil berhasil diperbarui'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      debugPrint("Error in _saveProfile: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = UserProvider.userNotifier.value;
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
          "Edit Profil",
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
            Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  CircleAvatar(
                      radius: 50,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : (userData.profileImageUrl != null
                              ? NetworkImage(userData.profileImageUrl!)
                              : const AssetImage('assets/images/profile_user.png')
                                  as ImageProvider)),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                          onTap: () => _showPicker(context),
                          child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                  color: AppColors.mainBlue,
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white, size: 20)))),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "INFORMASI PRIBADI",
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: const Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 8),
            
            _buildInputLabel("Nama Lengkap"),
            _buildTextField(_nameController),
            
            _buildInputLabel("Jenis Kelamin"),
            _buildGenderDropdown(),
            
            _buildInputLabel("Email"),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeEmailScreen())),
              child: AbsorbPointer(
                child: _buildTextField(
                  _emailController, 
                  keyboardType: TextInputType.emailAddress,
                  suffixIcon: const Icon(Icons.open_in_new_rounded, size: 18, color: AppColors.mainBlue),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(
                "* Email hanya dapat diubah melalui verifikasi keamanan",
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.orange[800], fontWeight: FontWeight.w500),
              ),
            ),
            
            _buildInputLabel("Nomor Handphone"),
            _buildPhoneField(_phoneController),
            
            _buildInputLabel("Tanggal Lahir"),
            _buildDatePicker(context),
            
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF111827),
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
                        "Simpan Perubahan",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) => Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(label,
          style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF4B5563))));

  Widget _buildTextField(TextEditingController controller, {TextInputType? keyboardType, Widget? suffixIcon}) => TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF111827)),
      decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5))));

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _genderController.text,
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
      readOnly: true, // Prevents keyboard from appearing
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
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

  Widget _buildPhoneField(TextEditingController controller) => TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF111827)),
      decoration: InputDecoration(
          prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Image.network('https://flagcdn.com/w20/id.png', width: 20),
                const SizedBox(width: 8),
                Text("+62",
                    style: GoogleFonts.poppins(
                        color: const Color(0xFF4B5563), fontWeight: FontWeight.w500))
              ])),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5))));
}
