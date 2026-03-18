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
      child: Container(
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
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (item.isEncrypted)
              Container(
                color: const Color(0xFFFF1493),
                child: const Center(
                  child: Icon(
                    Icons.lock,
                    size: 48,
                    color: Colors.white,
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.black, width: 4),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        (item.customTag ?? 'MEMORY').toUpperCase(),
                        style: GoogleFonts.vt323(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (item.created != null)
                      Text(
                        '${item.created!.month}/${item.created!.day}',
                        style: GoogleFonts.vt323(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
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
