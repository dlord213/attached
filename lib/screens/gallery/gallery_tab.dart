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

  final _categories = ['All', 'Dates', 'Travel', 'Home', 'Selfies'];

  void _showAddDialog() {
    final tagCtrl = TextEditingController();
    bool isEncrypted = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateSB) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFFF0F5),
            title: Text(
              'Add Memory',
              style: GoogleFonts.gabarito(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFD6006A),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: tagCtrl,
                  decoration: InputDecoration(
                    hintText: 'Custom Tag (e.g. Travel)',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.lock_rounded, color: Color(0xFF8B4263)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Encrypt (requires locking)',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF8B4263),
                        ),
                      ),
                    ),
                    Switch(
                      value: isEncrypted,
                      activeColor: const Color(0xFFFF4081),
                      onChanged: (val) => setStateSB(() => isEncrypted = val),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.nunito(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4081),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onPressed: () {
                  ref
                      .read(galleryProvider.notifier)
                      .addGalleryItem(
                        customTag: tagCtrl.text.trim(),
                        isEncrypted: isEncrypted,
                      );
                  Navigator.pop(ctx);
                },
                child: Text(
                  'Pick Image',
                  style: GoogleFonts.nunito(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final galleryState = ref.watch(galleryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      body: Stack(
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 240,
              height: 240,
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
                            'Our Gallery',
                            style: GoogleFonts.gabarito(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFD6006A),
                              letterSpacing: -0.5,
                              height: 1.1,
                            ),
                          ),
                          galleryState.when(
                            data: (items) => Text(
                              items.length == 0
                                  ? "No memories yet."
                                  : '${items.length} memories together',
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF8B4263),
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

                const SizedBox(height: 12),

                // ── Category filter chips ─────────────────────────
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final selected = i == _selectedCategory;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            gradient: selected
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFFF6B9D),
                                      Color(0xFFFF4081),
                                    ],
                                  )
                                : null,
                            color: selected ? null : Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: selected
                                  ? Colors.transparent
                                  : const Color(0xFFFFD6E7),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _categories[i],
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFF8B4263),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // ── Photo grid ────────────────────────────────────
                Expanded(
                  child: galleryState.when(
                    data: (items) {
                      // Filter by category if needed
                      final categoryText = _categories[_selectedCategory];
                      final filtered = categoryText == 'All'
                          ? items
                          : items
                                .where(
                                  (it) =>
                                      it.customTag == categoryText ||
                                      (it.customTag != null &&
                                          categoryText.contains(it.customTag!)),
                                )
                                .toList();

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
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
                                      'Please authenticate to view this memory',
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
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF4081),
                      ),
                    ),
                    error: (e, st) => Center(
                      child: Text(
                        'Error loading gallery: \$e',
                        style: GoogleFonts.nunito(
                          color: const Color(0xFFD6006A),
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
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B9D), Color(0xFFFF4081)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF4081).withOpacity(0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: _showAddDialog,
                  child: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Icon(
                      Icons.add_photo_alternate_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
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
