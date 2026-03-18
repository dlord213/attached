import 'package:attached/screens/home/sheets/update_status_sheet.dart';
import 'package:attached/screens/home/widgets/chip.dart';
import 'package:attached/screens/home/widgets/mood_logs_list.dart';
import 'package:attached/screens/home/widgets/nav_bar.dart';
import 'package:attached/services/auth.provider.dart';
import 'package:attached/services/connection.provider.dart';
import 'package:attached/services/tasks.provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../gallery/gallery_tab.dart';
import 'tasks_tab.dart';
import '../profile/profile_tab.dart';
import '../features/shared_location.dart';
import '../features/shared_curated_list.dart';
import '../../services/presence.provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeBody(greeting: _greeting),
          const GalleryTab(),
          const TasksTab(),
          const SharedCuratedListScreen(),
          const ProfileTab(),
        ],
      ),
      bottomNavigationBar: PinkBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _HomeBody extends ConsumerWidget {
  final String greeting;
  const _HomeBody({required this.greeting});

  void _showUpdateStatusSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const UpdateStatusSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRef = ref.read(authProvider);
    final connectionNotifier = ref.read(connectionProvider.notifier);
    final connectionState = ref.watch(connectionProvider);

    final startedAt = connectionState?.startedRelationshipAt;
    final daysTogether = startedAt != null
        ? DateTime.now().difference(startedAt).inDays
        : 0;
    final tasksAsync = ref.watch(tasksProvider);
    final tasksCount = tasksAsync.value?.length ?? 0;

    final partnerPresenceAsync = ref.watch(partnerPresenceProvider);
    final partnerPresence = partnerPresenceAsync.value;

    return Stack(
      children: [
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
                  const Color(0xFFFF6B9D).withOpacity(0.18),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // ── Header ──────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$greeting',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF8B4263),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          authRef?.name ?? "",
                          style: GoogleFonts.gabarito(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFD6006A),
                            letterSpacing: -0.5,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ── Partner Status Card ─────────────────────────────
                GestureDetector(
                  onTap: () => _showUpdateStatusSheet(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
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
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: Builder(
                      builder: (context) {
                        final partnerName =
                            connectionNotifier.partnerData?.name ?? 'Partner';
                        final initial = partnerName.isNotEmpty
                            ? partnerName[0].toUpperCase()
                            : '?';

                        return Stack(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 58,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.25),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.5),
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      initial,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        partnerName,
                                        style: GoogleFonts.nunito(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${partnerPresence?.emoji ?? "🏠"} ${partnerPresence?.status ?? "At home · Missing you 🥺"}',
                                        style: GoogleFonts.nunito(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white.withOpacity(0.85),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.battery_alert_rounded,
                                                  color: Colors.white,
                                                  size: 12,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${partnerPresence?.battery is Map ? partnerPresence?.battery['level'] : partnerPresence?.battery ?? "0"}% (Buddy)',
                                                  style: GoogleFonts.nunito(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons
                                                      .do_not_disturb_on_rounded,
                                                  color: Colors.white,
                                                  size: 12,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  partnerPresence?.isDnd == true
                                                      ? 'DND Active'
                                                      : 'DND Off',
                                                  style: GoogleFonts.nunito(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SharedLocationScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD6006A).withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          IgnorePointer(
                            child: SizedBox.expand(
                              child: FlutterMap(
                                options: const MapOptions(
                                  initialCenter: LatLng(51.509865, -0.118092),
                                  initialZoom: 13.0,
                                  interactionOptions: InteractionOptions(
                                    flags: InteractiveFlag.none,
                                  ),
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.attached.app',
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: const LatLng(
                                          51.509865,
                                          -0.118092,
                                        ),
                                        width: 30,
                                        height: 30,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(0xFFFF6B9D),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.favorite_rounded,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.5),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 16,
                            bottom: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Builder(
                                  builder: (context) {
                                    final partnerName =
                                        connectionNotifier.partnerData?.name ??
                                        'Partner\'s';
                                    return Text(
                                      "$partnerName Location",
                                      style: GoogleFonts.gabarito(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Live sharing',
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ── Relationship chips ──────────────────────────────
                Row(
                  children: [
                    RelationshipChip(
                      emoji: '🗓️',
                      label:
                          'Day ${daysTogether > 0 ? daysTogether : 1} together',
                    ),
                    const SizedBox(width: 10),
                    RelationshipChip(
                      emoji: '✅',
                      label: '$tasksCount tasks pending',
                    ),
                  ],
                ),

                const MoodLogsList(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
