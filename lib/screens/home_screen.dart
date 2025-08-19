import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../widgets/habit_tile.dart';
import '../services/habit_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final HabitStorage _storage = HabitStorage();
  final TextEditingController _addController = TextEditingController();

  List<Habit> _habits = [];
  bool _loading = true;

  late final AnimationController _fabCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
    lowerBound: 0.95,
    upperBound: 1.0,
  )..forward();

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final loaded = await _storage.loadHabits();
    if (!mounted) return;
    setState(() {
      _habits = loaded;
      _loading = false;
    });
  }

  Future<void> _saveHabits() async => _storage.saveHabits(_habits);

  void _addHabitFromInline() {
    final t = _addController.text.trim();
    if (t.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Habit cannot be empty!')),
      );
      return;
    }
    setState(() {
      _habits.insert(0, Habit(title: t));
      _addController.clear();
    });
    FocusScope.of(context).unfocus();
    _saveHabits();
  }

  void _showAddDialog() {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Add Habit'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _confirmAddDialog(ctx, controller),
          decoration: const InputDecoration(
            hintText: 'e.g. Read 15 mins',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => _confirmAddDialog(ctx, controller), child: const Text('Add')),
        ],
      ),
    );
  }

  void _confirmAddDialog(BuildContext ctx, TextEditingController c) {
    final t = c.text.trim();
    if (t.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Habit cannot be empty!')),
      );
      return;
    }
    setState(() => _habits.insert(0, Habit(title: t)));
    _saveHabits();
    Navigator.of(ctx).pop();
  }

  void _toggleHabit(Habit habit, bool value) {
    setState(() {
      habit.done = value;
      habit.streak = value ? habit.streak + 1 : 0;
    });
    _saveHabits();
  }

  void _editHabit(int index) {
    final controller = TextEditingController(text: _habits[index].title);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Edit Habit'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _confirmEdit(ctx, controller, index),
          decoration: const InputDecoration(
            hintText: 'Update habit name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => _confirmEdit(ctx, controller, index), child: const Text('Save')),
        ],
      ),
    );
  }

  void _confirmEdit(BuildContext ctx, TextEditingController c, int index) {
    final t = c.text.trim();
    if (t.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Habit cannot be empty!')),
      );
      return;
    }
    setState(() => _habits[index].title = t);
    _saveHabits();
    Navigator.of(ctx).pop();
  }

  void _deleteHabit(int index) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete habit?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() => _habits.removeAt(index));
              _saveHabits();
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _addController.dispose();
    _fabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = _loading
        ? const Center(child: CircularProgressIndicator())
        : Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _addController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addHabitFromInline(),
                  decoration: const InputDecoration(
                    hintText: 'Add a habit',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _addHabitFromInline, child: const Text('Add')),
            ],
          ),
        ),
        Expanded(
          child: _habits.isEmpty
              ? const Center(child: Text('No habits yet. Add one!'))
              : ListView.builder(
            itemCount: _habits.length,
            itemBuilder: (context, index) {
              final habit = _habits[index];
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                child: KeyedSubtree(
                  key: ValueKey('${habit.title}-${habit.done}-${habit.streak}'),
                  child: HabitTile(
                    habit: habit,
                    onToggle: (v) => _toggleHabit(habit, v),
                    onDelete: () => _deleteHabit(index),
                    onEdit: () => _editHabit(index),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Habit Tracker'), centerTitle: true, elevation: 4),
      body: body,
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(parent: _fabCtrl, curve: Curves.easeOutBack),
        child: FloatingActionButton(
          onPressed: _showAddDialog,
          backgroundColor: Colors.teal,
          child: const Icon(Icons.add, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
