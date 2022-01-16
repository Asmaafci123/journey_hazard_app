import 'package:journeyhazard/features/trips/data/models/risk.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'risk_db.db'),
        onCreate: _create, version: 1);
  }

 static  Future _create(Database db, int version) async {
    await  db.execute(
        'CREATE TABLE cemex_risk('
            'risk_ID INTEGER PRIMARY KEY,'
            'risk_AR TEXT,'
            'risk_EN TEXT,'
            'active INTEGER DEFAULT 1,'
            'lat TEXT,'
            'long TEXT,'
            'comment TEXT,'
            'distance REAL,'
            'done INTEGER DEFAULT 0,'
            'riskLevel TEXT)');

    await  db.execute(
        'CREATE TABLE driver_data('
            'mobile TEXT,'
            'country TEXT,'
            'company TEXT,'
            'supportNo TEXT,'
            'shipmentId TEXT)');

    await  db.execute(
        'CREATE TABLE trip_risk('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'risk_ID INTEGER,'
            'shipment_ID TEXT,'
            'mobileNumber TEXT,'
            'status TEXT,'
            'country TEXT,'
            'lat TEXT, '
            'long TEXT)');
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<int> delete(String table, int userId) async {
    final db = await DBHelper.database();
    return await db.delete(table, where: 'id = ?', whereArgs: [userId]);
  }

  static Future<int> deleteRisk(String table, int riskId) async {
    final db = await DBHelper.database();
    return await db.delete(table, where: 'risk_ID = ?', whereArgs: [riskId]);
  }

  static Future<int> deleteByStatus(String table, String status) async {
    final db = await DBHelper.database();
    return await db.delete(table, where: 'status = ?', whereArgs: [status]);
  }
  static Future<int> deleteAll(String table) async {
    final db = await DBHelper.database();
    return await db.delete(table);
  }

  static Future<void> update(String table, value, key) async {
    final db = await DBHelper.database();
    return await db.rawUpdate('UPDATE $table SET $key = ?', [value]);
  }

  static Future<void> updateWhere({int done,double distance,int riskId}) async {
    final db = await DBHelper.database();
    return await db.rawUpdate('UPDATE cemex_risk SET done = ?, distance = ?   WHERE risk_ID = ?', [done, distance, riskId]);
  }
}
