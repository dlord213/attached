import 'package:attached/models/shared_item_record.dart';
import 'package:attached/screens/tasks/sheets/add_task_sheet.dart';
import 'package:attached/screens/home/widgets/task_tile.dart';
import 'package:attached/services/tasks.provider.dart';
import 'package:attached/services/api.service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TasksTab extends ConsumerStatefulWidget {
  const TasksTab({super.key});

  @override
  ConsumerState<TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends ConsumerState<TasksTab> {
  final _addController = TextEditingController();
  final _tagController = TextEditingController();

  void _toggleTask(SharedItemRecord task) {
    ref
        .read(tasksProvider.notifier)
        .toggleTask(
          task.id,
          task.status == SharedItemRecordStatusEnum.completed,
        );
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTaskSheet(
        controller: _addController,
        tagController: _tagController,
        onAdd: (title, tag) {
          if (title.isEmpty) return;
          ref
              .read(tasksProvider.notifier)
              .addTask(title, customTag: tag.isEmpty ? 'QUEST' : tag.toUpperCase());
          _addController.clear();
          _tagController.clear();
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasksState = ref.watch(tasksProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFC0CB),
      body: SafeArea(
        child: tasksState.when(
          data: (tasks) {
            final pending = tasks
                .where((t) => t.status != SharedItemRecordStatusEnum.completed)
                .length;
            final done = tasks
                .where((t) => t.status == SharedItemRecordStatusEnum.completed)
                .length;

            return Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _PixelGridPainter(),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ──────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'QUEST LOG',
                            style: GoogleFonts.vt323(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFF1493),
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black, width: 3),
                              boxShadow: const [
                                BoxShadow(color: Colors.black, offset: Offset(3, 3))
                              ]
                            ),
                            child: Text(
                              '$pending LEFT TO DO · $done DONE',
                              style: GoogleFonts.vt323(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Task list ─────────────────────────────────────
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 80),
                        itemCount: tasks.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
                        itemBuilder: (_, i) => TaskTile(
                          task: tasks[i],
                          currentUserId: apiService.pb.authStore.record?.id,
                          onToggle: () => _toggleTask(tasks[i]),
                        ),
                      ),
                    ),
                  ],
                ),

                // ── FAB ───────────────────────────────────────────────
                Positioned(
                  bottom: 24,
                  right: 24,
                  child: GestureDetector(
                    onTap: _showAddSheet,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF1493),
                        border: Border.all(color: Colors.black, width: 4),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(4, 4),
                          )
                        ]
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.black),
          ),
          error: (e, st) => Center(
            child: Text(
              'ERROR LOADING QUESTS',
              style: GoogleFonts.vt323(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ),
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
