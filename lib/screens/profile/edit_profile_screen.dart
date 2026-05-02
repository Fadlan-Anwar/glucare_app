import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 50);
      if (pickedFile != null) { setState(() => _image = File(pickedFile.path)); Navigator.pop(context); }
    } catch (e) { debugPrint("Error: $e"); }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (bc) {
      return Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const SizedBox(width: 24), const Text("Ganti Foto", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))]),
          const SizedBox(height: 10),
          CircleAvatar(radius: 40, backgroundImage: _image != null ? FileImage(_image!) : const AssetImage('assets/images/profile_user.png') as ImageProvider),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: ElevatedButton.icon(onPressed: () => _getImage(ImageSource.camera), icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18), label: const Text("Ambil Foto", style: TextStyle(color: Colors.white)), style: ElevatedButton.styleFrom(backgroundColor: AppColors.mainBlue))),
            const SizedBox(width: 10),
            Expanded(child: ElevatedButton.icon(onPressed: () => _getImage(ImageSource.gallery), icon: const Icon(Icons.image, color: Colors.white, size: 18), label: const Text("Pilih Dari Galeri", style: TextStyle(color: Colors.white)), style: ElevatedButton.styleFrom(backgroundColor: AppColors.mainBlue))),
          ]),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () { setState(() => _image = null); Navigator.pop(context); }, icon: const Icon(Icons.delete_outline, color: Colors.red), label: const Text("Hapus Foto", style: TextStyle(color: Colors.red)), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE9ECEF), elevation: 0))),
        ]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20), onPressed: () => Navigator.pop(context)),
        title: const Text("Profile edit", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), centerTitle: true),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Foto Profile", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 15),
        Center(child: Stack(children: [
          CircleAvatar(radius: 50, backgroundImage: _image != null ? FileImage(_image!) : const AssetImage('assets/images/profile_user.png') as ImageProvider),
          Positioned(bottom: 0, right: 0, child: GestureDetector(onTap: () => _showPicker(context), child: Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: AppColors.mainBlue, shape: BoxShape.circle), child: const Icon(Icons.camera_alt, color: Colors.white, size: 20)))),
        ])),
        const SizedBox(height: 30), const Text("List Input", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        _buildInputLabel("Name"), _buildTextField("@User.Name"),
        _buildInputLabel("Gender"), _buildTextField("Man"),
        _buildInputLabel("Email"), _buildTextField("Userid@gmail.com"),
        _buildInputLabel("Nomor Telepon"), _buildPhoneField(),
        _buildInputLabel("Tanggal Lahir"), _buildTextField("01-02-2003"),
        const SizedBox(height: 40),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.mainBlue, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          child: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
      ])),
    );
  }

  Widget _buildInputLabel(String label) => Padding(padding: const EdgeInsets.only(bottom: 8, top: 15), child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)));

  Widget _buildTextField(String hint) => TextField(decoration: InputDecoration(hintText: hint, filled: true, fillColor: AppColors.bgGray, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)));

  Widget _buildPhoneField() => TextField(decoration: InputDecoration(
    prefixIcon: Padding(padding: const EdgeInsets.all(12), child: Row(mainAxisSize: MainAxisSize.min, children: [Image.network('https://flagcdn.com/w20/id.png', width: 20), const SizedBox(width: 8), const Text("+62", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))])),
    hintText: "812-3456-7890", filled: true, fillColor: AppColors.bgGray, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)));
}
