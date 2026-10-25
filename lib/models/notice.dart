class Notice {
  final String id;
  final String title;
  final String description;
  final DateTime postedOn;

  Notice({
    required this.id,
    required this.title,
    required this.description,
    required this.postedOn,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'postedOn': postedOn.toIso8601String(),
      };

  factory Notice.fromMap(Map<dynamic, dynamic> map) => Notice(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        postedOn: DateTime.parse(map['postedOn']),
      );
}
