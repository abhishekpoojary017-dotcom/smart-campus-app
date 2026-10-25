class AttendanceRecord {
  final String id;
  final String subjectName;
  final DateTime date;
  final bool present;

  AttendanceRecord({
    required this.id,
    required this.subjectName,
    required this.date,
    required this.present,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'subjectName': subjectName,
        'date': date.toIso8601String(),
        'present': present,
      };

  factory AttendanceRecord.fromMap(Map<dynamic, dynamic> map) => AttendanceRecord(
        id: map['id'],
        subjectName: map['subjectName'],
        date: DateTime.parse(map['date']),
        present: map['present'],
      );
}
