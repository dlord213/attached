import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:attached/services/connection.provider.dart';
import 'package:attached/services/auth.provider.dart';
import 'package:attached/services/presence.service.dart';

class SharedLocationScreen extends ConsumerStatefulWidget {
  const SharedLocationScreen({super.key});

  @override
  ConsumerState<SharedLocationScreen> createState() =>
      _SharedLocationScreenState();
}

class _SharedLocationScreenState extends ConsumerState<SharedLocationScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  final LatLng _partnerLocation = const LatLng(51.509865, -0.118092);

  @override
  void initState() {
    super.initState();
    _determinePosition();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = ref.read(authProvider);
      final connection = ref.read(connectionProvider);
      if (auth != null && connection != null) {
        ref.read(presenceProvider).updateLocation(auth.id, connection.id, context);
      }
    });
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_currentLocation!, 13.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectionNotifier = ref.read(connectionProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFFFC0CB),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'RADAR',
          style: GoogleFonts.vt323(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _PixelGridPainter())),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 4),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                  ],
                ),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentLocation ?? _partnerLocation,
                    initialZoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.attached.app',
                    ),
                    MarkerLayer(
                      markers: [
                        if (_currentLocation != null)
                          Marker(
                            point: _currentLocation!,
                            width: 50,
                            height: 50,
                            child: Container(
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
                              child: const Center(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        Marker(
                          point: _partnerLocation,
                          width: 60,
                          height: 60,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF1493),
                              border: Border.all(color: Colors.black, width: 3),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 32,
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
          ),
          if (_currentLocation == null)
            Container(
              color: Colors.white.withOpacity(0.8),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.black),
              ),
            ),
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 4),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB6C1),
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Builder(
                          builder: (context) {
                            final partnerName =
                                connectionNotifier.partnerData?.name ??
                                'PARTNER';
                            return Text(
                              "${partnerName.toUpperCase()}'S LOCATION",
                              style: GoogleFonts.vt323(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'UPDATED JUST NOW',
                          style: GoogleFonts.vt323(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _mapController.move(_partnerLocation, 15.0);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF1493),
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(2, 2)),
                        ],
                      ),
                      child: const Icon(
                        Icons.navigation,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 100,
            right: 40,
            child: GestureDetector(
              onTap: () {
                if (_currentLocation != null) {
                  _mapController.move(_currentLocation!, 15.0);
                } else {
                  _determinePosition();
                }
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 3),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(3, 3)),
                  ],
                ),
                child: const Icon(
                  Icons.my_location,
                  color: Colors.black,
                  size: 28,
                ),
              ),
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
