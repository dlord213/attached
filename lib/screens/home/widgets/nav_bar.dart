import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class PinkBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const PinkBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      (HugeIcons.strokeRoundedHome11, 'Home'),
      (HugeIcons.strokeRoundedImage01, 'Gallery'),
      (HugeIcons.strokeRoundedTask01, 'Tasks'),
      (HugeIcons.strokeRoundedBookOpen01, 'Lists'),
      (HugeIcons.strokeRoundedUser, 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFFFD6E7), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B9D).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final selected = i == currentIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFFF6B9D).withOpacity(0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HugeIcon(
                        icon: items[i].$1,
                        color: selected
                            ? const Color(0xFFD6006A)
                            : const Color(0xFFCB8BA4),
                        size: 22,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        items[i].$2,
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? const Color(0xFFD6006A)
                              : const Color(0xFFCB8BA4),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
