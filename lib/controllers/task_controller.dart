import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/task_model.dart';
import 'dart:async';

class TaskController extends GetxController {
  final _box = GetStorage();
  var tasks = <Task>[].obs;
  var isLoading = false.obs;

  // Search & Filter state
  var searchQuery = ''.obs;
  var filterStatus = Rxn<TaskStatus>();

  // Debouncer for search stretch goal
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  // Load from Storage
  void loadTasks() {
    List<dynamic>? storedTasks = _box.read<List>('tasks');
    if (storedTasks != null) {
      tasks.assignAll(storedTasks.map((e) => Task.fromMap(e as Map<String, dynamic>)).toList());
    }
  }

  void saveToDisk() => _box.write('tasks', tasks.map((e) => e.toMap()).toList());

  // CRUD with 2-second delay
  Future<void> addOrUpdateTask(Task task, {bool isEdit = false}) async {
    isLoading.value = true;
    
    // Simulate API call with 2 seconds delay
    await Future.delayed(const Duration(seconds: 2));

    if (isEdit) {
      int index = tasks.indexWhere((t) => t.id == task.id);
      if(index != -1) {
        tasks[index] = task;
      } else {
        tasks.add(task);
      }
    } else {
      tasks.add(task);
    }

    saveToDisk();
    clearDrafts();
    isLoading.value = false;
    
    // Close the bottom sheet or modal
    if(Get.isDialogOpen == true || Get.isBottomSheetOpen == true) {
      Get.back();
    } else {
      Get.back(); // Standard Nav pop if pushed
    }
  }

  void deleteTask(String id) {
    tasks.removeWhere((t) => t.id == id);
    saveToDisk();
  }

  void togglePinTask(String id) {
    int index = tasks.indexWhere((t) => t.id == id);
    if(index != -1) {
      tasks[index].isPinned = !tasks[index].isPinned;
      tasks.refresh();
      saveToDisk();
    }
  }

  // --- Draft Logic (Persist text while typing but not saved) ---
  void saveDraft(String title, String desc) {
    _box.write('draft_title', title);
    _box.write('draft_desc', desc);
  }

  void clearDrafts() {
    _box.remove('draft_title');
    _box.remove('draft_desc');
  }

  // --- Search & Filter Logic ---
  
  void updateSearchQuery(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      searchQuery.value = query;
    });
  }

  void updateFilterStatus(TaskStatus? status) {
    filterStatus.value = status;
  }

  List<Task> get filteredTasks {
    final filtered = tasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(searchQuery.value.toLowerCase());
      final matchesStatus = filterStatus.value == null || task.status == filterStatus.value;
      return matchesSearch && matchesStatus;
    }).toList();
    
    // Sort so pinned tasks appear first
    filtered.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return 0; 
    });
    
    return filtered;
  }

  // Blocked Logic: Task B is blocked if Task A is not "Done"
  bool isTaskBlocked(Task task) {
    if (task.blockedBy == null || task.blockedBy!.isEmpty) return false;
    final blocker = tasks.firstWhereOrNull((t) => t.id == task.blockedBy);
    return blocker != null && blocker.status != TaskStatus.done;
  }
}
