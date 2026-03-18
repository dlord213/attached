import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:attached/services/auth.provider.dart';
import 'package:attached/services/connection.provider.dart';
import 'package:attached/services/presence.service.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class UpdateStatusSheet extends ConsumerStatefulWidget {
  const UpdateStatusSheet({super.key});

  @override
  ConsumerState<UpdateStatusSheet> createState() => _UpdateStatusSheetState();
}

class _UpdateStatusSheetState extends ConsumerState<UpdateStatusSheet> {
  final _emojiController = TextEditingController();
  final _statusController = TextEditingController();

  void _showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 320,
          decoration: BoxDecoration(
            color: const Color(0xFFFFC0CB),
            border: Border.all(color: Colors.black, width: 4),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _emojiController.text = emoji.emoji;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emojiController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emojiSelected = _emojiController.text.isNotEmpty;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFB6C1),
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, -8),
            blurRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ───────────────────────────────────────
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 6,
            color: Colors.black,
          ),
          const SizedBox(height: 24),

          // ── Icon + title ─────────────────────────────
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFFF1493),
              border: Border.all(color: Colors.black, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.mood,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'UPDATE STATUS',
            style: GoogleFonts.vt323(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'HOW ARE YOU FEELING PLAYER 1?',
            style: GoogleFonts.vt323(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 28),

          // ── Body ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                Text(
                  'YOUR STATUS:',
                  style: GoogleFonts.vt323(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                // Emoji picker + text field row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Emoji tap target
                    GestureDetector(
                      onTap: _showEmojiPicker,
                      child: Container(
                        width: 64,
                        height: 64,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 4),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          emojiSelected ? _emojiController.text : '😊',
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Status text field
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 4),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _statusController,
                          onChanged: (_) => setState(() {}),
                          maxLength: 60,
                          style: GoogleFonts.vt323(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: 'e.g. FEELING COZY',
                            hintStyle: GoogleFonts.vt323(
                              color: Colors.black38,
                              fontSize: 24,
                            ),
                            counterText: '',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Character count
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${_statusController.text.length} / 60',
                    style: GoogleFonts.vt323(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _statusController.text.length > 50
                          ? Colors.red
                          : Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    // Cancel
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 4),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(4, 4),
                              )
                            ]
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'CANCEL',
                            style: GoogleFonts.vt323(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Update Status
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () async {
                          final authRef = ref.read(authProvider);
                          final connectionRef = ref.read(connectionProvider);

                          final emoji = _emojiController.text.trim();
                          final status = _statusController.text.trim();

                          final userId = authRef?.id;
                          final connectionId = connectionRef?.id;

                          if (userId != null &&
                              connectionId != null &&
                              emoji.isNotEmpty &&
                              status.isNotEmpty) {
                            await ref
                                .read(presenceProvider)
                                .updateStatus(
                                  userId,
                                  connectionId,
                                  emoji,
                                  status,
                                );
                          }

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF1493),
                            border: Border.all(color: Colors.black, width: 4),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(4, 4),
                              )
                            ]
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'UPDATE',
                                style: GoogleFonts.vt323(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 28,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
