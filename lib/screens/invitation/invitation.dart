import 'package:attached/services/connection.provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:hugeicons/hugeicons.dart';

class InvitationPage extends ConsumerStatefulWidget {
  const InvitationPage({super.key});

  @override
  ConsumerState<InvitationPage> createState() => _InvitationPageState();
}

class _InvitationPageState extends ConsumerState<InvitationPage> {
  bool _isFetching = true;
  bool _isProcessing = false;
  Map<String, dynamic>? _invitationData;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _fetchInvitation());
  }

  Future<void> _fetchInvitation() async {
    try {
      final data = await ref
          .read(connectionProvider.notifier)
          .getPendingInvitation();
      if (mounted) {
        setState(() {
          _invitationData = data;
          _isFetching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isFetching = false;
        });
      }
    }
  }

  Future<void> _handleAccept() async {
    if (_invitationData == null) return;
    setState(() => _isProcessing = true);
    try {
      final success = await ref
          .read(connectionProvider.notifier)
          .acceptConnection(_invitationData!['id']);
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('YOU\'RE NOW CONNECTED! 💑')),
          );
          context.pushReplacement("/");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('FAILED TO ACCEPT INVITATION.')),
          );
          setState(() => _isProcessing = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ERROR: ${e.toString()}')));
      }
    }
  }

  Future<void> _handleDecline() async {
    if (_invitationData == null) return;
    setState(() => _isProcessing = true);
    try {
      final success = await ref
          .read(connectionProvider.notifier)
          .declineConnection(_invitationData!['id']);
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('INVITATION DECLINED.')));
          context.go('/onboarding');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('FAILED TO DECLINE INVITATION.')),
          );
          setState(() => _isProcessing = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ERROR: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetching) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFC0CB),
        body: Center(
          child: CircularProgressIndicator(color: Colors.black),
        ),
      );
    }

    if (_invitationData == null) {
      return _EmptyInvitationView(
        onBack: () =>
            context.canPop() ? context.pop() : context.go('/onboarding'),
      );
    }

    final inviter = _invitationData?['expand']?['user_1'];
    final inviterName =
        inviter?['name'] ?? inviter?['email'] ?? 'PLAYER 2';

    return Scaffold(
      backgroundColor: const Color(0xFFFFC0CB),
      body: Stack(
        children: [
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
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => context.canPop()
                          ? context.pop()
                          : context.go('/onboarding'),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 3),
                          boxShadow: const [
                            BoxShadow(color: Colors.black, offset: Offset(2, 2))
                          ]
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28.0,
                      vertical: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),

                        // Envelope hero graphic
                        _EnvelopeGraphic(),

                        const SizedBox(height: 48),

                        // Arcade title
                        Text(
                          'NEW PLAYER\nCHALLENGER! 💘',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.vt323(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFF1493),
                            height: 1.0,
                            shadows: const [
                              Shadow(color: Colors.black, offset: Offset(3, 3))
                            ]
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Inviter name card
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                              width: 4,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(6, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF1493),
                                  border: Border.all(color: Colors.black, width: 3),
                                  boxShadow: const [
                                    BoxShadow(color: Colors.black, offset: Offset(2, 2))
                                  ]
                                ),
                                child: Center(
                                  child: Text(
                                    inviterName.isNotEmpty
                                        ? inviterName[0].toUpperCase()
                                        : '?',
                                    style: GoogleFonts.vt323(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    inviterName.toUpperCase(),
                                    style: GoogleFonts.vt323(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'WANTS TO CO-OP WITH YOU.',
                                    style: GoogleFonts.vt323(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        Text(
                          'ACCEPT TO SHARE YOUR JOURNEY, MEMORIES, AND MOMENTS TOGETHER. 🌹',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.vt323(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Accept button
                        GestureDetector(
                          onTap: _isProcessing ? null : _handleAccept,
                          child: Container(
                            width: double.infinity,
                            height: 64,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF1493),
                              border: Border.all(color: Colors.black, width: 4),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: _isProcessing
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'ACCEPT 💕',
                                      style: GoogleFonts.vt323(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Decline button — subtle
                        GestureDetector(
                          onTap: _isProcessing ? null : _handleDecline,
                          child: Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black, width: 4),
                              boxShadow: const [
                                BoxShadow(color: Colors.black, offset: Offset(4, 4))
                              ]
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'DECLINE',
                              style: GoogleFonts.vt323(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 2,
                              ),
                            ),
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
}

/// Empty invitation state view
class _EmptyInvitationView extends StatelessWidget {
  final VoidCallback onBack;
  const _EmptyInvitationView({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC0CB),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _PixelGridPainter(),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: onBack,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 3),
                          boxShadow: const [
                            BoxShadow(color: Colors.black, offset: Offset(2, 2))
                          ]
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black, width: 6),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(8, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.inbox,
                              size: 64,
                              color: Color(0xFFFF1493),
                            ),
                          ),
                          const SizedBox(height: 36),
                          Text(
                            'NO INVITES YET!',
                            style: GoogleFonts.vt323(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFF1493),
                              letterSpacing: 2,
                              shadows: const [
                                Shadow(color: Colors.black, offset: Offset(2, 2))
                              ]
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'PLAYER 2 HAS NOT SENT AN INVITE YET. SHARE YOUR ID AND WAIT FOR THE MAGIC! ✨',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.vt323(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
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

/// Letter envelope / mail graphic
class _EnvelopeGraphic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(6, 6),
          )
        ]
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Basic decorative envelope shapes
          Positioned.fill(
            child: Icon(Icons.mark_email_unread, size: 100, color: const Color(0xFFFF1493)),
          ),
          Positioned(
            top: 20,
            left: 40,
            child: Icon(
              Icons.favorite,
              size: 24,
              color: const Color(0xFFFF1493).withOpacity(0.8),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 50,
            child: Icon(
              Icons.favorite,
              size: 32,
              color: const Color(0xFFFF1493).withOpacity(0.8),
            ),
          ),
        ],
      ),
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
