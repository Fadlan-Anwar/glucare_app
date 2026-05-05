import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/dashboard_screen.dart';

class RecommendationContent extends StatefulWidget {
  const RecommendationContent({super.key});

  @override
  State<RecommendationContent> createState() => _RecommendationContentState();
}

class _RecommendationContentState extends State<RecommendationContent> {
  int _selectedFilterIndex = 0;

  List<Map<String, dynamic>> get _filters => [
    {'label': 'Semua', 'icon': Icons.star_rounded, 'count': 10},
    {'label': 'Aktivitas', 'icon': Icons.directions_run_rounded, 'count': 2},
    {'label': 'Nutrisi', 'icon': Icons.restaurant_rounded, 'count': 3},
    {'label': 'Tidur', 'icon': Icons.bed_rounded, 'count': 2},
    {'label': 'Terapi', 'icon': Icons.medical_services_rounded, 'count': 1},
    {'label': 'Edukasi', 'icon': Icons.menu_book_rounded, 'count': 2},
  ];

  List<Map<String, dynamic>> get _tasks => [
    {
      'icon': Icons.directions_walk_rounded,
      'category': 'Aktivitas',
      'catColor': const Color(0xFF10B981),
      'isHighPriority': true,
      'title': 'Jalan Kaki 30 Menit Setelah Makan',
      'desc': 'Berjalan kaki santai selama 30 menit setelah makan besar dapat membantu menstabilkan lonjakan gula darah dan meningkatkan sensitivitas insulin.',
    },
    {
      'icon': Icons.fitness_center_rounded,
      'category': 'Aktivitas',
      'catColor': const Color(0xFF10B981),
      'isHighPriority': false,
      'title': 'Latihan Kekuatan 2x Seminggu',
      'desc': 'Melakukan latihan beban atau resistensi 2 kali seminggu membantu membangun massa otot yang dapat menyerap dan menggunakan glukosa lebih efektif.',
    },
    {
      'icon': Icons.restaurant_rounded,
      'category': 'Nutrisi',
      'catColor': const Color(0xFFF59E0B),
      'isHighPriority': true,
      'title': 'Metode Piring Harvard (Plate Method)',
      'desc': 'Isi setengah piring dengan sayuran non-tepung, seperempat dengan protein tanpa lemak, dan seperempat dengan karbohidrat kompleks/biji-bijian utuh.',
    },
    {
      'icon': Icons.block_rounded,
      'category': 'Nutrisi',
      'catColor': const Color(0xFFF59E0B),
      'isHighPriority': true,
      'title': 'Eliminasi Minuman Manis & Ultra-Processed Food',
      'desc': 'Hindari soda, jus manis, dan makanan kemasan ultra-proses karena dapat memicu lonjakan insulin dan meningkatkan peradangan pada tubuh.',
    },
    {
      'icon': Icons.grass_rounded,
      'category': 'Nutrisi',
      'catColor': const Color(0xFFF59E0B),
      'isHighPriority': false,
      'title': 'Pilih Karbohidrat Indeks Glikemik Rendah',
      'desc': 'Ganti nasi putih atau roti putih dengan nasi merah, quinoa, atau roti gandum utuh yang dicerna lebih lambat sehingga gula darah lebih stabil.',
    },
    {
      'icon': Icons.bedtime_rounded,
      'category': 'Tidur',
      'catColor': const Color(0xFF8B5CF6),
      'isHighPriority': false,
      'title': 'Konsisten Jadwal Tidur 7-8 jam',
      'desc': 'Kurang tidur meningkatkan hormon stres (kortisol) yang secara langsung menurunkan fungsi insulin. Usahakan tidur 7-8 jam per malam.',
    },
    {
      'icon': Icons.phonelink_off_rounded,
      'category': 'Tidur',
      'catColor': const Color(0xFF8B5CF6),
      'isHighPriority': false,
      'title': 'Hindari Layar 1 Jam Sebelum Tidur',
      'desc': 'Paparan cahaya biru dari layar gawai dapat menekan produksi hormon melatonin yang dibutuhkan untuk tidur lelap.',
    },
    {
      'icon': Icons.medication_rounded,
      'category': 'Terapi',
      'catColor': const Color(0xFFEF4444),
      'isHighPriority': true,
      'title': 'Rutin Minum Obat',
      'desc': 'Minumlah obat yang diresepkan dokter tepat waktu sesuai anjuran untuk mengontrol kadar glukosa darah Anda.',
    },
    {
      'icon': Icons.biotech_rounded,
      'category': 'Edukasi',
      'catColor': const Color(0xFF06B6D4),
      'isHighPriority': false,
      'title': 'Memahami Resistensi Insulin',
      'desc': 'Pelajari bagaimana sel-sel tubuh menolak respon insulin sehingga tubuh harus memproduksi lebih banyak insulin untuk memasukkan glukosa ke sel.',
    },
    {
      'icon': Icons.bar_chart_rounded,
      'category': 'Edukasi',
      'catColor': const Color(0xFF06B6D4),
      'isHighPriority': false,
      'title': 'Target HbA1c untuk Fase Prediabetes',
      'desc': 'Tujuan utama pada fase prediabetes adalah menurunkan HbA1c kembali ke bawah 5.7% melalui modifikasi gaya hidup.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: DashboardContent.hasRiskDataNotifier,
      builder: (context, hasRiskData, child) {
        final selectedFilterLabel = _filters[_selectedFilterIndex]['label'] as String;
        final displayedTasks = selectedFilterLabel == 'Semua' 
            ? _tasks 
            : _tasks.where((t) => t['category'] == selectedFilterLabel).toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FB),
          body: Column(
            children: [
              _buildHeader(hasRiskData),
              _buildFilters(),
              Expanded(
                child: CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return _ExpandableTaskCard(task: displayedTasks[index]);
                          },
                          childCount: displayedTasks.length,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _buildDisclaimer(),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 30),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool hasRiskData) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rencana Intervensi',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Skor risiko prediabetes personalmu',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 24),

              GestureDetector(
                onTap: () {
                  if (!hasRiskData) {
                    Navigator.pushNamedAndRemoveUntil(context, '/analysis', (route) => false);
                  } else {
                    Navigator.pushNamedAndRemoveUntil(context, '/progress', (route) => false);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          hasRiskData ? Icons.calendar_month_rounded : Icons.analytics_outlined, 
                          color: const Color(0xFF1E88E5), 
                          size: 20
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hasRiskData ? 'Rencana 90 Hari (Hari ke-1)' : 'Mulai Analisis Risiko',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              hasRiskData ? '3 fase intervensi terstruktur' : 'Dapatkan rencana khusus untuk Anda',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        child: Row(
          children: List.generate(_filters.length, (index) {
            final filter = _filters[index];
            final isSelected = index == _selectedFilterIndex;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilterIndex = index),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1D4ED8) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    if (!isSelected)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      filter['icon'] as IconData,
                      size: 16,
                      color: isSelected ? Colors.yellow : Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      filter['label'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white.withValues(alpha: 0.2) : Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${filter['count']}',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4), // Light greenish-cyan background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6EE7B7).withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description_rounded, color: Color(0xFF059669), size: 18),
              const SizedBox(width: 8),
              Text(
                'Penting Diketahui',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF059669),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Rekomendasi ini bersifat edukatif berdasarkan panduan klinis ADA dan WHO. Konsultasikan kondisi Anda dengan dokter atau ahli gizi terdaftar sebelum memulai program intervensi.',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: const Color(0xFF059669),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableTaskCard extends StatefulWidget {
  final Map<String, dynamic> task;

  const _ExpandableTaskCard({required this.task});

  @override
  State<_ExpandableTaskCard> createState() => _ExpandableTaskCardState();
}

class _ExpandableTaskCardState extends State<_ExpandableTaskCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Icon(
                      widget.task['icon'] as IconData,
                      color: widget.task['catColor'] as Color,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.task['category'] as String,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: widget.task['catColor'] as Color,
                            ),
                          ),
                          if (widget.task['isHighPriority'] == true) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Prioritas Tinggi',
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFEF4444),
                                ),
                              ),
                            ),
                          ]
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.task['title'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
                ),
              ],
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFFF3F4F6)),
              const SizedBox(height: 12),
              Text(
                (widget.task['desc'] as String?) ?? 'Deskripsi belum tersedia untuk tugas ini.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}