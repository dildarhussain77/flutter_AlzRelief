class Task {
  final String id;
  final String taskName;
  final String date;
  final String time;
  bool isCompleted;

  Task({
    required this.id,
    required this.taskName,
    required this.date,
    required this.time,
    this.isCompleted = false,
  });

  factory Task.fromMap(Map<String, dynamic> data, String id) {
  return Task(
    id: id,
    taskName: data['taskName'] ?? '',
    date: data['date'] ?? '',
    time: data['time'] ?? '',
    isCompleted: data['isCompleted'] ?? false,
  );
}

  Map<String, dynamic> toMap() {
    return {
      'taskName': taskName,
      'date': date,
      'time': time,
      'isCompleted': isCompleted,
    };
  }
}