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
    // Pre-fill the current name asynchronously since we can't watch in initState
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
        ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edit Profile',
            style: GoogleFonts.gabarito(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFD6006A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: GestureDetector(
              onTap: _pickAvatar,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFD6E7),
                      image: _selectedAvatarPath != null
                          ? DecorationImage(
                              image: FileImage(File(_selectedAvatarPath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                      border: Border.all(
                        color: const Color(0xFFFF6B9D),
                        width: 2,
                      ),
                    ),
                    child: _selectedAvatarPath == null
                        ? const Center(
                            child: Icon(
                              Icons.person_rounded,
                              size: 48,
                              color: Color(0xFFD6006A),
                            ),
                          )
                        : null,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD6006A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Name',
            style: GoogleFonts.nunito(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF8B4263),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Your name',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              filled: true,
              fillColor: const Color(0xFFFFF0F5).withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFFFD6E7)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFFFD6E7)),
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
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B9D),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      'Save Changes',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
