import 'package:attached/services/auth.provider.dart';
import 'package:attached/services/connection.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Invite sent 💌')));
          context.pushReplacement("/");
        }
        if (result == 302) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Invite already sent 💕')));
          context.pushReplacement("/");
        }
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

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _myUniqueId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ID copied! Share it with your partner 💋')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    _myUniqueId = authState?.id ?? "";

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      body: Stack(
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
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
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const HugeIcon(
                          icon: HugeIcons.strokeRoundedArrowLeft01,
                          color: Color(0xFFD6006A),
                          size: 24,
                        ),
                      ),
                      const Spacer(),
                      // Pending invites shortcut
                      TextButton.icon(
                        onPressed: () => context.push("/invitation"),
                        icon: const HugeIcon(
                          icon: HugeIcons.strokeRoundedSent02,
                          color: Color(0xFFFF6B9D),
                          size: 20,
                        ),
                        label: Text(
                          'Pending',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFF6B9D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),

                        // Hero graphic — two overlapping hearts
                        _HeartGraphic(),

                        const SizedBox(height: 28),

                        // OneUI-style big heading
                        Text(
                          'Better\ntogether 💑',
                          textAlign: TextAlign.center,
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
                          'Enter your partner\'s unique ID to start sharing your journey, memories, and more.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF8B4263),
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 36),

                        // Input label
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Partner's ID or Username",
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF8B4263),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _partnerUsernameController,
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF3D0020),
                          ),
                          decoration: InputDecoration(
                            hintText: 'e.g. LOVE-123-456',
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
                            prefixIcon: const Icon(
                              Icons.favorite_outline_rounded,
                              color: Color(0xFFFF6B9D),
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
                              borderSide: const BorderSide(
                                color: Color(0xFFFF6B9D),
                                width: 2,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Send invite button
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
                              onPressed: _isLoading ? null : _connectPartner,
                              icon: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const HugeIcon(
                                      icon: HugeIcons.strokeRoundedSent,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                              label: Text(
                                _isLoading ? 'Sending...' : 'Send Invite 💌',
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

                        const SizedBox(height: 40),

                        // OR divider
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      const Color(0xFFFFB3CF),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: Text(
                                'OR',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFCB8BA4),
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFFFFB3CF),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // Your Unique ID card — OneUI card style
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: const Color(0xFFFFD6E7),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFFF6B9D,
                                ).withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFFFD6E7),
                                    ),
                                    child: const Icon(
                                      Icons.badge_outlined,
                                      size: 20,
                                      color: Color(0xFFD6006A),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Your Unique ID',
                                    style: GoogleFonts.nunito(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFFD6006A),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              Container(
                                padding: const EdgeInsets.only(
                                  left: 18,
                                  right: 6,
                                  top: 4,
                                  bottom: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF0F5),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFFFFD6E7),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _myUniqueId,
                                        style: GoogleFonts.sourceCodePro(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.5,
                                          color: const Color(0xFF3D0020),
                                        ),
                                      ),
                                    ),
                                    Tooltip(
                                      message: "Copy ID",
                                      child: IconButton(
                                        onPressed: _copyToClipboard,
                                        icon: Container(
                                          padding: const EdgeInsets.all(7),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFFF6B9D),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.copy_rounded,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 12),

                              Text(
                                'Share this ID with your partner so they can connect with you! 💕',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: const Color(0xFF8B4263),
                                  height: 1.5,
                                ),
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
}

/// Two overlapping heart circles illustration
class _HeartGraphic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background soft blush card
          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFE4EF), Color(0xFFFFD6EA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Left circle
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF85A1), Color(0xFFFF4081)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF4081).withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              // Plus connector
              Transform.translate(
                offset: const Offset(-14, 0),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFFF6B9D),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Color(0xFFFF6B9D),
                    size: 24,
                  ),
                ),
              ),
              // Right circle
              Transform.translate(
                offset: const Offset(-28, 0),
                child: Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFB3CF), Color(0xFFFF85A1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF85A1).withOpacity(0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
