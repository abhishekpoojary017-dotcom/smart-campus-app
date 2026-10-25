class Assignment {
  final String id;
  final String title;
  final String subjectName;
  final DateTime dueDate;
  bool completed;

  Assignment({
    required this.id,
    required this.title,
    required this.subjectName,
    required this.dueDate,
    this.completed = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'subjectName': subjectName,
        'dueDate': dueDate.toIso8601String(),
        'completed': completed,
      };

  factory Assignment.fromMap(Map<dynamic, dynamic> map) => Assignment(
        id: map['id'],
        title: map['title'],
        subjectName: map['subjectName'],
        dueDate: DateTime.parse(map['dueDate']),
        completed: map['completed'] ?? false,
      );
}
