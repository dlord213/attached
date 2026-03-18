import 'package:attached/services/auth.provider.dart';
import 'package:attached/services/connection.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
// Note: hugeicons no longer strictly needed for retro UI but keeping import if needed, although we use standard icons now.
import 'package:hugeicons/hugeicons.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _partnerUsernameController = TextEditingController();
  String _myUniqueId = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _checkPendingInvitation());
  }

  Future<void> _checkPendingInvitation() async {
    try {
      final invitation = await ref
          .read(connectionProvider.notifier)
          .getPendingInvitation();
      if (invitation != null && mounted) {
        context.push('/invitation');
      }
    } catch (e) {
      print('Error checking pending invitations: $e');
    }
  }

  Future<void> _connectPartner() async {
    if (_partnerUsernameController.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      int result = await ref
          .read(connectionProvider.notifier)
          .connectPartner(_partnerUsernameController.text);
      if (mounted) {
        if (result == 200) {
          _showPixelSnackbar('INVITE SENT! <3');
          context.pushReplacement("/");
        }
        if (result == 302) {
          _showPixelSnackbar('INVITE ALREADY SENT!');
          context.pushReplacement("/");
        }
      }
    } catch (e) {
      if (mounted) {
        _showPixelSnackbar('ERROR: ${e.toString()}');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _myUniqueId));
    _showPixelSnackbar('ID COPIED! SHARE THE LOVE!');
  }

  void _showPixelSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.vt323(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: Border.all(color: Colors.white, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    _myUniqueId = authState?.id ?? "";

    return Scaffold(
      backgroundColor: const Color(0xFFFFC0CB), // Pink background
      body: Stack(
        children: [
          // Pixel Background Pattern (Simple grid effect)
          Positioned.fill(child: CustomPaint(painter: _PixelGridPainter())),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PixelIconButton(
                        onPressed: () => context.pop(),
                        icon: Icons.arrow_back,
                        color: Colors.white,
                      ),
                      PixelButton(
                        onPressed: () => context.push("/invitation"),
                        color: const Color(0xFFFF69B4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          'PENDING',
                          style: GoogleFonts.vt323(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        // Animated Pixel Heart
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.8, end: 1.0),
                          duration: Duration(milliseconds: 800),
                          curve: Curves.elasticOut,
                          builder: (context, scale, child) {
                            return Transform.scale(scale: scale, child: child);
                          },
                          child: _PixelHeartGraphic(),
                        ),

                        const SizedBox(height: 30),

                        // Arcade style heading
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: _pixelDecoration(Colors.white),
                          child: Text(
                            'PLAYER 2\nREADY?',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.vt323(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFF1493),
                              height: 1.0,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          'ENTER PARTNER ID TO START CO-OP MODE!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.vt323(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Input Box
                        Container(
                          decoration: _pixelDecoration(Colors.white),
                          child: TextField(
                            controller: _partnerUsernameController,
                            style: GoogleFonts.vt323(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'e.g. LOVE-123',
                              hintStyle: GoogleFonts.vt323(
                                fontSize: 24,
                                color: Colors.black38,
                              ),
                              contentPadding: const EdgeInsets.all(16),
                              prefixIcon: const Icon(
                                Icons.favorite,
                                color: Color(0xFFFF1493),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Action Button
                        PixelButton(
                          onPressed: _isLoading ? () {} : _connectPartner,
                          color: const Color(0xFFFF1493), // Deep pink
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 4,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'SEND INVITE',
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

                        const SizedBox(height: 40),

                        // Unique ID Display
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: _pixelDecoration(const Color(0xFFFFF0F5)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.videogame_asset,
                                    color: Colors.black,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'YOUR PLAYER ID',
                                    style: GoogleFonts.vt323(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                      child: Text(
                                        _myUniqueId.isEmpty
                                            ? 'LOADING...'
                                            : _myUniqueId,
                                        style: GoogleFonts.vt323(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFFF1493),
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  PixelIconButton(
                                    onPressed: _copyToClipboard,
                                    icon: Icons.copy,
                                    color: const Color(0xFFFF69B4),
                                  ),
                                ],
                              ),
                            ],
                          ),
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

// Custom Pixel Heart
class _PixelHeartGraphic extends StatelessWidget {
  const _PixelHeartGraphic();

  @override
  Widget build(BuildContext context) {
    final List<String> heartPattern = [
      "0110110",
      "1111111",
      "1111111",
      "0111110",
      "0011100",
      "0001000",
    ];

    const double pixelSize = 20.0;
    const double borderPixelSize = 24.0;

    return Container(
      decoration: BoxDecoration(
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

// Simple Pixel Icon Button
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
