import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class PinkBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const PinkBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      (HugeIcons.strokeRoundedHome11, 'HOME'),
      (HugeIcons.strokeRoundedImage01, 'GALLERY'),
      (HugeIcons.strokeRoundedTask01, 'TASKS'),
      (HugeIcons.strokeRoundedUser, 'PROFILE'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.black, width: 4),
        ),
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
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFFFF1493) : Colors.transparent,
                    border: Border.all(
                      color: selected ? Colors.black : Colors.transparent,
                      width: selected ? 3 : 0,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HugeIcon(
                        icon: items[i].$1,
                        color: selected ? Colors.white : Colors.black,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[i].$2,
                        style: GoogleFonts.vt323(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selected ? Colors.white : Colors.black,
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
