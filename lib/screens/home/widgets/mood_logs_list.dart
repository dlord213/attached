import 'package:attached/services/mood_logs.provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:attached/services/auth.provider.dart';

class MoodLogsList extends ConsumerWidget {
  const MoodLogsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodLogsAsync = ref.watch(moodLogsProvider);
    final authRef = ref.read(authProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Recent Moods',
          style: GoogleFonts.gabarito(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFD6006A),
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 14),
        moodLogsAsync.when(
          data: (logs) {
            if (logs.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'No recent moods found.',
                    style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey),
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final log = logs[index];
                final isMe = log.user == authRef?.id;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFFFD6E7),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B9D).withOpacity(0.06),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F5),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFFFD6E7),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            log.emoji ?? '😊',
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  isMe ? 'You' : 'Partner',
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF8B4263),
                                  ),
                                ),
                                Text(
                                  log.created != null
                                      ? timeago.format(log.created!)
                                      : '',
                                  style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              log.body ?? '',
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: \$err')),
        ),
      ],
    );
  }
}
