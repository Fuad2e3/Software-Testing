import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'food_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE food_items(id TEXT PRIMARY KEY, name TEXT, image TEXT, price TEXT)',
        );
      },
    );
  }

  Future<void> insertFoodItems(List<Map<String, dynamic>> items) async {
    final db = await database;
    Batch batch = db.batch();
    for (var item in items) {
      batch.insert(
        'food_items',
        {
          'id': item['ProductsID'],
          'name': item['ProductName'],
          'image': item['ProductImage'],
          'price': item['price'],
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getFoodItems() async {
    final db = await database;
    return await db.query('food_items');
  }

  Future<void> clearFoodItems() async {
    final db = await database;
    await db.delete('food_items');
  }
}