import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_storage/get_storage.dart';
import '../../controllers/task_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../models/task_model.dart';
import '../../widgets/profile_bottom_sheet.dart';
import 'task_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController controller = Get.put(TaskController());
  final ThemeController themeController = Get.find<ThemeController>();

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

  bool get isDark => themeController.isDarkMode.value;
  Color get bgColor => isDark ? const Color(0xff121212) : const Color(0xffF8F9FA);
  Color get cardColor => isDark ? const Color(0xff1E1E1E) : Colors.white;
  Color get textColor => isDark ? Colors.white : const Color(0xff2A0A4A);
  Color get subTextColor => isDark ? Colors.grey[400]! : Colors.grey[600]!;
  Color get shadowColor => isDark ? Colors.black87 : Colors.black.withOpacity(0.06);
  Color get gradientStart => isDark ? const Color(0xff120324) : const Color(0xff3c096c);
  Color get gradientEnd => isDark ? const Color(0xff2a0a4a) : const Color(0xff7b2cbf);
  Color get bgGradientEnd => isDark ? const Color(0xff2a0a4a).withOpacity(0.5) : const Color(0xffE0AAFF).withOpacity(0.15);
  Color get inputBgColor => isDark ? const Color(0xff2A2A2A) : Colors.white;

  void _showProfileBottomSheet(BuildContext context) {
    Get.bottomSheet(
      const ProfileBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [gradientStart, gradientEnd],
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => _showProfileBottomSheet(context),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white24,
                backgroundImage: AssetImage('assets/images/${GetStorage().read('avatar') ?? 'boy'}.png'),
              ),
            ),
          )
        ],
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
                          color: shadowColor,
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: controller.updateSearchQuery,
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: textColor),
                      decoration: InputDecoration(
                        hintText: 'Search tasks...',
                        hintStyle: TextStyle(color: subTextColor),
                        filled: true,
                        fillColor: inputBgColor,
                        prefixIcon: Icon(Icons.search, color: isDark ? Colors.white70 : const Color(0xff3c096c)),
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
                Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      decoration: BoxDecoration(
                        color: inputBgColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: shadowColor,
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: DropdownButton<TaskStatus?>(
                        value: controller.filterStatus.value,
                        underline: const SizedBox(),
                        iconEnabledColor: isDark ? Colors.white70 : const Color(0xff3c096c),
                        dropdownColor: cardColor,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: isDark ? Colors.white : const Color(0xff3c096c),
                          fontWeight: FontWeight.bold,
                        ),
                        hint: Text("All", style: TextStyle(fontFamily: 'Poppins', color: textColor)),
                        items: [
                          DropdownMenuItem(value: null, child: Text("All", style: TextStyle(color: textColor))),
                          ...TaskStatus.values.map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s.name.toUpperCase(), style: TextStyle(color: textColor)),
                              ))
                        ],
                        onChanged: controller.updateFilterStatus,
                      ),
                    ),
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
            colors: [bgColor, bgGradientEnd],
          )
        ),
        child: controller.tasks.isEmpty ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_rounded, size: 60, color: isDark ? Colors.grey[800] : Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "No tasks yet. Add some!",
                    style: TextStyle(fontFamily: 'Poppins', color: subTextColor, fontSize: 18),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms).scaleXY(begin: 0.8, end: 1.0, duration: 600.ms, curve: Curves.easeOutBack),
            ) : (() {
          final filtered = controller.filteredTasks;
          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_rounded, size: 60, color: isDark ? Colors.grey[800] : Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "No tasks match your search.",
                    style: TextStyle(fontFamily: 'Poppins', color: subTextColor, fontSize: 18),
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
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
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
                        onLongPress: () => _showTaskActionSheet(task),
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
                                          if (task.isPinned)
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0, top: 4.0),
                                              child: Icon(Icons.push_pin_rounded, size: 16, color: gradientEnd),
                                            ),
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
                                          color: subTextColor,
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today_rounded, size: 14, color: subTextColor),
                                          const SizedBox(width: 6),
                                          Text(
                                            DateFormat('MMM dd, yyyy - hh:mm a').format(task.dueDate),
                                            style: TextStyle(
                                              fontFamily: 'Poppins', 
                                              color: subTextColor, 
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
                 .shimmer(delay: (index * 80 + 300).ms, duration: 1200.ms, color: Colors.white.withOpacity(0.15)),
              );
            },
          );
        })(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: gradientEnd,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => _showTaskForm(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ).animate().scale(delay: 600.ms, duration: 500.ms, curve: Curves.easeOutBack),
    ));
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
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textColor,
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
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textColor,
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
          color: isDark ? Colors.white : const Color(0xff3c096c),
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
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textColor,
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

  void _showTaskActionSheet(Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Task Options",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(
                task.isPinned ? Icons.push_pin_outlined : Icons.push_pin_rounded, 
                color: gradientEnd
              ),
              title: Text(
                task.isPinned ? "Unpin Task" : "Pin Task",
                style: TextStyle(fontFamily: 'Poppins', color: textColor, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Get.back();
                controller.togglePinTask(task.id);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
              title: const Text(
                "Delete Task",
                style: TextStyle(fontFamily: 'Poppins', color: Colors.redAccent, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Get.back();
                _showDeleteConfirmation(task.id);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showDeleteConfirmation(String id) {
    Get.dialog(
      AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Delete Task", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: textColor)),
        content: Text("Are you sure you want to delete this task? This action cannot be undone.", 
          style: TextStyle(fontFamily: 'Poppins', color: subTextColor)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel", style: TextStyle(fontFamily: 'Poppins', color: subTextColor, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              controller.deleteTask(id);
              Get.back();
            },
            child: const Text("Delete", style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
