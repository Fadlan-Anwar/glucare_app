import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../phase1_detail_screen.dart';
import '../phase2_detail_screen.dart';
import '../phase3_detail_screen.dart';
import '../plan_service.dart';
import '../../auth/auth_service.dart';
import '../../home/dashboard_screen.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/providers/notification_provider.dart';
import '../../../core/providers/network_provider.dart';

class Hari90Tab extends ConsumerStatefulWidget {
  const Hari90Tab({super.key});
  @override
  ConsumerState<Hari90Tab> createState() => _Hari90TabState();
}

class _Hari90TabState extends ConsumerState<Hari90Tab> {
  final PlanService _planService = PlanService();
  bool _isLoading = true;
  bool _isEnrolled = false;
  Map<String, dynamic>? _planData;

  // Form State
  final _sleepController = TextEditingController();
  final _walkController = TextEditingController();
  final _nutritionController = TextEditingController();
  bool _isSubmitting = false;


  
  // Glucose Tracking State
  final _glucoseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPlanData();
  }

  @override
  void dispose() {
    _sleepController.dispose();
    _walkController.dispose();
    _nutritionController.dispose();
    _glucoseController.dispose();
    super.dispose();
  }

  Future<void> _fetchPlanData({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final user = AuthService().currentUser;
      if (user == null) return;

      final data = await _planService.getPlanData(user.uid);
      if (data['enrolled'] == true) {
        _isEnrolled = true;
        _planData = data;

      } else {
        _isEnrolled = false;
      }
    } catch (e) {
      debugPrint("Error fetching plan: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleEnroll() async {
    if (_sleepController.text.isEmpty || _walkController.text.isEmpty || _nutritionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harap isi semua target')));
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final user = AuthService().currentUser;
      await _planService.enrollPlan(
        userId: user!.uid,
        sleepTargetHours: double.tryParse(_sleepController.text.replaceAll(',', '.')) ?? 7.0,
        walkingTargetMinutes: int.tryParse(_walkController.text) ?? 30,
        nutritionGoal: _nutritionController.text,
      );
      ref.read(planRefreshProvider.notifier).increment();
      await _fetchPlanData();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }



  Future<void> _handleGlucoseSubmit() async {
    if (_glucoseController.text.isEmpty) return;
    setState(() => _isSubmitting = true);
    try {
      final user = AuthService().currentUser;
      final result = await _planService.submitGlucoseTracking(
        userId: user!.uid,
        day: _planData!['day'],
        glucoseValue: double.parse(_glucoseController.text),
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gula Darah Tersimpan! +${result['xp_gained']} XP'),
            backgroundColor: Colors.green,
          )
        );
      }
      _glucoseController.clear();
      ref.read(planRefreshProvider.notifier).increment();
      await _fetchPlanData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(networkProvider, (previous, next) {
      if (previous == NetworkStatus.offline && next == NetworkStatus.online) {
        if (!mounted) return;
        setState(() => _isLoading = true);
        _fetchPlanData();
      }
    });
    
    ref.listen(planRefreshProvider, (_, __) {
      if (mounted) {
        _fetchPlanData(silent: true);
      }
    });

    final isDailyReminderOn = ref.watch(dailyReminderProvider);
    final isOffline = ref.watch(networkProvider) == NetworkStatus.offline;

    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Center(child: CircularProgressIndicator(color: Color(0xFF1E88E5))),
      );
    }

    final effectiveIsEnrolled = _isEnrolled && !isOffline;

    if (!effectiveIsEnrolled) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildEnrollmentForm(),
        ),
      );
    }

    return Column(children: [
      _buildIntervensi90Hari(), const SizedBox(height: 24),
      _buildLevelXP(), const SizedBox(height: 24),
      const DailyTrackingDashboardWidget(), const SizedBox(height: 24),
      _buildGlucoseTracker(), const SizedBox(height: 24),
      _buildFaseIntervensi(), const SizedBox(height: 24),
      _buildPengingat(isDailyReminderOn), const SizedBox(height: 40),
    ]);
  }

  Widget _buildEnrollmentForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))]
      ),
      child: Column(
        children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: const Color(0xFF1E88E5).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
            ),
            child: const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 12),
          Text('Mulai Program 90 Hari', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text('Tentukan target kesehatan Anda.', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMedium), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          
          _buildFormInput(
            label: 'Target Tidur', icon: Icons.bedtime_rounded, iconColor: const Color(0xFF1E88E5),
            controller: _sleepController, hint: '7.5', suffix: 'Jam', keyboardType: const TextInputType.numberWithOptions(decimal: true)
          ),
          const SizedBox(height: 12),
          _buildFormInput(
            label: 'Target Jalan', icon: Icons.directions_walk_rounded, iconColor: Colors.green,
            controller: _walkController, hint: '45', suffix: 'Menit', keyboardType: TextInputType.number
          ),
          const SizedBox(height: 12),
          _buildFormInput(
            label: 'Tujuan Nutrisi', icon: Icons.restaurant_rounded, iconColor: Colors.orange,
            controller: _nutritionController, hint: 'Contoh: Kurangi Gula', keyboardType: TextInputType.text
          ),
          
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _handleEnroll,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isSubmitting
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text('Mulai Sekarang', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFormInput({required String label, required IconData icon, required Color iconColor, required TextEditingController controller, required String hint, String? suffix, required TextInputType keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 44, // Reduce textfield height
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[400]),
              suffixText: suffix,
              suffixStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[200]!)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[200]!)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1E88E5))),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIntervensi90Hari() {
    final day = _planData!['day'] as int;
    final progress = day / 90.0;
    final percent = (progress * 100).toInt();
    final remaining = 90 - day;
    final phase = day <= 30 ? 1 : day <= 60 ? 2 : 3;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))]),
      child: Row(children: [
        SizedBox(width: 70, height: 70, child: Stack(fit: StackFit.expand, children: [
          CircularProgressIndicator(value: progress, strokeWidth: 6, backgroundColor: Colors.grey[200], valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5))),
          Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('$percent%', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            Text('Selesai', style: GoogleFonts.poppins(fontSize: 8, color: AppColors.textMedium)),
          ])),
        ])),
        const SizedBox(width: 20),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Intervensi 90 Hari', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 4),
          Text('Hari ke-$day dari 90', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMedium)),
          const SizedBox(height: 8),
          Text('$remaining hari tersisa • Fase $phase/3', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF1E88E5))),
          const SizedBox(height: 6),
          ClipRRect(borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[200], valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E88E5)), minHeight: 4)),
        ])),
      ]),
    );
  }

  Widget _buildLevelXP() {
    final level = _planData!['level'] as int;
    final xp = _planData!['xp'] as int;
    final xpToNextLevel = _planData!['xpToNextLevel'] as int;
    final targetXP = xp + xpToNextLevel;
    final progress = (500 - xpToNextLevel) / 500.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Level & XP', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFFFFBEB), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFFDE68A))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt_rounded, size: 14, color: Color(0xFFD97706)),
                const SizedBox(width: 4),
                Text('Level $level', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFD97706))),
              ],
            )),
        ]),
        const SizedBox(height: 16),
        ClipRRect(borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[200], valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)), minHeight: 8)),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('$xp / $targetXP XP', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMedium)),
          Text('$xpToNextLevel XP lagi ke Level ${level + 1}', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFFD97706))),
        ]),
      ]),
    );
  }

  Widget _buildFaseIntervensi() {
    final day = _planData!['day'] as int;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Fase Intervensi', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        const SizedBox(height: 16),
        _buildFaseStep(
          number: '1',title: 'Stabilisasi Dasar',days: 'Hari 1-30',isActive: day <= 30,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PhaseDetailScreen())),
          content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: [_buildFaseChip(Icons.trending_down_rounded, '<40g'), _buildFaseChip(Icons.directions_run_rounded, '20 mnt'), _buildFaseChip(Icons.bedtime_rounded, '7 jam')]),
            const SizedBox(height: 12),
            Text('Ketuk untuk detail →', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF1E88E5))),
          ])),
        const SizedBox(height: 16),
        _buildFaseStep(
          number: '2',title: 'Optimalisasi Metabolik',days: 'Hari 31-60',isActive: day > 30 && day <= 60,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Phase2Screen())),
          content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [_buildFaseChip(Icons.trending_down_rounded, '<30g'), _buildFaseChip(Icons.directions_run_rounded, '200 mnt'), _buildFaseChip(Icons.bedtime_rounded, '7.5 jam')]),
            const SizedBox(height: 8),
            Text('Ketuk untuk detail →', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF1E88E5))),
          ])),
        const SizedBox(height: 16),
        _buildFaseStep(
          number: '3',title: 'Konsolidasi',days: 'Hari 61-90',isActive: day > 60,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Phase3Screen())),
          content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [_buildFaseChip(Icons.trending_down_rounded, '<25g'), _buildFaseChip(Icons.directions_run_rounded, '250 mnt'), _buildFaseChip(Icons.bedtime_rounded, '8 jam')]),
            const SizedBox(height: 8),
            Text('Ketuk untuk detail →', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF1E88E5))),
          ])),
      ]),
    );
  }

  Widget _buildFaseStep({required String number, required String title, required String days, required bool isActive, required Widget content, VoidCallback? onTap}) {
    return GestureDetector(onTap: onTap, child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isActive ? Colors.white : const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? const Color(0xFF1E88E5) : const Color(0xFFF1F5F9), width: isActive ? 1.5 : 1.0),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 36, height: 36,
          decoration: BoxDecoration(color: isActive ? const Color(0xFF1E88E5) : Colors.grey[200], shape: BoxShape.circle),
          child: Center(child: Text(number, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: isActive ? Colors.white : Colors.grey[600])))),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: isActive ? AppColors.textDark : Colors.grey[600])),
            if (isActive) ...[const SizedBox(width: 8),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFF1E88E5), borderRadius: BorderRadius.circular(10)),
                child: Text('AKTIF', style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)))],
          ]),
          Text(days, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500])),
          content,
        ])),
      ]),
    ));
  }

  Widget _buildFaseChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFFFFBEB), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFFDE68A))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFFD97706)),
          const SizedBox(width: 4),
          Text(text, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFFD97706))),
        ],
      )
    );
  }



  Widget _buildGlucoseTracker() {
    final bool hasTrackedToday = _planData?['todayGlucose'] == true;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red[50]!),
        boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))]
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.water_drop_rounded, color: Colors.red[400], size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cek Gula Darah', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  Text('Opsional, disarankan setiap 14 hari', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMedium)),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
        if (hasTrackedToday)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.green[100]!)),
            child: Row(
              children: [
                Icon(Icons.verified_rounded, color: Colors.green[600]),
                const SizedBox(width: 12),
                Expanded(child: Text('Luar biasa! Gula darah Anda hari ini sudah tersimpan.', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green[700]))),
              ],
            )
          )
        else
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _glucoseController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Kadar (mg/dL)',
                    hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400], fontWeight: FontWeight.normal),
                    prefixIcon: Icon(Icons.monitor_heart_rounded, color: Colors.grey[400], size: 20),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.red[300]!)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _handleGlucoseSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _isSubmitting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text('Simpan', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              )
            ],
          )
      ]),
    );
  }

  Widget _buildAktivitasChart() {
    final data = [40.0, 65.0, 30.0, 75.0, 45.0, 60.0, 40.0];
    final labels = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Aktivitas 7 Hari Terakhir', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        const SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(7, (i) => Column(children: [
            Container(width: 32, height: data[i], decoration: BoxDecoration(color: const Color(0xFF60A5FA), borderRadius: BorderRadius.circular(6))),
            const SizedBox(height: 8),
            Text(labels[i], style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500])),
          ]))),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Rendah', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500])),
          Text('Menit aktif/hari', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF1E88E5))),
          Text('Tinggi', style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500])),
        ]),
      ]),
    );
  }

  Widget _buildPengingat(bool isDailyReminderOn) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Pengingat', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          Text(isDailyReminderOn ? '1 aktif' : '0 aktif', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF1E88E5))),
        ]),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey[100]!), borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF1E88E5).withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.notifications_active_rounded, color: Color(0xFF1E88E5), size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Pengingat Target Harian', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              Text('Notifikasi untuk mengisi progres target harian', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500])),
            ])),
            Switch(
              value: isDailyReminderOn, 
              activeColor: const Color(0xFF1E88E5),
              onChanged: (val) async {
                await ref.read(dailyReminderProvider.notifier).toggle(val);
                if (val) {
                  await NotificationService().scheduleDailyReminder();
                } else {
                  await NotificationService().cancelDailyReminder();
                }
              }
            )
          ]),
        ),
      ]),
    );
  }
}
