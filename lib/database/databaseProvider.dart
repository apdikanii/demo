import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqlhelper/model/todo_model.dart';

class TodoDatabase {
  static const _databaseName = 'todos.db';
  static const _databaseVersion = 1;

  static final TodoDatabase instance = TodoDatabase._init();

  TodoDatabase._init();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT
        status INTEGER
      )
    ''');
  }

  static Future<int> createItem(String title, String? description) async {

    final db = await instance.database;
    final data = {'title': title, 'description': description};
    var id = await db.insert('todos', data, conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }


  static Future<Todo?> read(int id) async {
    final db = await instance.database;
    final maps = await db.query('todos', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Todo.fromMap(maps.first);
    } else {
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> readAll() async {
    final db = await instance.database;
    //final orderBy = 'title ASC';
    return db.query('todos', orderBy: "id");

    // return result.map((json) => Todo.fromMap(json)).toList();
  }

  static Future<int> updated(int id, String title, String? description) async {
    final db = await instance.database;
    final data = {
      // 'id': id,
      'title': title,
      'description': description,
    };
    return db.update('todos', data, where: 'id = ?', whereArgs: [id]);
  }


  static Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
