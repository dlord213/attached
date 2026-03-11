import 'package:attached/models/curated_lists_record.dart';
import 'package:attached/services/curated_lists.provider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SharedCuratedListScreen extends ConsumerStatefulWidget {
  const SharedCuratedListScreen({super.key});

  @override
  ConsumerState<SharedCuratedListScreen> createState() =>
      _SharedCuratedListScreenState();
}

class _SharedCuratedListScreenState
    extends ConsumerState<SharedCuratedListScreen> {
  final List<String> categories = [
    'movie',
    'anime',
    'tv',
    'book',
    'game',
    'album',
  ];
  String selectedCategory = 'movie';

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _AddCuratedItemSheet(initialCategory: selectedCategory),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listsAsync = ref.watch(curatedListsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFFD6006A),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Curated Lists',
          style: GoogleFonts.gabarito(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFD6006A),
          ),
        ),
      ),
      body: Column(
        children: [
          // Sub-tabs
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = cat == selectedCategory;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = cat;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFD6006A)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFD6006A)
                            : const Color(0xFFFFD6E7),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        cat.toUpperCase(),
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected
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
          // List
          Expanded(
            child: listsAsync.when(
              data: (items) {
                final filtered = items
                    .where(
                      (item) => item.category?.nameInSchema == selectedCategory,
                    )
                    .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: 64,
                          color: Color(0xFFFFB3CF),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No items in ${selectedCategory.capitalize} yet',
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            color: const Color(0xFF8B4263),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return _CuratedItemCard(item: item);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, stack) => Center(child: Text('Error: \$e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context),
        backgroundColor: const Color(0xFFD6006A),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }
}

class _CuratedItemCard extends ConsumerWidget {
  final CuratedListsRecord item;

  const _CuratedItemCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFD6E7), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B9D).withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title ?? 'Unknown',
                  style: GoogleFonts.gabarito(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFD6006A),
                  ),
                ),
                if (item.author != null && item.author!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.author!,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: const Color(0xFF8B4263),
                    ),
                  ),
                ],
                if (item.body != null && item.body!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    item.body!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: item.status?.nameInSchema == 'completed'
                        ? Colors.green.withOpacity(0.1)
                        : const Color(0xFFFFE4EF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.status?.nameInSchema ?? 'to-do',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: item.status?.nameInSchema == 'completed'
                          ? Colors.green
                          : const Color(0xFFD6006A),
                    ),
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onSelected: (value) {
              if (value == 'delete') {
                ref.read(curatedListsProvider.notifier).deleteItem(item.id);
              } else if (value == 'completed') {
                ref
                    .read(curatedListsProvider.notifier)
                    .updateItemStatus(item.id, 'completed');
              } else if (value == 'to-do') {
                ref
                    .read(curatedListsProvider.notifier)
                    .updateItemStatus(item.id, 'to-do');
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'completed',
                child: Text('Mark completed'),
              ),
              const PopupMenuItem<String>(
                value: 'to-do',
                child: Text('Mark to-do'),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddCuratedItemSheet extends ConsumerStatefulWidget {
  final String initialCategory;

  const _AddCuratedItemSheet({required this.initialCategory});

  @override
  ConsumerState<_AddCuratedItemSheet> createState() =>
      _AddCuratedItemSheetState();
}

class _AddCuratedItemSheetState extends ConsumerState<_AddCuratedItemSheet> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add to \${widget.initialCategory}',
              style: GoogleFonts.gabarito(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD6006A),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: 'Author / Director / Studio',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final title = _titleController.text.trim();
                  if (title.isNotEmpty) {
                    await ref
                        .read(curatedListsProvider.notifier)
                        .addListItem(
                          title: title,
                          category: widget.initialCategory,
                          author: _authorController.text.trim(),
                          body: _bodyController.text.trim(),
                        );
                  }
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD6006A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Add Item',
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
