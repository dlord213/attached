import 'package:attached/models/shared_item_record.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskTile extends StatelessWidget {
  final SharedItemRecord task;
  final String? currentUserId;
  final VoidCallback onToggle;
  const TaskTile({
    super.key,
    required this.task,
    this.currentUserId,
    required this.onToggle,
  });

  Color get _tagColor {
    switch (task.customTag) {
      case 'Date Night':
        return const Color(0xFFFF4081);
      case 'Surprise':
        return const Color(0xFFFF6B9D);
      case 'Travel':
        return const Color(0xFF9C27B0);
      case 'Health':
        return const Color(0xFF4CAF50);
      case 'Errands':
        return const Color(0xFF888888);
      default:
        return const Color(0xFFFF85A1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDone = task.status == SharedItemRecordStatusEnum.completed;

    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDone
              ? const Color(0xFFFFE4EF).withOpacity(0.6)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDone
                ? const Color(0xFFFFD6E7).withOpacity(0.4)
                : const Color(0xFFFFD6E7),
            width: 1.5,
          ),
          boxShadow: isDone
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xFFFF6B9D).withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                gradient: isDone
                    ? const LinearGradient(
                        colors: [Color(0xFFFF6B9D), Color(0xFFFF4081)],
                      )
                    : null,
                color: isDone ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isDone
                    ? null
                    : Border.all(color: const Color(0xFFFF6B9D), width: 2),
              ),
              child: isDone
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title ?? '',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDone
                          ? const Color(0xFFCB8BA4)
                          : const Color(0xFF3D0020),
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      decorationColor: const Color(0xFFCB8BA4),
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Tag chip and creator
                  Row(
                    children: [
                      if (task.customTag != null && task.customTag!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _tagColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            task.customTag!,
                            style: GoogleFonts.nunito(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _tagColor,
                            ),
                          ),
                        ),
                      if (task.customTag != null && task.customTag!.isNotEmpty)
                        const SizedBox(width: 8),
                      // Display creator
                      if (task.createdBy != null)
                        Text(
                          'by ${task.createdBy == currentUserId ? "Me" : "Partner"}',
                          style: GoogleFonts.nunito(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFCB8BA4),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
