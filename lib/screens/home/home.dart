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
import '../tasks/tasks_tab.dart';
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
    if (hour < 12) return 'GOOD MORNING';
    if (hour < 17) return 'GOOD AFTERNOON';
    return 'GOOD EVENING';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC0CB),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeBody(greeting: _greeting),
          const GalleryTab(),
          const TasksTab(),
          // const SharedCuratedListScreen(),
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
        // Pixel grid background
        Positioned.fill(
          child: CustomPaint(
            painter: _PixelGridPainter(),
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
                          '$greeting,',
                          style: GoogleFonts.vt323(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          (authRef?.name ?? "PLAYER 1").toUpperCase(),
                          style: GoogleFonts.vt323(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFF1493),
                            letterSpacing: 2,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ── Partner Status Card (Pixelated) ──────────────────
                GestureDetector(
                  onTap: () => _showUpdateStatusSheet(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF1493),
                      border: Border.all(color: Colors.black, width: 4),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(6, 6),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Builder(
                      builder: (context) {
                        final partnerName =
                            connectionNotifier.partnerData?.name ?? 'PARTNER';
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
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 3,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      initial,
                                      style: GoogleFonts.vt323(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFFF1493),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        partnerName.toUpperCase(),
                                        style: GoogleFonts.vt323(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${partnerPresence?.emoji ?? "🏠"} ${partnerPresence?.status ?? "AT HOME · MISSING YOU"}'.toUpperCase(),
                                        style: GoogleFonts.vt323(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(color: Colors.black, width: 2),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.battery_charging_full,
                                                  color: Colors.black,
                                                  size: 14,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${partnerPresence?.battery is Map ? partnerPresence?.battery['level'] : partnerPresence?.battery ?? "0"}%',
                                                  style: GoogleFonts.vt323(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(color: Colors.black, width: 2),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.do_not_disturb_on,
                                                  color: Colors.black,
                                                  size: 14,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  partnerPresence?.isDnd == true
                                                      ? 'DND ON'
                                                      : 'DND OFF',
                                                  style: GoogleFonts.vt323(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
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
                
                // "Press to Update Status" hint
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'TAP CARD TO UPDATE ^',
                      style: GoogleFonts.vt323(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

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
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 4),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(6, 6),
                          blurRadius: 0,
                        ),
                      ],
                    ),
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
                                      width: 40,
                                      height: 40,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF1493),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 3,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black,
                                              offset: Offset(2, 2),
                                            )
                                          ]
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.favorite,
                                            color: Colors.white,
                                            size: 20,
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
                                  Colors.black.withOpacity(0.6),
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
                                      'PARTNER\'S';
                                  return Text(
                                    "${partnerName.toUpperCase()} LOCATION",
                                    style: GoogleFonts.vt323(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 2,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'LIVE SHARING ...',
                                style: GoogleFonts.vt323(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // ── Relationship chips ──────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 3),
                          boxShadow: const [
                            BoxShadow(color: Colors.black, offset: Offset(3, 3))
                          ]
                        ),
                        child: Text(
                          '🗓️ DAY ${daysTogether > 0 ? daysTogether : 1}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.vt323(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 3),
                          boxShadow: const [
                            BoxShadow(color: Colors.black, offset: Offset(3, 3))
                          ]
                        ),
                        child: Text(
                          '✅ $tasksCount TASKS',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.vt323(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

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
