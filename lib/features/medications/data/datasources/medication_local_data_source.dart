import 'package:flutter/widgets.dart';
import 'package:heraguard_frontend/features/medications/domain/entities/medication.dart';
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

  Future<void> insertMedicationAsPending(MedicationDto medication) async {
    if (medication.elderId.isEmpty) {
      return;
    }
    final db = await database;
    await db.insert('medications', {
      ...medication.toJson(),
      'sincronizado': 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

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

  Future<List<Medication>> getPendingMedicationsByElder(String elderId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'medications',
      where: 'elderId = ? AND sincronizado = ?',
      whereArgs: [elderId, 0],
    );

    return maps
        .map((map) => MedicationDto.fromJson(map) as Medication)
        .toList();
  }

  Future<List<Medication>> getAllMedicationsByElder(String elderId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'medications',
      where: 'elderId = ?',
      whereArgs: [elderId],
    );

    return maps
        .map((map) => MedicationDto.fromJson(map) as Medication)
        .toList();
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

  Future<void> deletePendingByMatch({
    required String name,
    required DateTime startDate,
    required String dosage,
    required String elderId,
  }) async {
    final db = await database;
    await db.delete(
      'medications',
      where:
          'name = ? AND startDate = ? AND dosage = ? AND elderId = ? AND medicationId LIKE ? AND sincronizado = 0',
      whereArgs: [name, startDate.toIso8601String(), dosage, elderId, 'temp_%'],
    );
  }

  Future<void> deletePendingByLooseMatch({
    required String name,
    required String dosage,
    required int frequency,
    required int duration,
    required String elderId,
  }) async {
    final db = await database;
    await db.delete(
      'medications',
      where:
          'name = ? AND dosage = ? AND frequency = ? AND duration = ? AND elderId = ? AND medicationId LIKE ? AND sincronizado = 0',
      whereArgs: [name, dosage, frequency, duration, elderId, 'temp_%'],
    );
  }
  /*
  Future<void> printLocalPendingMedications() async {
    final db = await database;
    final rows = await db.query('medications', where: 'sincronizado = 0');
    debugPrint('Pendientes locales:');
    for (final row in rows) print(row);
  }*/

  Future<void> deleteTempByNameAndElder({
    required String name,
    required String elderId,
  }) async {
    final db = await database;
    await db.delete(
      'medications',
      where:
          'name = ? AND elderId = ? AND medicationId LIKE ? AND sincronizado = 0',
      whereArgs: [name, elderId, 'temp_%'],
    );
  }

  Future<void> deleteAllTempByNameAndElder({
    required String name,
    required String elderId,
  }) async {
    final db = await database;
    await db.delete(
      'medications',
      where:
          'name = ? AND elderId = ? AND medicationId LIKE ? AND sincronizado = 0',
      whereArgs: [name, elderId, 'temp_%'],
    );
  }

  Future<void> deleteAllTemps() async {
    final db = await database;
    await db.delete(
      'medications',
      where: 'medicationId LIKE ? AND sincronizado = 0',
      whereArgs: ['temp_%'],
    );
  }
}
