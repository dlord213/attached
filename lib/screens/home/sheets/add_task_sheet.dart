import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTaskSheet extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController tagController;
  final void Function(String title, String tag) onAdd;
  const AddTaskSheet({
    super.key,
    required this.controller,
    required this.tagController,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFFFFF0F5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB3CF),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Add a new task',
              style: GoogleFonts.gabarito(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFD6006A),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              style: GoogleFonts.nunito(
                fontSize: 15,
                color: const Color(0xFF3D0020),
              ),
              decoration: InputDecoration(
                hintText: 'e.g. Plan our next date night',
                hintStyle: GoogleFonts.nunito(
                  fontSize: 15,
                  color: const Color(0xFFCB8BA4),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFFFD6E7),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF6B9D),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tagController,
              style: GoogleFonts.nunito(
                fontSize: 15,
                color: const Color(0xFF3D0020),
              ),
              decoration: InputDecoration(
                hintText: 'Tag (e.g. Together, Errands)',
                hintStyle: GoogleFonts.nunito(
                  fontSize: 15,
                  color: const Color(0xFFCB8BA4),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFFFD6E7),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF6B9D),
                    width: 2,
                  ),
                ),
              ),
              onSubmitted: (_) =>
                  onAdd(controller.text.trim(), tagController.text.trim()),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 54,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B9D), Color(0xFFFF4081)],
                  ),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF4081).withOpacity(0.4),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () =>
                      onAdd(controller.text.trim(), tagController.text.trim()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    'Add Task',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
