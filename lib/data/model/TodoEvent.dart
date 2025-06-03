class TodoEvent {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String repeat;
  final List<String> categories;
  final bool isDone;

  TodoEvent({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.repeat,
    required this.categories,
    required this.isDone,
  });

  TodoEvent copyWith({bool? isDone}) {
  return TodoEvent(
    id: id,
    title: title,
    startTime: startTime,
    endTime: endTime,
    repeat: repeat,
    categories: categories,
    isDone: isDone ?? this.isDone,
  );
  }

  factory TodoEvent.fromJson(Map<String, dynamic> json) => TodoEvent(
        id: json['id'],
        title: json['title'],
        startTime: DateTime.parse(json['startTime']),
        endTime: DateTime.parse(json['endTime']),
        repeat: json['repeat'],
        categories:
            (json['categories'] as List).map((e) => e as String).toList(),
        isDone: json['isDone'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'startTime': startTime,
        'endTime': endTime,
        'repeat': repeat,
        'categories': categories,
        'isDone': isDone,
      };
}