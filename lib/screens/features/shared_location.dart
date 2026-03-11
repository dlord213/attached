import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:attached/services/connection.provider.dart';

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
      backgroundColor: const Color(0xFFFFF0F5),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFD6006A)),
        title: Text(
          'Shared Location',
          style: GoogleFonts.gabarito(
            color: const Color(0xFFD6006A),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation ?? _partnerLocation,
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFD6006A),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person_rounded,
                            color: Color(0xFFD6006A),
                            size: 24,
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
                        shape: BoxShape.circle,
                        color: const Color(0xFFFF6B9D),
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6B9D).withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.favorite_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (_currentLocation == null)
            Container(
              color: Colors.white.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFFD6006A)),
              ),
            ),
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD6006A).withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const HugeIcon(
                      icon: HugeIcons.strokeRoundedLocation01,
                      color: Color(0xFFD6006A),
                      size: 24,
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
                                'Partner\'s';
                            return Text(
                              "$partnerName Location",
                              style: GoogleFonts.gabarito(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2D3142),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Updated just now',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: const Color(0xFF9094A6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _mapController.move(_partnerLocation, 15.0);
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B9D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(12),
                    ),
                    icon: const Icon(
                      Icons.navigation_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 140,
            right: 24,
            child: FloatingActionButton(
              heroTag: 'myLocationBtn',
              onPressed: () {
                if (_currentLocation != null) {
                  _mapController.move(_currentLocation!, 15.0);
                } else {
                  _determinePosition();
                }
              },
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFFD6006A),
              elevation: 4,
              child: const Icon(
                Icons.my_location_rounded,
                color: Color(0xFFD6006A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
