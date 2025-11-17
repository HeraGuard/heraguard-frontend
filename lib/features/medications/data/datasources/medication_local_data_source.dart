import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/medication_dto.dart';

class MedicationLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'medications.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE medications (
          medicationId TEXT PRIMARY KEY,
          name TEXT,
          description TEXT,
          dosage TEXT,
          frequency INTEGER,
          duration INTEGER,
          startDate TEXT,
          doctorId TEXT,
          elderId TEXT,
          caregiverId TEXT,
          doctorName TEXT,
          caregiverName TEXT,
          elderName TEXT,
          sincronizado INTEGER DEFAULT 0
        )
      ''');
      },
    );
  }

  // Insertar medicamento como pendiente de sincronizar
  Future<void> insertMedicationAsPending(MedicationDto medication) async {
    final db = await database;
    await db.insert('medications', {
      ...medication.toJson(),
      'sincronizado': 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Insertar medicamento ya sincronizado
  Future<void> insertMedicationAsSynced(MedicationDto medication) async {
    final db = await database;
    await db.insert('medications', {
      ...medication.toJson(),
      'sincronizado': 1,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<MedicationDto>> getPendingMedications() async {
    final db = await database;
    final maps = await db.query(
      'medications',
      where: 'sincronizado = ?',
      whereArgs: [0],
    );
    return maps.map((map) => MedicationDto.fromJson(map)).toList();
  }

  Future<void> updateMedicationSyncStatus(
    String medicationId,
    bool sincronizado,
  ) async {
    final db = await database;
    await db.update(
      'medications',
      {'sincronizado': sincronizado ? 1 : 0},
      where: 'medicationId = ?',
      whereArgs: [medicationId],
    );
  }

  Future<void> deleteMedication(String medicationId) async {
    final db = await database;
    await db.delete(
      'medications',
      where: 'medicationId = ?',
      whereArgs: [medicationId],
    );
  }

  Future<List<MedicationDto>> getAllMedications() async {
    final db = await database;
    final maps = await db.query('medications');
    return maps.map((map) => MedicationDto.fromJson(map)).toList();
  }
}
