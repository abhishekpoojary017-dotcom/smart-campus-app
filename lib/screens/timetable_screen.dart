import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../providers/app_data_provider.dart';
import '../models/timetable_entry.dart';

const _days = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
];

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  String _selectedDay = _days.first;

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();
    final classes = data.classesForDay(_selectedDay);

    return Scaffold(
      appBar: AppBar(title: const Text('Timetable')),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _days.map((day) {
                final selected = day == _selectedDay;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(day.substring(0, 3)),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedDay = day),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: classes.isEmpty
                ? const Center(child: Text('No classes on this day.'))
                : ListView.builder(
                    itemCount: classes.length,
                    itemBuilder: (context, i) {
                      final c = classes[i];
                      return ListTile(
                        leading: const Icon(Icons.schedule),
                        title: Text(c.subjectName),
                        subtitle: Text('${c.startTime} - ${c.endTime} • ${c.room}'),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final subjectController = TextEditingController();
    final roomController = TextEditingController();
    final startController = TextEditingController(text: '09:00');
    final endController = TextEditingController(text: '10:00');
    String day = _selectedDay;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Class'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: day,
                  items: _days
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (v) => setDialogState(() => day = v ?? day),
                  decoration: const InputDecoration(labelText: 'Day'),
                ),
                TextField(
                  controller: subjectController,
                  decoration: const InputDecoration(labelText: 'Subject'),
                ),
                TextField(
                  controller: roomController,
                  decoration: const InputDecoration(labelText: 'Room'),
                ),
                TextField(
                  controller: startController,
                  decoration: const InputDecoration(labelText: 'Start time (HH:MM)'),
                ),
                TextField(
                  controller: endController,
                  decoration: const InputDecoration(labelText: 'End time (HH:MM)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (subjectController.text.trim().isEmpty) return;
                context.read<AppDataProvider>().addTimetableEntry(
                      TimetableEntry(
                        id: const Uuid().v4(),
                        day: day,
                        subjectName: subjectController.text.trim(),
                        startTime: startController.text.trim(),
                        endTime: endController.text.trim(),
                        room: roomController.text.trim(),
                      ),
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
