import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import 'auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int _currentStep = 0; // 0: Email, 1: OTP, 2: New Password, 3: Success
  String _email = '';
  String _resetToken = '';

  void _goToStep(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF007AE1),
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Top Logo Section
                      SizedBox(
                        height: constraints.maxHeight * 0.30,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Bottom White Container
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: _buildCurrentStep(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _StepEmail(
          onSuccess: (email) {
            _email = email;
            _goToStep(1);
          },
          onBackToLogin: () => Navigator.pop(context),
        );
      case 1:
        return _StepOtp(
          email: _email,
          onSuccess: (token) {
            _resetToken = token;
            _goToStep(2);
          },
          onBack: () => _goToStep(0),
        );
      case 2:
        return _StepNewPassword(
          resetToken: _resetToken,
          onSuccess: () => _goToStep(3),
        );
      case 3:
      default:
        return _StepSuccess(
          onBackToLogin: () => Navigator.pushReplacementNamed(context, '/login'),
        );
    }
  }
}

// ---------------------------------------------------------
// REUSABLE DECORATIONS MATCHING LOGIN SCREEN
// ---------------------------------------------------------
InputDecoration _buildInputDecoration(String label, String hint) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    hintStyle: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 14),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    labelStyle: GoogleFonts.poppins(color: Colors.grey[800], fontSize: 16, fontWeight: FontWeight.w500),
    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    filled: true,
    fillColor: Colors.grey[50],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Colors.grey[200]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Colors.grey[200]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Color(0xFF007AE1), width: 1.5),
    ),
  );
}

ButtonStyle _buildButtonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF007AE1),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 18),
    elevation: 2,
    shadowColor: const Color(0xFF007AE1).withValues(alpha: 0.3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );
}


// ---------------------------------------------------------
// STEP 1: EMAIL
// ---------------------------------------------------------
class _StepEmail extends StatefulWidget {
  final Function(String email) onSuccess;
  final VoidCallback onBackToLogin;

  const _StepEmail({required this.onSuccess, required this.onBackToLogin});

  @override
  State<_StepEmail> createState() => _StepEmailState();
}

class _StepEmailState extends State<_StepEmail> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String _error = '';

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Email tidak boleh kosong');
      return;
    }
    setState(() {
      _error = '';
      _isLoading = true;
    });

    try {
      await AuthService().forgotPassword(email);
      widget.onSuccess(email);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.lock_outline, size: 48, color: Color(0xFF007AE1)),
        const SizedBox(height: 16),
        Text('Lupa Kata Sandi?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 26, fontWeight: FontWeight.w800, color: const Color(0xFF007AE1))),
        const SizedBox(height: 8),
        Text('Masukkan email Anda, kami akan kirimkan kode OTP',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500])),
        const SizedBox(height: 32),
        
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: _buildInputDecoration('Email', 'contoh@email.com'),
        ),
        
        if (_error.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.red[50],
                border: Border.all(color: Colors.red[200]!),
                borderRadius: BorderRadius.circular(12)),
            child: Text(_error, style: GoogleFonts.poppins(color: Colors.red[600], fontSize: 12)),
          )
        ],
        
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: _buildButtonStyle(),
          child: _isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text('Kirim Kode OTP', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        
        const SizedBox(height: 16),
        TextButton(
          onPressed: widget.onBackToLogin,
          child: Text('← Kembali ke Login', style: GoogleFonts.poppins(color: Colors.grey[500], fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------
// STEP 2: OTP
// ---------------------------------------------------------
class _StepOtp extends StatefulWidget {
  final String email;
  final Function(String token) onSuccess;
  final VoidCallback onBack;

  const _StepOtp({required this.email, required this.onSuccess, required this.onBack});

  @override
  State<_StepOtp> createState() => _StepOtpState();
}

class _StepOtpState extends State<_StepOtp> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;
  String _error = '';
  int _countdown = 300;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _countdown = 300);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  Future<void> _submit() async {
    final otp = _otpController.text.trim();
    if (otp.length < 6) return;

    setState(() {
      _error = '';
      _isLoading = true;
    });

    try {
      final token = await AuthService().verifyOtp(widget.email, otp);
      widget.onSuccess(token);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resend() async {
    if (_countdown > 0 || _isResending) return;
    setState(() {
      _error = '';
      _isResending = true;
    });

    try {
      await AuthService().forgotPassword(widget.email);
      _otpController.clear();
      _startTimer();
    } catch (e) {
      setState(() => _error = 'Gagal mengirim ulang OTP');
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('📩', textAlign: TextAlign.center, style: TextStyle(fontSize: 48)),
        const SizedBox(height: 16),
        Text('Cek Email Anda',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 26, fontWeight: FontWeight.w800, color: const Color(0xFF007AE1))),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            text: 'Kode OTP dikirim ke ',
            children: [
              TextSpan(
                  text: widget.email,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
        ),
        const SizedBox(height: 32),
        
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 24, letterSpacing: 10, fontWeight: FontWeight.bold),
          onChanged: (v) {
            if (v.length == 6) _submit();
          },
          decoration: _buildInputDecoration('Kode OTP (6 digit)', '------').copyWith(
             hintStyle: const TextStyle(letterSpacing: 10, color: Colors.grey),
             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        
        const SizedBox(height: 16),
        if (_countdown > 0)
          Text.rich(
            TextSpan(
              text: 'Kode kedaluwarsa dalam ',
              style: GoogleFonts.poppins(color: Colors.grey[500]),
              children: [
                TextSpan(
                    text: _formatTime(_countdown),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _countdown <= 60 ? Colors.red : const Color(0xFF007AE1))),
              ],
            ),
            textAlign: TextAlign.center,
          )
        else
          Text('Kode sudah kedaluwarsa', textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.red)),
          
        if (_error.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.red[50],
                border: Border.all(color: Colors.red[200]!),
                borderRadius: BorderRadius.circular(12)),
            child: Text(_error, style: GoogleFonts.poppins(color: Colors.red[600], fontSize: 12)),
          )
        ],
        
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isLoading || _countdown <= 0 || _otpController.text.length < 6 ? null : _submit,
          style: _buildButtonStyle(),
          child: _isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text('Verifikasi OTP', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tidak menerima kode? ', style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 13)),
            GestureDetector(
              onTap: _resend,
              child: Text(
                _isResending ? 'Mengirim...' : 'Kirim Ulang',
                style: GoogleFonts.poppins(
                  color: (_countdown > 0 || _isResending) ? Colors.grey[400] : const Color(0xFF007AE1),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: widget.onBack,
          child: Text('← Ganti Email', style: GoogleFonts.poppins(color: Colors.grey[500], fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------
// STEP 3: NEW PASSWORD
// ---------------------------------------------------------
class _StepNewPassword extends StatefulWidget {
  final String resetToken;
  final VoidCallback onSuccess;

  const _StepNewPassword({required this.resetToken, required this.onSuccess});

  @override
  State<_StepNewPassword> createState() => _StepNewPasswordState();
}

class _StepNewPasswordState extends State<_StepNewPassword> {
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  String _error = '';
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  Future<void> _submit() async {
    final pass = _passController.text;
    final confirm = _confirmController.text;

    if (pass != confirm) {
      setState(() => _error = 'Konfirmasi kata sandi tidak cocok');
      return;
    }
    if (pass.length < 8) {
      setState(() => _error = 'Kata sandi minimal 8 karakter');
      return;
    }

    setState(() {
      _error = '';
      _isLoading = true;
    });

    try {
      await AuthService().resetPassword(widget.resetToken, pass, confirm);
      widget.onSuccess();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.key, size: 48, color: Color(0xFF007AE1)),
        const SizedBox(height: 16),
        Text('Buat Sandi Baru',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 26, fontWeight: FontWeight.w800, color: const Color(0xFF007AE1))),
        const SizedBox(height: 8),
        Text('Sandi baru minimal 8 karakter',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500])),
        const SizedBox(height: 32),
        
        TextField(
          controller: _passController,
          obscureText: _obscurePass,
          decoration: _buildInputDecoration('Kata Sandi Baru', '••••••••').copyWith(
            suffixIcon: IconButton(
              icon: Icon(_obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey[500]),
              onPressed: () => setState(() => _obscurePass = !_obscurePass),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        TextField(
          controller: _confirmController,
          obscureText: _obscureConfirm,
          decoration: _buildInputDecoration('Konfirmasi Sandi', '••••••••').copyWith(
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey[500]),
              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
        ),
        
        if (_error.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.red[50],
                border: Border.all(color: Colors.red[200]!),
                borderRadius: BorderRadius.circular(12)),
            child: Text(_error, style: GoogleFonts.poppins(color: Colors.red[600], fontSize: 12)),
          )
        ],
        
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: _buildButtonStyle(),
          child: _isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text('Simpan Sandi Baru', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------
// STEP 4: SUCCESS
// ---------------------------------------------------------
class _StepSuccess extends StatelessWidget {
  final VoidCallback onBackToLogin;

  const _StepSuccess({required this.onBackToLogin});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle, size: 80, color: Colors.green),
        const SizedBox(height: 24),
        Text('Berhasil!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: 26, fontWeight: FontWeight.w800, color: const Color(0xFF007AE1))),
        const SizedBox(height: 12),
        Text('Kata sandi Anda berhasil diubah. Silakan login kembali menggunakan kata sandi yang baru.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 15, height: 1.5, color: Colors.grey[500])),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: onBackToLogin,
          style: _buildButtonStyle(),
          child: Text('Kembali ke Login', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ],
    );
  }
}
