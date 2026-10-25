class TimetableEntry {
  final String id;
  final String day; // Monday, Tuesday, ...
  final String subjectName;
  final String startTime; // "09:00"
  final String endTime; // "10:00"
  final String room;

  TimetableEntry({
    required this.id,
    required this.day,
    required this.subjectName,
    required this.startTime,
    required this.endTime,
    required this.room,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'day': day,
        'subjectName': subjectName,
        'startTime': startTime,
        'endTime': endTime,
        'room': room,
      };

  factory TimetableEntry.fromMap(Map<dynamic, dynamic> map) => TimetableEntry(
        id: map['id'],
        day: map['day'],
        subjectName: map['subjectName'],
        startTime: map['startTime'],
        endTime: map['endTime'],
        room: map['room'],
      );
}
