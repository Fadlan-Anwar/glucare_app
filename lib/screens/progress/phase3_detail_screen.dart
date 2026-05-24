import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Phase3Screen extends StatelessWidget {
  const Phase3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF10B981),
                  Color(0xFFA7F3D0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'FASE 3 • Hari 61-90',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Konsolidasi',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                   const SizedBox(height: 8),

Text(
  'Mempertahankan pola hidup sehat secara konsisten',
  style: GoogleFonts.poppins(
    color: Colors.white,
    fontSize: 12,
  ),
),

const SizedBox(height: 24),
],
),
),
),
),

Expanded(
  child: ListView(
    padding: const EdgeInsets.all(20),
    children: [

      _buildCard(
        icon: Icons.favorite_rounded,
        title: 'Kesehatan Jantung',
        subtitle: 'Jaga tekanan darah & gula stabil',
      ),

      _buildCard(
        icon: Icons.restaurant_rounded,
        title: 'Pola Makan',
        subtitle: 'Makan real food & rendah gula',
      ),

      _buildCard(
        icon: Icons.directions_run_rounded,
        title: 'Aktivitas',
        subtitle: '60 menit aktivitas fisik',
      ),

      _buildCard(
        icon: Icons.self_improvement_rounded,
        title: 'Stress Management',
        subtitle: 'Meditasi & quality time',
      ),

      _buildCard(
        icon: Icons.bedtime_rounded,
        title: 'Tidur Berkualitas',
        subtitle: 'Tidur 8 jam setiap malam',
      ),

    ],
  ),
),
],
),
);
}

Widget _buildCard({
required IconData icon,
required String title,
required String subtitle,
}) {
return Container(
  margin: const EdgeInsets.only(bottom: 16),
  padding: const EdgeInsets.all(20),
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

  child: Row(
    children: [

      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFD1FAE5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF10B981),
        ),
      ),

      const SizedBox(width: 16),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 4),

            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
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