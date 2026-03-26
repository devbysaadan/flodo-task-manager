import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/task_controller.dart';
import '../../models/task_model.dart';
import 'task_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController controller = Get.put(TaskController());

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return Colors.orange;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.done:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff3c096c), Color(0xff7b2cbf)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "Tasks",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 24,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: controller.updateSearchQuery,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search tasks...',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.search, color: Color(0xff3c096c)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Obx(() => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: DropdownButton<TaskStatus?>(
                        value: controller.filterStatus.value,
                        underline: const SizedBox(),
                        iconEnabledColor: const Color(0xff3c096c),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xff3c096c),
                          fontWeight: FontWeight.bold,
                        ),
                        hint: const Text("All", style: TextStyle(fontFamily: 'Poppins')),
                        items: [
                          const DropdownMenuItem(value: null, child: Text("All")),
                          ...TaskStatus.values.map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s.name.toUpperCase()),
                              ))
                        ],
                        onChanged: controller.updateFilterStatus,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xffF8F9FA), const Color(0xffE0AAFF).withOpacity(0.15)],
          )
        ),
        child: Obx(() {
          if (controller.tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_rounded, size: 60, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text(
                    "No tasks yet. Add some!",
                    style: TextStyle(fontFamily: 'Poppins', color: Colors.grey, fontSize: 18),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms).scaleXY(begin: 0.8, end: 1.0, duration: 600.ms, curve: Curves.easeOutBack),
            );
          }

          final filtered = controller.filteredTasks;
          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_rounded, size: 60, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text(
                    "No tasks match your search.",
                    style: TextStyle(fontFamily: 'Poppins', color: Colors.grey, fontSize: 18),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final task = filtered[index];
              final isBlocked = controller.isTaskBlocked(task);
              final statusColor = _getStatusColor(task.status);

              return Opacity(
                opacity: isBlocked ? 0.6 : 1.0,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isBlocked ? null : () => _showTaskForm(task: task),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                width: 6,
                                color: statusColor,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: _buildHighlightedTitle(task.title, controller.searchQuery.value),
                                          ),
                                          const SizedBox(width: 12),
                                          _buildStatusBadge(task.status),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        task.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.grey[600],
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today_rounded, size: 14, color: Colors.grey[400]),
                                          const SizedBox(width: 6),
                                          Text(
                                            DateFormat('MMM dd, yyyy - hh:mm a').format(task.dueDate),
                                            style: TextStyle(
                                              fontFamily: 'Poppins', 
                                              color: Colors.grey[500], 
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const Spacer(),
                                          if (isBlocked)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: const Row(
                                                children: [
                                                  Icon(Icons.lock_rounded, size: 12, color: Colors.redAccent),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    "Blocked",
                                                    style: TextStyle(
                                                      color: Colors.redAccent, 
                                                      fontSize: 11, 
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Poppins',
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                 .animate(delay: (index * 80).ms)
                 .fadeIn(duration: 500.ms)
                 .slideY(begin: 0.2, end: 0, duration: 500.ms, curve: Curves.easeOutQuart)
                 .shimmer(delay: (index * 80 + 300).ms, duration: 1200.ms, color: Colors.white.withOpacity(0.5)),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff3c096c),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => _showTaskForm(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ).animate().scale(delay: 600.ms, duration: 500.ms, curve: Curves.easeOutBack),
    );
  }

  Widget _buildStatusBadge(TaskStatus status) {
    Color color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildHighlightedTitle(String title, String query) {
    if (query.isEmpty) {
      return Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xff2A0A4A),
        ),
      );
    }

    final queryLower = query.toLowerCase();
    final titleLower = title.toLowerCase();
    
    List<TextSpan> spans = [];
    int start = 0;
    
    int indexOfMatch = titleLower.indexOf(queryLower, start);
    if (indexOfMatch == -1) {
      return Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xff2A0A4A),
        ),
      );
    }

    while (indexOfMatch != -1) {
      if (indexOfMatch > start) {
        spans.add(TextSpan(text: title.substring(start, indexOfMatch)));
      }
      
      spans.add(TextSpan(
        text: title.substring(indexOfMatch, indexOfMatch + query.length),
        style: TextStyle(
          backgroundColor: const Color(0xffE0AAFF).withOpacity(0.5), 
          color: const Color(0xff3c096c),
        ),
      ));
      
      start = indexOfMatch + query.length;
      indexOfMatch = titleLower.indexOf(queryLower, start);
    }
    
    if (start < title.length) {
      spans.add(TextSpan(text: title.substring(start)));
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xff2A0A4A),
        ),
        children: spans,
      ),
    );
  }

  void _showTaskForm({Task? task}) {
    Get.bottomSheet(
      TaskFormModal(task: task),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
