import 'package:attached/models/gallery_record.dart';
import 'package:attached/services/api.service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MemoryCard extends StatelessWidget {
  final GalleryRecord item;
  final VoidCallback onTap;
  const MemoryCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.image != null && item.image!.isNotEmpty
        ? '${apiService.pb.baseURL}/api/files/${item.collectionId}/${item.id}/${item.image}'
        : null;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (item.isEncrypted)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF3D0020), const Color(0xFF1E0010)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock_rounded,
                    size: 52,
                    color: Colors.white54,
                  ),
                ),
              )
            else if (imageUrl != null)
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (ctx, _, __) =>
                    Container(color: Colors.grey[300]),
              )
            else
              Container(color: Colors.grey[200]),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.38),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.customTag ?? 'Memory',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (item.created != null)
                      Text(
                        '${item.created!.month}/${item.created!.day}',
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
