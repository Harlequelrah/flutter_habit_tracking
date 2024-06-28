import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'habit.dart';

class HabitService {
  static Database? _database;

  static Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  static Future<Database?> _initDatabase() async {
    final dbPath = join(await getDatabasesPath(), 'habits.db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE habits(id INTEGER PRIMARY KEY, title TEXT, completed BOOLEAN)',
        );
      },
    );
  }

  static Future<void> insert(Habit habit) async {
    final db = await database;
    if (db != null) {
      await db.insert(
        'habits',
        habit.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<List<Habit>> getAllHabits() async {
    final db = await database;
    if (db != null) {
      final result = await db.query('habits');
      return result.map((row) => Habit.fromMap(row)).toList();
    }
    return []; // or throw an exception
  }

  static Future<void> update(Habit habit) async {
    final db = await database;
    if (db != null) {
      await db.update(
        'habits',
        habit.toMap(),
        where: 'id = ?',
        whereArgs: [habit.id],
      );
    }
  }

  static Future<void> delete(int id) async {
    final db = await database;
    if (db != null) {
      await db.delete(
        'habits',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  static Future<bool> _isIdUnique(int id) async {
    final db = await database;
    if (db != null) {
      final result =
          await db.rawQuery('SELECT COUNT(*) FROM habits WHERE id = ?', [id]);
      final count = Sqflite.firstIntValue(result);
      return count == 0;
    }
    return false; // or throw an exception
  }

  static int _generateUniqueId() {
    // Generate a unique id (e.g., using a UUID or a counter)
    // ...
    return 1; // Replace this with your implementation
  }
}
