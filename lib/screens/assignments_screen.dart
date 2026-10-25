import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_data_provider.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      body: data.assignments.isEmpty
          ? const Center(child: Text('No assignments yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: data.assignments.length,
              itemBuilder: (context, i) {
                final a = data.assignments[i];
                final overdue = !a.completed && a.dueDate.isBefore(DateTime.now());
                return Card(
                  child: CheckboxListTile(
                    value: a.completed,
                    onChanged: (_) =>
                        context.read<AppDataProvider>().toggleAssignmentComplete(a),
                    title: Text(
                      a.title,
                      style: TextStyle(
                        decoration: a.completed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(
                      '${a.subjectName} • Due ${a.dueDate.day}/${a.dueDate.month}/${a.dueDate.year}',
                      style: TextStyle(color: overdue ? Colors.red : null),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final subjectController = TextEditingController();
    DateTime dueDate = DateTime.now().add(const Duration(days: 7));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Assignment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('Due: ${dueDate.day}/${dueDate.month}/${dueDate.year}'),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: dueDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setDialogState(() => dueDate = picked);
                    },
                    child: const Text('Pick date'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty) return;
                context.read<AppDataProvider>().addAssignment(
                      titleController.text.trim(),
                      subjectController.text.trim(),
                      dueDate,
                    );
                Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
