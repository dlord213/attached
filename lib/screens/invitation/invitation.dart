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
            const SnackBar(content: Text('You\'re now connected! 💑')),
          );
          context.pushReplacement("/");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to accept invitation.')),
          );
          setState(() => _isProcessing = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
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
          ).showSnackBar(const SnackBar(content: Text('Invitation declined.')));
          context.go('/onboarding');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to decline invitation.')),
          );
          setState(() => _isProcessing = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetching) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFF0F5),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFF6B9D)),
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
        inviter?['name'] ?? inviter?['email'] ?? 'Someone special';

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      body: Stack(
        children: [
          // Background blobs
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 300,
              height: 300,
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
          Positioned(
            bottom: 100,
            left: -80,
            child: Container(
              width: 220,
              height: 220,
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
                // Back button
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                  child: IconButton(
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go('/onboarding'),
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowLeft01,
                      color: Color(0xFFD6006A),
                      size: 24,
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

                        const SizedBox(height: 32),

                        // OneUI large title
                        Text(
                          'Someone likes\nyou! 💘',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.gabarito(
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFD6006A),
                            height: 1.15,
                            letterSpacing: -1,
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Inviter name card
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFFFD6E7),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFFF6B9D,
                                ).withOpacity(0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFF6B9D),
                                      Color(0xFFFF4081),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    inviterName.isNotEmpty
                                        ? inviterName[0].toUpperCase()
                                        : '?',
                                    style: GoogleFonts.gabarito(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    inviterName,
                                    style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF3D0020),
                                    ),
                                  ),
                                  Text(
                                    'wants to be attached with you',
                                    style: GoogleFonts.nunito(
                                      fontSize: 12,
                                      color: const Color(0xFF8B4263),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          'Accept to share your journey, memories, and moments together. 🌹',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: const Color(0xFF8B4263),
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 44),

                        // Accept button
                        SizedBox(
                          width: double.infinity,
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
                                  color: const Color(
                                    0xFFFF4081,
                                  ).withOpacity(0.4),
                                  blurRadius: 18,
                                  spreadRadius: -4,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: _isProcessing ? null : _handleAccept,
                              icon: _isProcessing
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const HugeIcon(
                                      icon: HugeIcons
                                          .strokeRoundedCheckmarkBadge01,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                              label: Text(
                                _isProcessing ? 'Accepting...' : 'Accept 💕',
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
                        ),

                        const SizedBox(height: 14),

                        // Decline button — subtle
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: TextButton(
                            onPressed: _isProcessing ? null : _handleDecline,
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: Text(
                              'Decline',
                              style: GoogleFonts.nunito(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFCB8BA4),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
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
      backgroundColor: const Color(0xFFFFF0F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4.0),
              child: IconButton(
                onPressed: onBack,
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowLeft01,
                  color: Color(0xFFD6006A),
                  size: 24,
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
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFFD6E7),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6B9D).withOpacity(0.15),
                              blurRadius: 24,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.inbox_rounded,
                          size: 48,
                          color: Color(0xFFD6006A),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'No invitations yet',
                        style: GoogleFonts.gabarito(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFD6006A),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Your special someone hasn\'t sent you an invite yet. Share your ID and wait for the magic! ✨',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: const Color(0xFF8B4263),
                          height: 1.6,
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
    );
  }
}

/// Letter envelope / mail graphic
class _EnvelopeGraphic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFE4EF), Color(0xFFFFCCE4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Floating hearts
          Positioned(
            top: 20,
            left: 40,
            child: Icon(
              Icons.favorite,
              size: 14,
              color: const Color(0xFFFF6B9D).withOpacity(0.4),
            ),
          ),
          Positioned(
            top: 30,
            right: 50,
            child: Icon(
              Icons.favorite,
              size: 10,
              color: const Color(0xFFFF4081).withOpacity(0.3),
            ),
          ),
          Positioned(
            bottom: 28,
            left: 60,
            child: Icon(
              Icons.favorite,
              size: 8,
              color: const Color(0xFFFF6B9D).withOpacity(0.25),
            ),
          ),
          // Main icon
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B9D), Color(0xFFFF4081)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF4081).withOpacity(0.38),
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.mail_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
