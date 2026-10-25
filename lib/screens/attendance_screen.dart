import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_data_provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final _subjectController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();
    final subjects = data.subjectsWithAttendance.toList()..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mark today\'s attendance',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Subject name',
                      hintText: 'e.g. Data Structures',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text('Present'),
                          onPressed: () => _mark(context, true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.close),
                          label: const Text('Absent'),
                          onPressed: () => _mark(context, false),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Subject-wise attendance %',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (subjects.isEmpty) const Text('No attendance marked yet.'),
          ...subjects.map((s) {
            final pct = data.attendancePercentFor(s) ?? 0;
            final low = pct < 75;
            return Card(
              child: ListTile(
                title: Text(s),
                subtitle: LinearProgressIndicator(
                  value: pct / 100,
                  color: low ? Colors.red : Colors.green,
                ),
                trailing: Text(
                  '${pct.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: low ? Colors.red : Colors.green,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _mark(BuildContext context, bool present) {
    final subject = _subjectController.text.trim();
    if (subject.isEmpty) return;
    context.read<AppDataProvider>().markAttendance(subject, DateTime.now(), present);
    _subjectController.clear();
    FocusScope.of(context).unfocus();
  }
}
