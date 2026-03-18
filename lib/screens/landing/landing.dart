import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC0CB),
      body: Stack(
        children: [
          // Pixel Background Pattern (Simple grid effect)
          Positioned.fill(child: CustomPaint(painter: _PixelGridPainter())),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),

                  // App Logo / Animated Heart
                  Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.8, end: 1.0),
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.elasticOut,
                      builder: (context, scale, child) {
                        return Transform.scale(scale: scale, child: child);
                      },
                      child: _PixelHeartLogo(),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // App name — Retro Arcade style
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: _pixelDecoration(Colors.white),
                    child: Text(
                      'ATTACHED',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.vt323(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFF1493),
                        letterSpacing: 4,
                        height: 1.0,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'PRESS START TO CONNECT',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.vt323(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      letterSpacing: 2,
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Primary CTA — Pixel button
                  PixelButton(
                    onPressed: () => context.push('/register'),
                    color: const Color(0xFFFF1493),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'GET STARTED',
                          style: GoogleFonts.vt323(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Secondary — Retro button
                  PixelButton(
                    onPressed: () => context.push('/login'),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'LOG IN',
                          style: GoogleFonts.vt323(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFF1493),
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),
                ],
              ),
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
        BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0),
      ],
    );
  }
}

// Background Grid Painter
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

// Custom Pixel Heart Logo
class _PixelHeartLogo extends StatelessWidget {
  const _PixelHeartLogo();

  @override
  Widget build(BuildContext context) {
    final List<String> heartPattern = [
      "01100110",
      "11111111",
      "11111111",
      "01111110",
      "00111100",
      "00011000",
    ];

    const double pixelSize = 16.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(8, 8), blurRadius: 0),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: heartPattern.map((row) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: row.split('').map((char) {
              return Container(
                width: pixelSize,
                height: pixelSize,
                decoration: BoxDecoration(
                  color: char == '1'
                      ? const Color(0xFFFF1493)
                      : Colors.transparent,
                  border: char == '1'
                      ? Border.all(color: Colors.black, width: 2)
                      : null,
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}

// Interactive Pixel Button
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
                  ),
                ],
        ),
        padding: widget.padding,
        child: Center(child: widget.child),
      ),
    );
  }
}
