import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../controllers/task_controller.dart';
import '../../models/task_model.dart';

class TaskFormModal extends StatefulWidget {
  final Task? task;
  const TaskFormModal({super.key, this.task});

  @override
  State<TaskFormModal> createState() => _TaskFormModalState();
}

class _TaskFormModalState extends State<TaskFormModal> {
  final controller = Get.find<TaskController>();
  final box = GetStorage();

  late TextEditingController titleController;
  late TextEditingController descController;
  DateTime selectedDate = DateTime.now();
  TaskStatus selectedStatus = TaskStatus.todo;
  String? blockedById;

  @override
  void initState() {
    super.initState();
    // Restore Drafts if creating new, else use task data
    titleController = TextEditingController(text: widget.task?.title ?? box.read('draft_title') ?? "");
    descController = TextEditingController(text: widget.task?.description ?? box.read('draft_desc') ?? "");
    if (widget.task != null) {
      selectedDate = widget.task!.dueDate;
      selectedStatus = widget.task!.status;
      blockedById = widget.task!.blockedBy;
    }
  }

  void _saveDrafts() {
    if (widget.task == null) {
      controller.saveDraft(titleController.text, descController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only show tasks that are not the current task and not done (optional, but logical for blockedBy)
    final availableBlockers = controller.tasks.where((t) => t.id != widget.task?.id).toList();

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.task == null ? "New Task" : "Edit Task",
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xff3c096c))),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                onChanged: (_) => _saveDrafts(),
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: descController,
                onChanged: (_) => _saveDrafts(),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: InputDecoration(labelText: "Status", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<TaskStatus>(
                          value: selectedStatus,
                          items: TaskStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.name.toUpperCase()))).toList(),
                          onChanged: (val) => setState(() => selectedStatus = val!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              if (availableBlockers.isNotEmpty)
                InputDecorator(
                  decoration: InputDecoration(labelText: "Blocked By", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: blockedById,
                      items: [
                        const DropdownMenuItem(value: null, child: Text("None")),
                        ...availableBlockers.map((t) => DropdownMenuItem(value: t.id, child: Text(t.title)))
                      ],
                      onChanged: (val) => setState(() => blockedById = val),
                    ),
                  ),
                ),
              if (availableBlockers.isNotEmpty) const SizedBox(height: 20),
              
              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.task != null)
                    IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: controller.isLoading.value ? null : () {
                          controller.deleteTask(widget.task!.id);
                          Get.back();
                        }
                    )
                  else
                    const SizedBox.shrink(),

                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff3c096c), shape: const StadiumBorder()),
                      onPressed: controller.isLoading.value ? null : () {
                        if (titleController.text.trim().isEmpty) {
                          Get.snackbar("Error", "Title cannot be empty", snackPosition: SnackPosition.BOTTOM);
                          return;
                        }

                        final newTask = Task(
                          id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                          title: titleController.text.trim(),
                          description: descController.text.trim(),
                          dueDate: selectedDate,
                          status: selectedStatus,
                          blockedBy: blockedById,
                        );
                        controller.addOrUpdateTask(newTask, isEdit: widget.task != null);
                      },
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text("SAVE TASK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}