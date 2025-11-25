import 'package:heraguard_frontend/features/MedicalAppointments/data/models/medical_appointment_dto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MedicalAppointmentLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'medical_appointments.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE medical_appointments (
            medicalAppointmentId TEXT PRIMARY KEY,
            nameOfPatient TEXT,
            date TEXT,
            time TEXT,
            description TEXT,
            doctorId TEXT,
            caregiverId TEXT,
            elderId TEXT,
            doctorName TEXT,
            caregiverName TEXT,
            elderName TEXT,
            sincronizado INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<void> insertAppointmentAsPending(
    MedicalAppointmentDto appointment,
  ) async {
    final db = await database;
    await db.insert(
      'medical_appointments',
      {
        ...appointment.toJson(),
        'sincronizado': 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertAppointmentAsSynced(
    MedicalAppointmentDto appointment,
  ) async {
    final db = await database;
    await db.insert(
      'medical_appointments',
      {
        ...appointment.toJson(),
        'sincronizado': 1,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MedicalAppointmentDto>> getPendingAppointments() async {
    final db = await database;
    final maps = await db.query(
      'medical_appointments',
      where: 'sincronizado = ?',
      whereArgs: [0],
    );
    return maps.map((map) => MedicalAppointmentDto.fromJson(map)).toList();
  }

  Future<void> updateAppointmentSyncStatus(
    String medicalAppointmentId,
    bool sincronizado,
  ) async {
    final db = await database;
    await db.update(
      'medical_appointments',
      {'sincronizado': sincronizado ? 1 : 0},
      where: 'medicalAppointmentId = ?',
      whereArgs: [medicalAppointmentId],
    );
  }

  Future<void> deleteAppointment(String medicalAppointmentId) async {
    final db = await database;
    await db.delete(
      'medical_appointments',
      where: 'medicalAppointmentId = ?',
      whereArgs: [medicalAppointmentId],
    );
  }

  Future<List<MedicalAppointmentDto>> getAllAppointments() async {
    final db = await database;
    final maps = await db.query('medical_appointments');
    return maps.map((map) => MedicalAppointmentDto.fromJson(map)).toList();
  }
}
