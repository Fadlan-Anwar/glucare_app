import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller untuk menangkap semua input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Biru Sesuai Desain Figma
            Container(
              width: double.infinity,
              height: 300,
              decoration: const BoxDecoration(
                color: AppColors.mainBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.water_drop, color: Colors.white, size: 80), 
                  SizedBox(height: 10),
                  Text("GluCare", 
                    style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  const Text("Get Started", 
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.mainBlue)),
                  const SizedBox(height: 25),
                  
                  _buildTextField("Full Name", controller: _nameController),
                  _buildTextField("Email", controller: _emailController),
                  _buildTextField("Password", controller: _passwordController, isPassword: true),
                  
                  Row(
                    children: [
                      Checkbox(value: true, activeColor: AppColors.mainBlue, onChanged: (v){}),
                      const Expanded(
                        child: Text("I agree to the processing of Personal data", 
                          style: TextStyle(fontSize: 12))
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // Bungkus data untuk dikirim ke Login
                        Map<String, String> userData = {
                          'name': _nameController.text,
                          'email': _emailController.text,
                          'password': _passwordController.text,
                        };
                        
                        // ALUR BENAR: Ke Login dulu, bawa data
                        Navigator.pushReplacementNamed(
                          context, 
                          '/login', 
                          arguments: userData
                        ); 
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                      child: const Text("Sign up", 
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  const Text("Sign up with", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),
                  
                  // Tombol Sosial Media
                  Row(
                    children: [
                      Expanded(child: _socialButton("Google")),
                      const SizedBox(width: 15),
                      Expanded(child: _socialButton("Facebook")),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  // Tombol navigasi ke Login jika sudah punya akun
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        child: const Text("Log in", 
                          style: TextStyle(color: AppColors.mainBlue, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {required TextEditingController controller, bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), 
            borderSide: BorderSide.none
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        ),
      ),
    );
  }

  Widget _socialButton(String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!), 
        borderRadius: BorderRadius.circular(12)
      ),
      child: Center(
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
