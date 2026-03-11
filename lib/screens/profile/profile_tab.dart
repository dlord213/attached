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
      backgroundColor: const Color(0xFFFFF0F5),
      body: Stack(
        children: [
          // Top blob
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFF6B9D).withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
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
                    'Profile',
                    style: GoogleFonts.gabarito(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFD6006A),
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Profile card ──────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B9D), Color(0xFFFF4081)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF4081).withOpacity(0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
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
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.25),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 2.5,
                            ),
                          ),
                          child: Center(
                            child: user?.avatar?.isNotEmpty == true
                                ? CircleAvatar(
                                    radius: 36,
                                    backgroundImage: NetworkImage(
                                      '${ConstantsConfig.baseApiUrl}/api/files/${user!.collectionId}/${user.id}/${user.avatar!}',
                                    ),
                                    backgroundColor: Colors.transparent,
                                  )
                                : Text(
                                    (user?.name ?? '').isNotEmpty
                                        ? (user?.name ?? '')[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
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
                                user?.name ?? 'User',
                                style: GoogleFonts.gabarito(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                user?.email ?? '',
                                style: GoogleFonts.nunito(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.85),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  '💑 In a relationship',
                                  style: GoogleFonts.nunito(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
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
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Couple stats row ──────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          value: '${daysTogether > 0 ? daysTogether : 1}',
                          label: 'Days together',
                          icon: HugeIcons.strokeRoundedCalendar01,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          value: '$memoriesCount',
                          label: 'Memories',
                          icon: HugeIcons.strokeRoundedCamera01,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          value: '$tasksCount',
                          label: 'Tasks',
                          icon: HugeIcons.strokeRoundedCheckmarkSquare02,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── Partner section ───────────────────────────
                  _SectionLabel(text: 'My Partner'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFFFD6E7),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFD6E7),
                          ),
                          child: Center(
                            child: Text(
                              (partner?.name ?? '').isNotEmpty
                                  ? (partner?.name ?? '')[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFD6006A),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                partner?.name ?? 'Partner',
                                style: GoogleFonts.nunito(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF3D0020),
                                ),
                              ),
                              Text(
                                partner?.email ?? '',
                                style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: const Color(0xFF8B4263),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Relationship settings ─────────────────────
                  _SectionLabel(text: 'Relationship'),
                  const SizedBox(height: 10),
                  _SettingsCard(
                    rows: [
                      _SettingsRow(
                        icon: HugeIcons.strokeRoundedCalendar01,
                        label: 'Anniversary Date',
                        trailing: startedAt != null
                            ? '${startedAt.month}/${startedAt.day}/${startedAt.year}'
                            : 'Set date',
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

                  const SizedBox(height: 28),

                  // ── Sign out ──────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Color(0xFFD6006A),
                        size: 20,
                      ),
                      label: Text(
                        'Sign Out',
                        style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFD6006A),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFFF6B9D),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD6E7), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B9D).withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          HugeIcon(icon: icon, color: const Color(0xFFD6006A), size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.gabarito(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFD6006A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF8B4263),
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
      style: GoogleFonts.gabarito(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: const Color(0xFFD6006A),
        letterSpacing: -0.2,
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD6E7), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B9D).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
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
                borderRadius: BorderRadius.vertical(
                  top: i == 0 ? const Radius.circular(20) : Radius.zero,
                  bottom: i == rows.length - 1
                      ? const Radius.circular(20)
                      : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE4EF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: row.icon is IconData
                              ? Icon(
                                  row.icon as IconData,
                                  color: const Color(0xFFD6006A),
                                  size: 18,
                                )
                              : HugeIcon(
                                  icon: row.icon,
                                  color: const Color(0xFFD6006A),
                                  size: 18,
                                ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          row.label,
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF3D0020),
                          ),
                        ),
                      ),
                      if (row.trailing != null) ...[
                        Text(
                          row.trailing!,
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            color: const Color(0xFF8B4263),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFFCB8BA4),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              if (i < rows.length - 1)
                const Divider(height: 1, color: Color(0xFFFFE4EF), indent: 68),
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
