import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/timetable_entry.dart';
import '../models/attendance_record.dart';
import '../models/notice.dart';
import '../models/assignment.dart';

/// Central state manager for the app.
/// Uses Hive boxes for local, offline-first persistence.
/// Swap this out for Firestore calls later without touching the UI much,
/// since screens only depend on this provider's public methods/getters.
class AppDataProvider extends ChangeNotifier {
  static const _timetableBox = 'timetableBox';
  static const _attendanceBox = 'attendanceBox';
  static const _noticeBox = 'noticeBox';
  static const _assignmentBox = 'assignmentBox';

  final _uuid = const Uuid();

  late Box _timetable;
  late Box _attendance;
  late Box _notices;
  late Box _assignments;

  List<TimetableEntry> timetable = [];
  List<AttendanceRecord> attendanceRecords = [];
  List<Notice> notices = [];
  List<Assignment> assignments = [];

  Future<void> init() async {
    _timetable = await Hive.openBox(_timetableBox);
    _attendance = await Hive.openBox(_attendanceBox);
    _notices = await Hive.openBox(_noticeBox);
    _assignments = await Hive.openBox(_assignmentBox);

    _loadAll();

    if (_timetable.isEmpty && _notices.isEmpty) {
      _seedSampleData();
    }
  }

  void _loadAll() {
    timetable = _timetable.values
        .map((e) => TimetableEntry.fromMap(Map<dynamic, dynamic>.from(e)))
        .toList();
    attendanceRecords = _attendance.values
        .map((e) => AttendanceRecord.fromMap(Map<dynamic, dynamic>.from(e)))
        .toList();
    notices = _notices.values
        .map((e) => Notice.fromMap(Map<dynamic, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.postedOn.compareTo(a.postedOn));
    assignments = _assignments.values
        .map((e) => Assignment.fromMap(Map<dynamic, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    notifyListeners();
  }

  // ---------- Timetable ----------
  Future<void> addTimetableEntry(TimetableEntry entry) async {
    await _timetable.put(entry.id, entry.toMap());
    _loadAll();
  }

  List<TimetableEntry> classesForDay(String day) =>
      timetable.where((e) => e.day == day).toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));

  // ---------- Attendance ----------
  Future<void> markAttendance(String subjectName, DateTime date, bool present) async {
    final record = AttendanceRecord(
      id: _uuid.v4(),
      subjectName: subjectName,
      date: date,
      present: present,
    );
    await _attendance.put(record.id, record.toMap());
    _loadAll();
  }

  /// Returns attendance % for a subject, 0-100. Returns null if no records.
  double? attendancePercentFor(String subjectName) {
    final records = attendanceRecords.where((r) => r.subjectName == subjectName).toList();
    if (records.isEmpty) return null;
    final presentCount = records.where((r) => r.present).length;
    return (presentCount / records.length) * 100;
  }

  Set<String> get subjectsWithAttendance =>
      attendanceRecords.map((r) => r.subjectName).toSet();

  // ---------- Notices ----------
  Future<void> addNotice(String title, String description) async {
    final notice = Notice(
      id: _uuid.v4(),
      title: title,
      description: description,
      postedOn: DateTime.now(),
    );
    await _notices.put(notice.id, notice.toMap());
    _loadAll();
  }

  // ---------- Assignments ----------
  Future<void> addAssignment(String title, String subjectName, DateTime dueDate) async {
    final assignment = Assignment(
      id: _uuid.v4(),
      title: title,
      subjectName: subjectName,
      dueDate: dueDate,
    );
    await _assignments.put(assignment.id, assignment.toMap());
    _loadAll();
  }

  Future<void> toggleAssignmentComplete(Assignment assignment) async {
    assignment.completed = !assignment.completed;
    await _assignments.put(assignment.id, assignment.toMap());
    _loadAll();
  }

  List<Assignment> get pendingAssignments =>
      assignments.where((a) => !a.completed).toList();

  // ---------- Seed sample data so the app isn't empty on first run ----------
  void _seedSampleData() {
    addTimetableEntry(TimetableEntry(
      id: _uuid.v4(),
      day: 'Monday',
      subjectName: 'Data Structures',
      startTime: '09:00',
      endTime: '10:00',
      room: 'Lab 2',
    ));
    addTimetableEntry(TimetableEntry(
      id: _uuid.v4(),
      day: 'Monday',
      subjectName: 'DBMS',
      startTime: '10:00',
      endTime: '11:00',
      room: 'Room 101',
    ));
    addNotice('Welcome!', 'This is a sample notice. Admins can post real ones here.');
  }
}
