import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  // جلب المهام من قاعدة البيانات وتحديث الواجهة
  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners(); // إشعار الواجهة بحالة التحميل

    _tasks = await DatabaseService.instance.getTasks();

    _isLoading = false;
    notifyListeners(); // إشعار الواجهة بانتهاء التحميل وعرض البيانات
  }

  // إضافة مهمة جديدة
  Future<void> addTask(Task task) async {
    await DatabaseService.instance.insertTask(task);
    await fetchTasks(); // تحديث القائمة فوراً بعد الإضافة
  }

  // تحديث حالة المهمة (مكتملة/غير مكتملة)
  Future<void> toggleTaskStatus(Task task) async {
    final updatedTask =
        task.copyWith(isCompleted: task.isCompleted == 0 ? 1 : 0);
    await DatabaseService.instance.updateTask(updatedTask);
    await fetchTasks();
  }

  // حذف مهمة
  Future<void> removeTask(int id) async {
    await DatabaseService.instance.deleteTask(id);
    await fetchTasks();
  }
}
