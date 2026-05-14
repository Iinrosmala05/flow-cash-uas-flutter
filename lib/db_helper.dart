import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'flowcash.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        amount INTEGER,
        type TEXT,
        category TEXT,
        date TEXT
      )
    ''');

    await db.execute('''
    CREATE TABLE user (
      id INTEGER PRIMARY KEY,
      name TEXT,
      balance REAL
    )
  ''');
  await db.insert('user', {'id': 1, 'name': 'User', 'balance': 0.0});
  }

  Future<int> insertTransaction(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('transactions', row);
  }

  Future<List<Map<String, dynamic>>> queryAllTransactions() async {
    Database db = await instance.database;
    return await db.query('transactions', orderBy: 'id DESC');
  }

  Future<int> deleteTransaction(int id) async {
    Database db = await instance.database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateUser(String name, double balance) async {
    final db = await instance.database; 
    return await db.update(
      'user', {'name': name, 'balance': balance},
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}