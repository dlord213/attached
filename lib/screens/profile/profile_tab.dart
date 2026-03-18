import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:attached/services/auth.provider.dart';
import 'package:attached/configs/constants.config.dart';
import 'package:attached/services/connection.provider.dart';
import 'package:attached/services/gallery.provider.dart';
import 'package:attached/services/tasks.provider.dart';
import 'package:attached/screens/profile/sheets/update_profile_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    final connectionNotifier = ref.read(connectionProvider.notifier);
    final connectionState = ref.watch(connectionProvider);
    final partner = connectionNotifier.partnerData;
    final galleryAsync = ref.watch(galleryProvider);
    final tasksAsync = ref.watch(tasksProvider);

    final startedAt = connectionState?.startedRelationshipAt;
    final daysTogether = startedAt != null
        ? DateTime.now().difference(startedAt).inDays
        : 0;
    final memoriesCount = galleryAsync.value?.length ?? 0;
    final tasksCount = tasksAsync.value?.length ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFFFC0CB),
      body: Stack(
        children: [
          // Pixel grid background
          Positioned.fill(
            child: CustomPaint(
              painter: _PixelGridPainter(),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // ── Page title ────────────────────────────────
                  Text(
                    'PROFILE',
                    style: GoogleFonts.vt323(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF1493),
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Profile card ──────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF1493),
                      border: Border.all(color: Colors.black, width: 4),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(6, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                              width: 3,
                            ),
                            boxShadow: const [
                              BoxShadow(color: Colors.black, offset: Offset(2, 2)),
                            ]
                          ),
                          child: Center(
                            child: user?.avatar?.isNotEmpty == true
                                ? Image.network(
                                    '${ConstantsConfig.baseApiUrl}/api/files/${user!.collectionId}/${user.id}/${user.avatar!}',
                                    fit: BoxFit.cover,
                                  )
                                : Text(
                                    (user?.name ?? '').isNotEmpty
                                        ? (user?.name ?? '')[0].toUpperCase()
                                        : '?',
                                    style: GoogleFonts.vt323(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFFF1493),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (user?.name ?? 'USER').toUpperCase(),
                                style: GoogleFonts.vt323(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                (user?.email ?? '').toUpperCase(),
                                style: GoogleFonts.vt323(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black, width: 2),
                                ),
                                child: Text(
                                  '💑 IN A RELATIONSHIP',
                                  style: GoogleFonts.vt323(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Edit button
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const UpdateProfileSheet(),
                            );
                          },
                          icon: const Icon(
                            Icons.edit_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Couple stats row ──────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          value: '${daysTogether > 0 ? daysTogether : 1}',
                          label: 'DAYS',
                          icon: HugeIcons.strokeRoundedCalendar01,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          value: '$memoriesCount',
                          label: 'PICS',
                          icon: HugeIcons.strokeRoundedCamera01,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          value: '$tasksCount',
                          label: 'TASKS',
                          icon: HugeIcons.strokeRoundedCheckmarkSquare02,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 36),

                  // ── Partner section ───────────────────────────
                  _SectionLabel(text: 'PLAYER 2'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 4),
                      boxShadow: const [
                        BoxShadow(color: Colors.black, offset: Offset(4, 4))
                      ]
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB6C1),
                            border: Border.all(color: Colors.black, width: 3),
                            boxShadow: const [
                              BoxShadow(color: Colors.black, offset: Offset(2, 2))
                            ]
                          ),
                          child: Center(
                            child: Text(
                              (partner?.name ?? '').isNotEmpty
                                  ? (partner?.name ?? '')[0].toUpperCase()
                                  : '?',
                              style: GoogleFonts.vt323(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFF1493),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (partner?.name ?? 'PARTNER').toUpperCase(),
                                style: GoogleFonts.vt323(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                (partner?.email ?? '').toUpperCase(),
                                style: GoogleFonts.vt323(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ── Relationship settings ─────────────────────
                  _SectionLabel(text: 'SETTINGS'),
                  const SizedBox(height: 12),
                  _SettingsCard(
                    rows: [
                      _SettingsRow(
                        icon: HugeIcons.strokeRoundedCalendar01,
                        label: 'ANNIVERSARY',
                        trailing: startedAt != null
                            ? '${startedAt.month}/${startedAt.day}/${startedAt.year}'
                            : 'SET DATE',
                        onTap: () async {
                          final newDate = await showDatePicker(
                            context: context,
                            initialDate: startedAt ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (newDate != null) {
                            connectionNotifier.updateAnniversary(newDate);
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // ── Sign out ──────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref.read(authProvider.notifier).logout();
                      },
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      label: Text(
                        'QUIT GAME (SIGN OUT)',
                        style: GoogleFonts.vt323(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: const RoundedRectangleBorder(),
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
    );
  }
}

// ─── Stat Card ───────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final dynamic icon;
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          HugeIcon(icon: icon, color: const Color(0xFFFF1493), size: 28),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.vt323(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFF1493),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.vt323(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Label ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.vt323(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: const Color(0xFFFF1493),
        letterSpacing: 1.5,
      ),
    );
  }
}

// ─── Settings Card ───────────────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  final List<_SettingsRow> rows;
  const _SettingsCard({required this.rows});

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
          ),
        ],
      ),
      child: Column(
        children: List.generate(rows.length, (i) {
          final row = rows[i];
          return Column(
            children: [
              InkWell(
                onTap: row.onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB6C1),
                          border: Border.all(color: Colors.black, width: 2),
                          boxShadow: const [
                            BoxShadow(color: Colors.black, offset: Offset(2, 2))
                          ]
                        ),
                        child: Center(
                          child: row.icon is IconData
                              ? Icon(
                                  row.icon as IconData,
                                  color: Colors.black,
                                  size: 20,
                                )
                              : HugeIcon(
                                  icon: row.icon,
                                  color: Colors.black,
                                  size: 20,
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          row.label,
                          style: GoogleFonts.vt323(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      if (row.trailing != null) ...[
                        Text(
                          row.trailing!,
                          style: GoogleFonts.vt323(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFF1493),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.black,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
              if (i < rows.length - 1)
                const Divider(height: 4, color: Colors.black, thickness: 4),
            ],
          );
        }),
      ),
    );
  }
}

class _SettingsRow {
  final dynamic icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;
  const _SettingsRow({
    required this.icon,
    required this.label,
    this.trailing,
    required this.onTap,
  });
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
