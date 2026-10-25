import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_data_provider.dart';
import 'timetable_screen.dart';
import 'attendance_screen.dart';
import 'notices_screen.dart';
import 'assignments_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final _screens = const [
    DashboardTab(),
    TimetableScreen(),
    AttendanceScreen(),
    NoticesScreen(),
    AssignmentsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.schedule), label: 'Timetable'),
          NavigationDestination(icon: Icon(Icons.check_circle), label: 'Attendance'),
          NavigationDestination(icon: Icon(Icons.campaign), label: 'Notices'),
          NavigationDestination(icon: Icon(Icons.assignment), label: 'Assignments'),
        ],
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AppDataProvider>();
    final today = DateTime.now();
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    final todayName = days[today.weekday - 1];
    final todaysClasses = data.classesForDay(todayName);
    final pending = data.pendingAssignments;
    final latestNotice = data.notices.isNotEmpty ? data.notices.first : null;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Hi there 👋', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(todayName, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 20),

        _SectionCard(
          title: "Today's Classes",
          child: todaysClasses.isEmpty
              ? const Text('No classes scheduled today.')
              : Column(
                  children: todaysClasses
                      .map((c) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.book_outlined),
                            title: Text(c.subjectName),
                            subtitle: Text('${c.startTime} - ${c.endTime} • ${c.room}'),
                          ))
                      .toList(),
                ),
        ),
        const SizedBox(height: 12),

        _SectionCard(
          title: 'Pending Assignments (${pending.length})',
          child: pending.isEmpty
              ? const Text('Nothing pending. Nice!')
              : Column(
                  children: pending
                      .take(3)
                      .map((a) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.assignment_late_outlined),
                            title: Text(a.title),
                            subtitle: Text(
                                'Due: ${a.dueDate.day}/${a.dueDate.month}/${a.dueDate.year}'),
                          ))
                      .toList(),
                ),
        ),
        const SizedBox(height: 12),

        _SectionCard(
          title: 'Latest Notice',
          child: latestNotice == null
              ? const Text('No notices yet.')
              : ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.campaign_outlined),
                  title: Text(latestNotice.title),
                  subtitle: Text(latestNotice.description),
                ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
