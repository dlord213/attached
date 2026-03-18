import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth.provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty)
      return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authProvider.notifier)
          .login(_emailController.text, _passwordController.text);
    } catch (e) {
      if (mounted) {
        _showPixelSnackbar('ERROR: INVALID LOGIN 💔');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showPixelSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.vt323(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: Border.all(color: Colors.white, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC0CB), // Pink background
      body: Stack(
        children: [
          // Pixel grid background
          Positioned.fill(
            child: CustomPaint(
              painter: _PixelGridPainter(),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      PixelIconButton(
                        onPressed: () => context.pop(),
                        icon: Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),

                        // Arcade style heading
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: _pixelDecoration(Colors.white),
                          child: Text(
                            'WELCOME BACK!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.vt323(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFF1493), // Deep pink
                              letterSpacing: 2,
                              height: 1.0,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'CONTINUE YOUR ADVENTURE',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.vt323(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 1.5,
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Form Fields
                        const _PixelLabel(text: 'EMAIL ADDRESS:'),
                        const SizedBox(height: 8),
                        _PixelTextField(
                          controller: _emailController,
                          hint: 'PLAYER1@HEART.COM',
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 24),

                        const _PixelLabel(text: 'SECRET PASSWORD:'),
                        const SizedBox(height: 8),
                        _PixelTextField(
                          controller: _passwordController,
                          hint: '********',
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              color: const Color(0xFFFF1493),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Action Button
                        PixelButton(
                          onPressed: _isLoading ? () {} : _login,
                          color: const Color(0xFFFF1493),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 4,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'LOG IN',
                                  style: GoogleFonts.vt323(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 2,
                                  ),
                                ),
                        ),

                        const SizedBox(height: 32),

                        // Footer Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "NEW PLAYER? ",
                              style: GoogleFonts.vt323(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.pushReplacement('/register'),
                              child: Text(
                                'START HERE',
                                style: GoogleFonts.vt323(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFF1493),
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2,
                                  decorationColor: const Color(0xFFFF1493),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),
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

  BoxDecoration _pixelDecoration(Color color) {
    return BoxDecoration(
      color: color,
      border: Border.all(color: Colors.black, width: 4),
      boxShadow: const [
        BoxShadow(
          color: Colors.black,
          offset: Offset(4, 4),
          blurRadius: 0,
        ),
      ],
    );
  }
}

// ─── Shared Pixel Widgets ───────────────────────────────────────────────────

class _PixelLabel extends StatelessWidget {
  final String text;
  const _PixelLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.vt323(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        letterSpacing: 1,
      ),
    );
  }
}

class _PixelTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;

  const _PixelTextField({
    this.controller,
    required this.hint,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.vt323(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.vt323(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black38,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

class PixelButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;

  const PixelButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color = Colors.pinkAccent,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
  });

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        margin: EdgeInsets.only(
          top: _isPressed ? 4.0 : 0.0,
          left: _isPressed ? 4.0 : 0.0,
          bottom: _isPressed ? 0.0 : 4.0,
          right: _isPressed ? 0.0 : 4.0,
        ),
        decoration: BoxDecoration(
          color: widget.color,
          border: Border.all(color: Colors.black, width: 4),
          boxShadow: _isPressed
              ? []
              : const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  )
                ],
        ),
        padding: widget.padding,
        child: Center(child: widget.child),
      ),
    );
  }
}

class PixelIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;

  const PixelIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return PixelButton(
      onPressed: onPressed,
      color: color,
      padding: const EdgeInsets.all(12),
      child: Icon(icon, color: Colors.black, size: 28),
    );
  }
}

class _PixelGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2;

    const spacing = 40.0;
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
