import 'package:flutter/material.dart';
import 'package:habit_tracking/habit.dart';
import 'package:habit_tracking/habit_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suivi d\'habitude',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red), // Replace with your desired color
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.amber,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.red,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ), // Replace with your desired color
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final habitService = HabitService();
  List<Habit> habits = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  _loadHabits() async {
    habits = await HabitService.getAllHabits();
    setState(() {});
  }

  _addHabit() async {
    if (_formKey.currentState!.validate()) {
      int newId = habits.isEmpty ? 1 : habits.last.id + 1;
      Habit habit = Habit(id: newId, title: _titleController.text);
      await HabitService.insert(habit);
      _loadHabits();
      _titleController.clear();

      // Close the dialog after adding a habit
      Navigator.pop(context);
    }
  }

  _updateHabit(Habit habit) async {
    habit.completed = !habit.completed;
    await HabitService.update(habit);
    _loadHabits();
  }

  _deleteHabit(int id) async {
    await HabitService.delete(id);
    _loadHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi d\'habitude'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: habits.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(habits[index].title),
            leading: Checkbox(
              value: habits[index].completed,
              onChanged: (value) => _updateHabit(habits[index]),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteHabit(habits[index].id),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Ajouter une habitude'),
                content: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Entrez le titre de l\'habitude',
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Veuillez entrer un titre d\'habitude';
                      }
                      return null;
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () => _addHabit(),
                    child: const Text('Ajouter'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
