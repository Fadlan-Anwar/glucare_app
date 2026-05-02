import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../core/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

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

  void _saveProfile() {
    UserProvider.updateProfile(
      name: _nameController.text,
      gender: _genderController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      birthDate: _birthDateController.text,
      profileImage: _image,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.black, size: 20),
              onPressed: () => Navigator.pop(context)),
          title: const Text("Profile edit",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          centerTitle: true),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Foto Profile",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Center(
                child: Stack(children: [
              CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : const AssetImage('assets/images/profile_user.png')
                          as ImageProvider),
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
            ])),
            const SizedBox(height: 30),
            const Text("List Input",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            
            _buildInputLabel("Name"),
            _buildTextField(_nameController),
            
            _buildInputLabel("Gender"),
            _buildGenderDropdown(),
            
            _buildInputLabel("Email"),
            _buildTextField(_emailController, keyboardType: TextInputType.emailAddress),
            
            _buildInputLabel("Nomor Telepon"),
            _buildPhoneField(_phoneController),
            
            _buildInputLabel("Tanggal Lahir"),
            _buildDatePicker(context),
            
            const SizedBox(height: 40),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainBlue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text("Simpan Perubahan",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)))),
          ])),
    );
  }

  Widget _buildInputLabel(String label) => Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 15),
      child: Text(label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)));

  Widget _buildTextField(TextEditingController controller, {TextInputType? keyboardType}) => TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.bgGray,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none)));

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _genderController.text,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.bgGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      items: ['Laki-laki', 'Perempuan'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
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
        fillColor: AppColors.bgGray,
        suffixIcon: const Icon(Icons.calendar_today, color: AppColors.mainBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPhoneField(TextEditingController controller) => TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
          prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Image.network('https://flagcdn.com/w20/id.png', width: 20),
                const SizedBox(width: 8),
                const Text("+62",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold))
              ])),
          filled: true,
          fillColor: AppColors.bgGray,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none)));
}
