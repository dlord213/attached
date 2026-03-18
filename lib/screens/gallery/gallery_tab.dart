import 'package:attached/screens/gallery/widgets/memory_card.dart';
import 'package:attached/services/gallery.provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';

class GalleryTab extends ConsumerStatefulWidget {
  const GalleryTab({super.key});

  @override
  ConsumerState<GalleryTab> createState() => _GalleryTabState();
}

class _GalleryTabState extends ConsumerState<GalleryTab> {
  int _selectedCategory = 0;
  final LocalAuthentication _auth = LocalAuthentication();

  final _categories = ['ALL', 'DATES', 'TRAVEL', 'HOME', 'SELFIES'];

  void _showAddDialog() {
    final tagCtrl = TextEditingController();
    bool isEncrypted = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateSB) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFB6C1),
                border: Border.all(color: Colors.black, width: 4),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(0, -8)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Drag handle ─────────────────────────────────
                  const SizedBox(height: 12),
                  Container(width: 40, height: 6, color: Colors.black),
                  const SizedBox(height: 24),

                  // ── Icon + title ────────────────────────
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF1493),
                      border: Border.all(color: Colors.black, width: 4),
                      boxShadow: const [
                        BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_photo_alternate_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ADD A MEMORY',
                    style: GoogleFonts.vt323(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'TAG IT AND MAKE IT YOURS.',
                    style: GoogleFonts.vt323(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Body ─────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch, // start to stretch
                      children: [
                        // Tag label
                        Text(
                          'MEMORY TAG:',
                          style: GoogleFonts.vt323(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Tag text field
                        Container(
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
                          child: TextField(
                            controller: tagCtrl,
                            style: GoogleFonts.vt323(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: 'e.g. TRAVEL',
                              hintStyle: GoogleFonts.vt323(
                                color: Colors.black38,
                                fontSize: 24,
                              ),
                              prefixIcon: const Icon(
                                Icons.label,
                                color: Colors.black,
                                size: 24,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Encrypt toggle card
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: isEncrypted
                                ? const Color(0xFFFF1493)
                                : Colors.white,
                            border: Border.all(color: Colors.black, width: 4),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(4, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  isEncrypted ? Icons.lock : Icons.lock_open,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ENCRYPT MEMORY',
                                      style: GoogleFonts.vt323(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                        color: isEncrypted
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    Text(
                                      'REQUIRES BIOMETRIC UNLOCK',
                                      style: GoogleFonts.vt323(
                                        fontSize: 16,
                                        color: isEncrypted
                                            ? Colors.white
                                            : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: isEncrypted,
                                activeColor: Colors.white,
                                activeTrackColor: Colors.black,
                                inactiveThumbColor: Colors.black,
                                inactiveTrackColor: Colors.white,
                                onChanged: (val) =>
                                    setStateSB(() => isEncrypted = val),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Action buttons
                        Row(
                          children: [
                            // Cancel
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Navigator.pop(ctx),
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 4,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(4, 4),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'CANCEL',
                                    style: GoogleFonts.vt323(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Pick Image
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  ref
                                      .read(galleryProvider.notifier)
                                      .addGalleryItem(
                                        customTag: tagCtrl.text.trim(),
                                        isEncrypted: isEncrypted,
                                      );
                                  Navigator.pop(ctx);
                                },
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF1493),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 4,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(4, 4),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.image,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'PICK IMAGE',
                                        style: GoogleFonts.vt323(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 28,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final galleryState = ref.watch(galleryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFC0CB),
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _PixelGridPainter())),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'OUR GALLERY',
                            style: GoogleFonts.vt323(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFF1493),
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          galleryState.when(
                            data: (items) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(3, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                items.isEmpty
                                    ? "NO MEMORIES YET."
                                    : '${items.length} MEMORIES UNLOCKED',
                                style: GoogleFonts.vt323(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            loading: () => const SizedBox(),
                            error: (_, __) => const SizedBox(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Category filter chips ─────────────────────────
                SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) {
                      final selected = i == _selectedCategory;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = i),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFFF1493)
                                : Colors.white,
                            border: Border.all(color: Colors.black, width: 3),
                            boxShadow: selected
                                ? null
                                : const [
                                    BoxShadow(
                                      color: Colors.black,
                                      offset: Offset(3, 3),
                                    ),
                                  ],
                          ),
                          child: Center(
                            child: Text(
                              _categories[i],
                              style: GoogleFonts.vt323(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: selected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // ── Photo grid ────────────────────────────────────
                Expanded(
                  child: galleryState.when(
                    data: (items) {
                      // Filter by category if needed
                      final categoryText = _categories[_selectedCategory];
                      final filtered = categoryText == 'ALL'
                          ? items
                          : items
                                .where(
                                  (it) =>
                                      it.customTag?.toUpperCase() ==
                                          categoryText.toUpperCase() ||
                                      (it.customTag != null &&
                                          it.customTag!.toUpperCase().contains(
                                            categoryText.toUpperCase(),
                                          )),
                                )
                                .toList();

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.82,
                            ),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final item = filtered[i];
                          return MemoryCard(
                            item: item,
                            onTap: () async {
                              if (item.isEncrypted) {
                                final bool
                                didAuthenticate = await _auth.authenticate(
                                  localizedReason:
                                      'PLEASE AUTHENTICATE TO VIEW THIS MEMORY',
                                  biometricOnly: false,
                                );
                                if (didAuthenticate) {
                                  // Open enlarged photo dialog or screen
                                }
                              } else {
                                // Open enlarged photo dialog or screen
                              }
                            },
                          );
                        },
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                    error: (e, st) => Center(
                      child: Text(
                        'ERROR LOADING GALLERY',
                        style: GoogleFonts.vt323(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Floating add button ────────────────────────────────
          Positioned(
            bottom: 24,
            right: 24,
            child: GestureDetector(
              onTap: _showAddDialog,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF1493),
                  border: Border.all(color: Colors.black, width: 4),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.add_photo_alternate,
                    color: Colors.white,
                    size: 32,
                  ),
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
