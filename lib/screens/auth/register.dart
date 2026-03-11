import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth.provider.dart';

import 'package:hugeicons/hugeicons.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _register() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authProvider.notifier)
          .register(
            _emailController.text,
            _passwordController.text,
            _passwordController.text,
            _nameController.text,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      body: Stack(
        children: [
          Positioned(
            top: -70,
            left: -70,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFF6B9D).withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFF85A1).withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const HugeIcon(
                          icon: HugeIcons.strokeRoundedArrowLeft01,
                          color: Color(0xFFD6006A),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),

                        Text(
                          'Get started',
                          style: GoogleFonts.gabarito(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFD6006A),
                            height: 1.15,
                            letterSpacing: -1,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          'Start your journey together.',
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF8B4263),
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 36),

                        _RegisterLabel(text: 'Full Name'),
                        const SizedBox(height: 8),
                        _RegisterTextField(
                          controller: _nameController,
                          hint: 'e.g. Alex Johnson',
                        ),

                        const SizedBox(height: 20),

                        _RegisterLabel(text: 'Email Address'),
                        const SizedBox(height: 8),
                        _RegisterTextField(
                          controller: _emailController,
                          hint: 'alex@example.com',
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 20),

                        _RegisterLabel(text: 'Password'),
                        const SizedBox(height: 8),
                        _RegisterTextField(
                          controller: _passwordController,
                          hint: 'Create a strong password',
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: HugeIcon(
                              icon: _obscurePassword
                                  ? HugeIcons.strokeRoundedView
                                  : HugeIcons.strokeRoundedViewOff,
                              color: const Color(0xFFFF6B9D),
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 28),

                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.nunito(
                              fontSize: 12,
                              color: const Color(0xFF8B4263),
                              height: 1.5,
                            ),
                            children: [
                              const TextSpan(
                                text:
                                    'By creating an account, you agree to our ',
                              ),
                              TextSpan(
                                text: 'Terms of Service',
                                style: const TextStyle(
                                  color: Color(0xFFD6006A),
                                  fontWeight: FontWeight.w700,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: const TextStyle(
                                  color: Color(0xFFD6006A),
                                  fontWeight: FontWeight.w700,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        _PinkGradientButton(
                          onPressed: _register,
                          label: 'Create Account',
                          isLoading: _isLoading,
                        ),

                        const SizedBox(height: 28),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                color: const Color(0xFF8B4263),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.pushReplacement('/login'),
                              child: Text(
                                'Log in',
                                style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFD6006A),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterLabel extends StatelessWidget {
  final String text;
  const _RegisterLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.nunito(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF8B4263),
        letterSpacing: 0.3,
      ),
    );
  }
}

class _RegisterTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;

  const _RegisterTextField({
    this.controller,
    required this.hint,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.nunito(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF3D0020),
      ),
      decoration: InputDecoration(
        hintText: hint,
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
          borderSide: const BorderSide(color: Color(0xFFFFD6E7), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFFF6B9D), width: 2),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class _PinkGradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool isLoading;

  const _PinkGradientButton({
    required this.onPressed,
    required this.label,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B9D), Color(0xFFFF4081)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
