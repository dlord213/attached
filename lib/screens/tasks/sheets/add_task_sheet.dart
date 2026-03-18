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
        decoration: BoxDecoration(
          color: const Color(0xFFFFB6C1),
          border: Border.all(color: Colors.black, width: 4),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0, -8),
            )
          ]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 6,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'NEW QUEST!',
              style: GoogleFonts.vt323(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 20),
            
            // Task input
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 4),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(4, 4))
                ]
              ),
              child: TextField(
                controller: controller,
                autofocus: true,
                style: GoogleFonts.vt323(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g. PLAN A DATE',
                  hintStyle: GoogleFonts.vt323(
                    fontSize: 24,
                    color: Colors.black38,
                  ),
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
            const SizedBox(height: 24),
            
            // Tag input
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 4),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(4, 4))
                ]
              ),
              child: TextField(
                controller: tagController,
                style: GoogleFonts.vt323(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'TAG (e.g. FUN)',
                  hintStyle: GoogleFonts.vt323(
                    fontSize: 24,
                    color: Colors.black38,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) =>
                    onAdd(controller.text.trim(), tagController.text.trim()),
              ),
            ),
            const SizedBox(height: 32),
            
            // Submit button
            GestureDetector(
              onTap: () => onAdd(controller.text.trim(), tagController.text.trim()),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF1493),
                  border: Border.all(color: Colors.black, width: 4),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(4, 4))
                  ]
                ),
                alignment: Alignment.center,
                child: Text(
                  'ADD QUEST',
                  style: GoogleFonts.vt323(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
