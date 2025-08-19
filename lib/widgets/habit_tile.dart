import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitTile extends StatelessWidget {
  final Habit habit;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const HabitTile({
    Key? key,
    required this.habit,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Subtle animation for done toggle and streak
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: habit.done ? Colors.teal.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Checkbox(
          value: habit.done,
          onChanged: (v) => onToggle(v ?? false),
          activeColor: Colors.teal,
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              decoration: habit.done ? TextDecoration.lineThrough : TextDecoration.none,
              color: habit.done ? Colors.black54 : Colors.black87,
            ),
            child: Text(habit.title),
          ),
        ),
        subtitle: TweenAnimationBuilder<int>(
          duration: const Duration(milliseconds: 350),
          tween: IntTween(begin: 0, end: habit.streak),
          builder: (_, value, __) => Text(
            "🔥 Streak: $value",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: value > 0 ? Colors.deepOrange : Colors.grey,
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: onEdit,
            ),
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
