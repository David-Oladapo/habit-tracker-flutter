class Habit {
  String title;
  bool done;
  int streak;

  Habit({
    required this.title,
    this.done = false,
    this.streak = 0,
  });

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
    title: json['title'] as String,
    done: json['done'] ?? false,
    streak: (json['streak'] ?? 0) as int,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'done': done,
    'streak': streak,
  };
}