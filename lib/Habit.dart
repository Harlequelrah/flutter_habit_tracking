class Habit {
  int id;
  String title;
  bool completed;

  Habit({required this.id, required this.title, this.completed = false});

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      title: map['title'],
      completed: map['completed'] == 1, // Convert int to bool
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'completed': completed ? 1 : 0, // Convert bool to int
    };
  }
}
