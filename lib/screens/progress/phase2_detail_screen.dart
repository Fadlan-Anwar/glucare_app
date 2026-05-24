import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Phase2Screen extends StatelessWidget {
  const Phase2Screen({super.key});

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
                  Color(0xFF8B5CF6),
                  Color(0xFFC4B5FD),
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
                      'FASE 2 • Hari 31-60',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Optimalisasi Metabolik',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Meningkatkan sensitivitas insulin dan energi tubuh',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _card(
                  'Target Gula',
                  '< 30g per hari',
                  Icons.bloodtype,
                ),

                _card(
                  'Aktivitas',
                  '45 menit olahraga',
                  Icons.directions_run,
                ),

                _card(
                  'Tidur',
                  '7.5 jam tidur',
                  Icons.bedtime,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF8B5CF6)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}