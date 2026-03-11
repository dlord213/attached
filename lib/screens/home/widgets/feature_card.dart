import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final dynamic icon;
  final Color bgColor;
  final Color iconBgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bgColor,
    required this.iconBgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFFFD6E7).withOpacity(0.8),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B9D).withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: HugeIcon(icon: icon, color: iconColor, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF3D0020),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF8B4263),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
