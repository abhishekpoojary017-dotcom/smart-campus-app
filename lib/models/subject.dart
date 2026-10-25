class Subject {
  final String id;
  final String name;
  final String code;

  Subject({required this.id, required this.name, required this.code});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'code': code};

  factory Subject.fromMap(Map<dynamic, dynamic> map) => Subject(
        id: map['id'],
        name: map['name'],
        code: map['code'],
      );
}
