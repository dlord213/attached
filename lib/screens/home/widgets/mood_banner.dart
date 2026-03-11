import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFFD6E7), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B9D).withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: Color(0xFFFF6B9D),
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                "How's your mood today?",
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF8B4263),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              MoodButton(emoji: '😍', label: 'In love'),
              MoodButton(emoji: '😊', label: 'Happy'),
              MoodButton(emoji: '🥺', label: 'Needy'),
              MoodButton(emoji: '😴', label: 'Tired'),
              MoodButton(emoji: '💔', label: 'Sad'),
            ],
          ),
        ],
      ),
    );
  }
}

class MoodButton extends StatelessWidget {
  final String emoji;
  final String label;
  const MoodButton({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFFD6E7), width: 1),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8B4263),
          ),
        ),
      ],
    );
  }
}
