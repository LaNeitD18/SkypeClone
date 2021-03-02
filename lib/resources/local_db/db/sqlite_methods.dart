import 'dart:io';

import 'package:SkypeClone/models/log.dart';
import 'package:SkypeClone/resources/local_db/interface/log_interface.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SqliteMethods implements LogInterface {
  Database _database;

  String databaseName = "LogDB";
  String tableName = "Call_Logs";

  // column
  String id = 'log_id';
  String callerName = 'callerName';
  String callerPic = 'callerPic';
  String receiverName = 'receiverName';
  String receiverPic = 'receiverPic';
  String callStatus = 'callStatus';
  String timestamp = 'timestamp';

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }
    print("db was null, now awaiting it");
    _database = await init();
    return _database;
  }

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, databaseName);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    String createTableQuery =
        "CREATE TABLE $tableName ($id INTEGER PRIMARY KEY, $callerName TEXT, $callerPic TEXT, $receiverName TEXT, $receiverPic TEXT, $callStatus TEXT, $timestamp TEXT)";
    await db.execute(createTableQuery);
    print("table created");
  }

  @override
  addLogs(Log log) async {
    var dbClient = await db;
    await dbClient.insert(tableName, log.toMap(log));
  }

  @override
  deleteLogs(int logId) async {
    var dbClient = await db;
    return await dbClient.delete(tableName,
        where: '$id = ?', // see doc of where to understand meaning of "?"
        whereArgs: [logId]);
  }

  updateLogs(Log log) async {
    var dbClient = await db;

    await dbClient.update(
      tableName,
      log.toMap(log),
      where: '$id = ?',
      whereArgs: [log.logId],
    );
  }

  @override
  Future<List<Log>> getLogs() async {
    try {
      var dbClient = await db;

      //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $tableName");
      List<Map> maps = await dbClient.query(tableName, columns: [
        id,
        callerName,
        callerPic,
        receiverName,
        receiverPic,
        callStatus,
        timestamp,
      ]);

      List<Log> logList = [];

      if (maps.isNotEmpty) {
        for (Map map in maps) {
          logList.add(Log.fromMap(map));
        }
      }
      return logList;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
