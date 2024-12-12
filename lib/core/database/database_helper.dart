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
    final String path = join(await getDatabasesPath(), 'polyglotte.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Übersetzungen Tabelle
    await db.execute('''
      CREATE TABLE translations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sourceText TEXT NOT NULL,
        targetText TEXT NOT NULL,
        sourceLanguage TEXT NOT NULL,
        targetLanguage TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        isFavorite INTEGER DEFAULT 0,
        isSync INTEGER DEFAULT 0
      )
    ''');

    // Offline Queue Tabelle
    await db.execute('''
      CREATE TABLE offline_queue(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        action TEXT NOT NULL,
        data TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        retryCount INTEGER DEFAULT 0
      )
    ''');

    // Cache Tabelle
    await db.execute('''
      CREATE TABLE translation_cache(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sourceText TEXT NOT NULL,
        targetText TEXT NOT NULL,
        sourceLanguage TEXT NOT NULL,
        targetLanguage TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        UNIQUE(sourceText, sourceLanguage, targetLanguage)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Migrations für zukünftige Versionen
  }

  // CRUD Operationen für Übersetzungen
  Future<int> insertTranslation({
    required String sourceText,
    required String targetText,
    required String sourceLanguage,
    required String targetLanguage,
    bool isFavorite = false,
  }) async {
    final db = await database;
    return await db.insert(
      'translations',
      {
        'sourceText': sourceText,
        'targetText': targetText,
        'sourceLanguage': sourceLanguage,
        'targetLanguage': targetLanguage,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'isFavorite': isFavorite ? 1 : 0,
        'isSync': 0,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getTranslations() async {
    final db = await database;
    return await db.query('translations', orderBy: 'timestamp DESC');
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    return await db.query(
      'translations',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'timestamp DESC',
    );
  }

  Future<int> updateTranslation(Map<String, dynamic> translation) async {
    final db = await database;
    return await db.update(
      'translations',
      translation,
      where: 'id = ?',
      whereArgs: [translation['id']],
    );
  }

  Future<int> deleteTranslation(int id) async {
    final db = await database;
    return await db.delete(
      'translations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Cache Operationen
  Future<void> cacheTranslation({
    required String sourceText,
    required String targetText,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    final db = await database;
    await db.insert(
      'translation_cache',
      {
        'sourceText': sourceText,
        'targetText': targetText,
        'sourceLanguage': sourceLanguage,
        'targetLanguage': targetLanguage,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getCachedTranslation({
    required String sourceText,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'translation_cache',
      where: 'sourceText = ? AND sourceLanguage = ? AND targetLanguage = ?',
      whereArgs: [sourceText, sourceLanguage, targetLanguage],
      limit: 1,
    );
    
    if (result.isNotEmpty) {
      return result.first['targetText'] as String;
    }
    return null;
  }

  // Offline Queue Operationen
  Future<void> addToOfflineQueue({
    required String action,
    required Map<String, dynamic> data,
  }) async {
    final db = await database;
    await db.insert(
      'offline_queue',
      {
        'action': action,
        'data': data.toString(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getOfflineQueue() async {
    final db = await database;
    return await db.query('offline_queue', orderBy: 'timestamp ASC');
  }

  Future<void> clearOfflineQueue() async {
    final db = await database;
    await db.delete('offline_queue');
  }
}
