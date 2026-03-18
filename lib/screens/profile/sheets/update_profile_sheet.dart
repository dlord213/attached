import 'dart:io';
import 'package:attached/services/auth.provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileSheet extends ConsumerStatefulWidget {
  const UpdateProfileSheet({super.key});

  @override
  ConsumerState<UpdateProfileSheet> createState() => _UpdateProfileSheetState();
}

class _UpdateProfileSheetState extends ConsumerState<UpdateProfileSheet> {
  final _nameController = TextEditingController();
  String? _selectedAvatarPath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider);
      if (user != null && user.name != null) {
        _nameController.text = user.name!;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedAvatarPath = pickedFile.path;
      });
    }
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      await ref
          .read(authProvider.notifier)
          .updateProfile(name: name, avatarPath: _selectedAvatarPath);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('FAILED TO UPDATE PROFILE: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFC0CB),
        border: Border(
          top: BorderSide(color: Colors.black, width: 6),
        ),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              'EDIT PROFILE',
              style: GoogleFonts.vt323(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF1493),
                letterSpacing: 2,
                shadows: const [
                  Shadow(color: Colors.black, offset: Offset(2, 2))
                ]
              ),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: GestureDetector(
              onTap: _pickAvatar,
              child: Stack(
                alignment: Alignment.bottomRight,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width: 4,
                      ),
                      boxShadow: const [
                        BoxShadow(color: Colors.black, offset: Offset(6, 6))
                      ],
                      image: _selectedAvatarPath != null
                          ? DecorationImage(
                              image: FileImage(File(_selectedAvatarPath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _selectedAvatarPath == null
                        ? const Center(
                            child: Icon(
                              Icons.person,
                              size: 64,
                              color: Colors.black,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: -8,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF1493),
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(3, 3))
                        ]
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            'NAME',
            style: GoogleFonts.vt323(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            style: GoogleFonts.vt323(fontSize: 24, color: Colors.black),
            decoration: InputDecoration(
              hintText: 'YOUR NAME',
              hintStyle: GoogleFonts.vt323(fontSize: 24, color: Colors.black38),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              filled: true,
              fillColor: Colors.white,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.black, width: 4),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.black, width: 4),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: _isLoading ? null : _saveProfile,
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFFF1493),
                border: Border.all(color: Colors.black, width: 4),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(4, 4))
                ]
              ),
              alignment: Alignment.center,
              child: _isLoading
                  ? const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 4,
                      ),
                    )
                  : Text(
                      'SAVE CHANGES',
                      style: GoogleFonts.vt323(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
