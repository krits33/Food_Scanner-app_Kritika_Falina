import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    // If _database is null, initialize it
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'products_database.db');

    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY,
            productFound INTEGER,
            barcode TEXT,
            name TEXT,
            image TEXT,
            ingredients TEXT,
            quantity TEXT,
            nutritionImage TEXT,
            ingredientsImage TEXT,
            origins TEXT,
            manufacturingPlaces TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  Future<List<Product>> getSavedProducts() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (index) {
      return Product.fromMap(maps[index]);
    });
  }

  static Future<void> removeProduct(Product product) async {
    final db = await database;
    await db.delete(
      'products',
      where: 'barcode = ?',
      whereArgs: [product.barcode],
    );
  }

  static Future<void> updateProductName(String barcode, String newName) async {
    final db = await database;
    await db.update(
      'products',
      {'name': newName},
      where: 'barcode = ?',
      whereArgs: [barcode],
    );
  }

  static Future<void> saveProduct(Product product) async {
    final Database db = await database;

    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
