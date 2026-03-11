import 'package:attached/models/shared_item_record.dart';
import 'package:attached/screens/home/sheets/add_task_sheet.dart';
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
              .addTask(title, customTag: tag.isEmpty ? 'Together' : tag);
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
      backgroundColor: const Color(0xFFFFF0F5),
      body: SafeArea(
        child: tasksState.when(
          data: (tasks) {
            final pending = tasks
                .where((t) => t.status != SharedItemRecordStatusEnum.completed)
                .length;
            final done = tasks
                .where((t) => t.status == SharedItemRecordStatusEnum.completed)
                .length;
            final progress = tasks.isEmpty ? 0.0 : done / tasks.length;

            return Stack(
              children: [
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
                            'Shared Tasks',
                            style: GoogleFonts.gabarito(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFD6006A),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$pending left to do · $done done',
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF8B4263),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Progress bar ─────────────────────────────────
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 24),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text(
                    //             'Progress',
                    //             style: GoogleFonts.nunito(
                    //               fontSize: 13,
                    //               fontWeight: FontWeight.w700,
                    //               color: const Color(0xFF8B4263),
                    //             ),
                    //           ),
                    //           Text(
                    //             '${(progress * 100).round()}%',
                    //             style: GoogleFonts.nunito(
                    //               fontSize: 13,
                    //               fontWeight: FontWeight.w800,
                    //               color: const Color(0xFFD6006A),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       const SizedBox(height: 8),
                    //       ClipRRect(
                    //         borderRadius: BorderRadius.circular(100),
                    //         child: LinearProgressIndicator(
                    //           value: progress,
                    //           minHeight: 8,
                    //           backgroundColor: const Color(0xFFFFD6E7),
                    //           valueColor: const AlwaysStoppedAnimation<Color>(
                    //             Color(0xFFFF4081),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // const SizedBox(height: 24),

                    // ── Task list ─────────────────────────────────────
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 80),
                        itemCount: tasks.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
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
                  bottom: 20,
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
                        onTap: _showAddSheet,
                        child: const Padding(
                          padding: EdgeInsets.all(14),
                          child: Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF4081)),
          ),
          error: (e, st) => Center(
            child: Text(
              'Error loading tasks',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFD6006A),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
