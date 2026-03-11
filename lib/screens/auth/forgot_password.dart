import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth.provider.dart';
import 'package:hugeicons/hugeicons.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _sent = false;

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authProvider.notifier)
          .requestPasswordReset(_emailController.text);
      if (mounted) {
        setState(() => _sent = true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
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
            top: -80,
            right: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFF6B9D).withOpacity(0.2),
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
                  padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowLeft01,
                      color: Color(0xFFD6006A),
                      size: 24,
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: _sent
                        ? _SuccessView(onBack: () => context.pop())
                        : _FormView(
                            emailController: _emailController,
                            isLoading: _isLoading,
                            onSubmit: _resetPassword,
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

class _FormView extends StatelessWidget {
  final TextEditingController emailController;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _FormView({
    required this.emailController,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),

        // Icon illustration
        Center(
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFD6E7),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B9D).withOpacity(0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.lock_reset_rounded,
              size: 42,
              color: Color(0xFFD6006A),
            ),
          ),
        ),

        const SizedBox(height: 28),

        Text(
          'Forgot\nPassword? 🔐',
          style: GoogleFonts.gabarito(
            fontSize: 38,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFD6006A),
            height: 1.15,
            letterSpacing: -1,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'No worries, we\'ll send you a reset link right away.',
          style: GoogleFonts.nunito(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF8B4263),
            height: 1.5,
          ),
        ),

        const SizedBox(height: 44),

        Text(
          'Email Address',
          style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF8B4263),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          style: GoogleFonts.nunito(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF3D0020),
          ),
          decoration: InputDecoration(
            hintText: 'alex@example.com',
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
              borderSide: const BorderSide(color: Color(0xFFFF6B9D), width: 2),
            ),
            prefixIcon: const Icon(
              Icons.mail_outline_rounded,
              color: Color(0xFFFF6B9D),
            ),
          ),
        ),

        const SizedBox(height: 36),

        SizedBox(
          height: 56,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B9D), Color(0xFFFF4081)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF4081).withOpacity(0.4),
                  blurRadius: 18,
                  spreadRadius: -4,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: isLoading ? null : onSubmit,
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
                  : Text(
                      'Send Reset Link',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  final VoidCallback onBack;
  const _SuccessView({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B9D), Color(0xFFFF4081)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF4081).withOpacity(0.35),
                blurRadius: 28,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.mark_email_read_rounded,
            size: 52,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Check your inbox! 💌',
          textAlign: TextAlign.center,
          style: GoogleFonts.gabarito(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFD6006A),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'We\'ve sent a password reset link to your email. Be sure to check your spam folder too.',
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            fontSize: 15,
            color: const Color(0xFF8B4263),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 48),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: onBack,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFF6B9D), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Text(
              'Back to Login',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFD6006A),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
