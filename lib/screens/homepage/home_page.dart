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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Tasks",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color(0xff3c096c),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: controller.updateSearchQuery,
                    decoration: InputDecoration(
                      hintText: 'Search tasks...',
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
                const SizedBox(width: 10),
                Obx(() => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: DropdownButton<TaskStatus?>(
                        value: controller.filterStatus.value,
                        underline: const SizedBox(),
                        iconEnabledColor: const Color(0xff3c096c),
                        hint: const Text("All"),
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
      body: Obx(() {
        if (controller.tasks.isEmpty) {
          return const Center(
            child: Text(
              "No tasks yet. Add some!",
              style: TextStyle(fontFamily: 'Poppins', color: Colors.grey, fontSize: 18),
            ),
          );
        }

        final filtered = controller.filteredTasks;
        if (filtered.isEmpty) {
          return const Center(
            child: Text(
              "No tasks match your search.",
              style: TextStyle(fontFamily: 'Poppins', color: Colors.grey, fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final task = filtered[index];
            final isBlocked = controller.isTaskBlocked(task);

            return Opacity(
              opacity: isBlocked ? 0.4 : 1.0,
              child: GestureDetector(
                onTap: isBlocked ? null : () => _showTaskForm(task: task),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _buildHighlightedTitle(task.title, controller.searchQuery.value),
                            ),
                            _buildStatusBadge(task.status),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 5),
                            Text(
                              DateFormat('MMM dd, yyyy - hh:mm a').format(task.dueDate),
                              style: TextStyle(fontFamily: 'Poppins', color: Colors.grey[600], fontSize: 12),
                            ),
                            const Spacer(),
                            if (isBlocked)
                              const Row(
                                children: [
                                  Icon(Icons.lock, size: 16, color: Colors.redAccent),
                                  SizedBox(width: 5),
                                  Text(
                                    "Blocked",
                                    style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0, duration: 400.ms),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff3c096c),
        onPressed: () => _showTaskForm(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildStatusBadge(TaskStatus status) {
    Color color;
    switch (status) {
      case TaskStatus.todo:
        color = Colors.orange;
        break;
      case TaskStatus.inProgress:
        color = Colors.blue;
        break;
      case TaskStatus.done:
        color = Colors.green;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(51), // equivalent to opacity 0.2
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
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
          fontWeight: FontWeight.bold,
          color: Color(0xff3c096c),
        ),
      );
    }

    final queryLower = query.toLowerCase();
    final titleLower = title.toLowerCase();
    
    // Find all matches
    List<TextSpan> spans = [];
    int start = 0;
    
    int indexOfMatch = titleLower.indexOf(queryLower, start);
    if (indexOfMatch == -1) {
      return Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xff3c096c),
        ),
      );
    }

    while (indexOfMatch != -1) {
      if (indexOfMatch > start) {
        spans.add(TextSpan(text: title.substring(start, indexOfMatch)));
      }
      
      spans.add(TextSpan(
        text: title.substring(indexOfMatch, indexOfMatch + query.length),
        style: const TextStyle(backgroundColor: Colors.yellow, color: Colors.black),
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
          fontWeight: FontWeight.bold,
          color: Color(0xff3c096c),
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
