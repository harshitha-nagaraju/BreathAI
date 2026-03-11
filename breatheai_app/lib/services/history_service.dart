import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HistoryService {

  static Database? _db;

  // ===============================
  // DATABASE INSTANCE
  // ===============================

  Future<Database> get database async {

    if (_db != null) return _db!;

    _db = await _initDB();

    return _db!;
  }

  // ===============================
  // INITIALIZE DATABASE
  // ===============================

  Future<Database> _initDB() async {

    final String path =
        join(await getDatabasesPath(), 'breatheai.db');

    return await openDatabase(

      path,

      version: 2,

      onCreate: (db, version) async {

        await db.execute('''
          CREATE TABLE scans(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            prediction TEXT,
            confidence REAL,
            risk TEXT,
            recommendation TEXT,
            audioPath TEXT,
            reportPath TEXT,
            date TEXT
          )
        ''');
      },

      // Handles schema update if database already exists
      onUpgrade: (db, oldVersion, newVersion) async {

        if (oldVersion < 2) {

          await db.execute(
              "ALTER TABLE scans ADD COLUMN risk TEXT");

          await db.execute(
              "ALTER TABLE scans ADD COLUMN recommendation TEXT");

          await db.execute(
              "ALTER TABLE scans ADD COLUMN audioPath TEXT");

          await db.execute(
              "ALTER TABLE scans ADD COLUMN reportPath TEXT");

        }
      },
    );
  }

  // ===============================
  // SAVE SCAN RESULT
  // ===============================

  Future<void> saveScan({

    required String prediction,
    required double confidence,
    required String risk,
    required String recommendation,
    required String audioPath,
    required String reportPath,
    required DateTime date,

  }) async {

    final db = await database;

    await db.insert(

      "scans",

      {
        "prediction": prediction,
        "confidence": confidence,
        "risk": risk,
        "recommendation": recommendation,
        "audioPath": audioPath,
        "reportPath": reportPath,
        "date": date.toIso8601String(),
      },

      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ===============================
  // GET SCAN HISTORY
  // ===============================

  Future<List<Map<String, dynamic>>> getHistory() async {

    final db = await database;

    return await db.query(
      "scans",
      orderBy: "date DESC",
    );
  }

  // ===============================
  // DELETE ONE SCAN
  // ===============================

  Future<void> deleteScan(int id) async {

    final db = await database;

    await db.delete(
      "scans",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // ===============================
  // CLEAR HISTORY
  // ===============================

  Future<void> clearHistory() async {

    final db = await database;

    await db.delete("scans");
  }
}