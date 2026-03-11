import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SharedBucketListScreen extends StatelessWidget {
  const SharedBucketListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFD6006A)),
        title: Text(
          'Bucket List',
          style: GoogleFonts.gabarito(
            color: const Color(0xFFD6006A),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.list_alt_rounded,
              size: 80,
              color: Color(0xFFFF6B9D),
            ),
            const SizedBox(height: 16),
            Text(
              'Shared Bucket List',
              style: GoogleFonts.gabarito(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFD6006A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Goals and dreams to achieve together.',
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: const Color(0xFF8B4263),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
