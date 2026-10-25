import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_data_provider.dart';

class NoticesScreen extends StatelessWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Notice Board')),
      body: data.notices.isEmpty
          ? const Center(child: Text('No notices yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: data.notices.length,
              itemBuilder: (context, i) {
                final n = data.notices[i];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.campaign),
                    title: Text(n.title),
                    subtitle: Text(n.description),
                    trailing: Text(
                      '${n.postedOn.day}/${n.postedOn.month}',
                      style: Theme.of(context).textTheme.bodySmall,
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
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Post Notice'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (titleController.text.trim().isEmpty) return;
              context
                  .read<AppDataProvider>()
                  .addNotice(titleController.text.trim(), descController.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}
