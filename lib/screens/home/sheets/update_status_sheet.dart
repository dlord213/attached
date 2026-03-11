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
      builder: (context) {
        return SizedBox(
          height: 300,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              setState(() {
                _emojiController.text = emoji.emoji;
              });
              Navigator.pop(context);
            },
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
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Status',
              style: GoogleFonts.gabarito(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD6006A),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                GestureDetector(
                  onTap: _showEmojiPicker,
                  child: Container(
                    width: 70,
                    height: 56, // matches typical TextField height
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _emojiController.text.isEmpty
                            ? Colors.grey
                            : const Color(0xFFD6006A),
                        width: _emojiController.text.isEmpty ? 1 : 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _emojiController.text.isEmpty
                          ? '😀'
                          : _emojiController.text,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _statusController,
                    decoration: InputDecoration(
                      labelText: 'Status text',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
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
                        .updateStatus(userId, connectionId, emoji, status);
                  }

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD6006A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Update',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
