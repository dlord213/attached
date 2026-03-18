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
          'RECENT MOODS',
          style: GoogleFonts.vt323(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFF1493),
            letterSpacing: 2,
            shadows: const [
              Shadow(color: Colors.black, offset: Offset(2, 2))
            ]
          ),
        ),
        const SizedBox(height: 14),
        moodLogsAsync.when(
          data: (logs) {
            if (logs.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 3),
                      boxShadow: const [
                        BoxShadow(color: Colors.black, offset: Offset(3, 3))
                      ]
                    ),
                    child: Text(
                      'NO RECENT MOODS FOUND.',
                      style: GoogleFonts.vt323(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logs.length > 5 ? 5 : logs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final log = logs[index];
                final isMe = log.user == authRef?.id;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 3,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB6C1),
                          border: Border.all(
                            color: Colors.black,
                            width: 3,
                          ),
                          boxShadow: const [
                            BoxShadow(color: Colors.black, offset: Offset(2, 2))
                          ]
                        ),
                        child: Center(
                          child: Text(
                            log.emoji ?? '😊',
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  isMe ? 'PLAYER 1' : 'PLAYER 2',
                                  style: GoogleFonts.vt323(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFFF1493),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Text(
                                    log.created != null
                                        ? timeago.format(log.created!).toUpperCase()
                                        : '',
                                    style: GoogleFonts.vt323(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              (log.body ?? '').toUpperCase(),
                              style: GoogleFonts.vt323(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.black),
          ),
          error: (err, stack) => Center(
            child: Text(
              'ERROR: $err',
              style: GoogleFonts.vt323(fontSize: 20, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
