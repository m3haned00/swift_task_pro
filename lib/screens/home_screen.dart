import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TaskProvider>().fetchTasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        // استخدام ScrollView يعطي طابع البراندات الكبيرة
        slivers: [
          SliverAppBar.large(
            title: const Text('Swift Task Pro'),
            actions: [
              IconButton(
                icon: const Icon(Icons.account_circle, size: 30),
                onPressed: () {}, // مظهر فقط حالياً
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Consumer<TaskProvider>(
              builder: (context, provider, child) {
                final total = provider.tasks.length;
                final completed =
                    provider.tasks.where((t) => t.isCompleted == 1).length;
                final progress = total == 0 ? 0.0 : completed / total;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPremiumStats(completed, total, progress),
                      const SizedBox(height: 24),
                      const Text(
                        "مهامك اليومية",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                );
              },
            ),
          ),
          Consumer<TaskProvider>(
            builder: (context, provider, child) {
              if (provider.tasks.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text("ابدأ يومك بإضافة مهمة جديدة")),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final task = provider.tasks[index];
                    return _buildModernTaskCard(task, provider);
                  },
                  childCount: provider.tasks.length,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTaskScreen())),
        label: const Text('New Task'),
        icon: const Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildPremiumStats(int completed, int total, double progress) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF673AB7), Color(0xFF9575CD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF673AB7).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("معدل الإنجاز",
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            "${(progress * 100).toInt()}% Done",
            style: const TextStyle(
                color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white24,
            color: Colors.white,
            minHeight: 6,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTaskCard(dynamic task, dynamic provider) {
    final isDone = task.isCompleted == 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: GestureDetector(
            onTap: () => provider.toggleTaskStatus(task),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? Colors.green : Colors.transparent,
                border: Border.all(color: isDone ? Colors.green : Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(Icons.check,
                    size: 20,
                    color: isDone ? Colors.white : Colors.transparent),
              ),
            ),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: isDone ? TextDecoration.lineThrough : null,
              color: isDone ? Colors.grey : Colors.black87,
            ),
          ),
          subtitle: Text(task.priority,
              style: TextStyle(color: _getPriorityColor(task.priority))),
          trailing: IconButton(
            icon: const Icon(Icons.delete_sweep_outlined,
                color: Colors.redAccent),
            onPressed: () => provider.removeTask(task.id!),
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String p) {
    if (p == 'High') return Colors.red;
    if (p == 'Medium') return Colors.orange;
    return Colors.green;
  }
}
