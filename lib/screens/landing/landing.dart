import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      body: Stack(
        children: [
          // Soft blush background blobs
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFF6B9D).withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: size.height * 0.25,
            left: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFF85A1).withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

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

                  // App Logo / Heart Icon
                  Center(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B9D), Color(0xFFFF4081)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        size: 56,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // App name — OneUI large bold title style
                  Text(
                    'attached',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.gabarito(
                      fontSize: 52,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFD6006A),
                      letterSpacing: -1.5,
                      height: 1.0,
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Spacer(flex: 3),

                  // Primary CTA — pink gradient pill button
                  _PinkGradientButton(
                    onPressed: () => context.push('/register'),
                    label: 'Get Started',
                    icon: Icons.favorite_border_rounded,
                  ),

                  const SizedBox(height: 14),

                  // Secondary — ghost button
                  SizedBox(
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () => context.push('/login'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFFF6B9D),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        'Log In',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFD6006A),
                        ),
                      ),
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
}

class _PinkGradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;

  const _PinkGradientButton({
    required this.onPressed,
    required this.label,
    required this.icon,
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
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 20, color: Colors.white),
          label: Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      ),
    );
  }
}
