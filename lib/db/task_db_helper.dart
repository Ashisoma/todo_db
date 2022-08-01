// ignore_for_file: void_checks

import 'package:sqflite/sqflite.dart';
import 'package:todo_db/models/task.dart';

class DBHelper {
  static Database? _db;

// todo reruun the creation of the DBHelper
  static final int version = 1;
  static final String _tableName = "tasks";

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      _db =
          await openDatabase(_path, version: version, onCreate: (db, version) {
        print("Creatimg a new one");
        return db
          ..execute(
            "CREATE TABLE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
            "title STRING, note TEXT, date STRING, "
            "startTime STRING, endTime STRING, "
            "reminder INTEGER, repeat STRING, "
            "color INTEGER,"
            "isComplete INTEGER)",
          );
      });
    } catch (e) {
      print("Heres the errors : \n $e");
    }
  }

  static Future<int> insert(Task? task) async {
    print("Inseting data ... table = $_tableName \n database is  = $_db");
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> getTasks() async {
    print("Getting data ... table = $_tableName \n database is  = $_db");
    return await _db!.query(_tableName);
  }

  static delete(Task task) async {
    await _db!.delete(_tableName, where: "id=?", whereArgs: [task.id]);
  }

  static update(int id) async {
   return await _db!.rawUpdate('''
        UPDATE tasks
        SET isComplete = ?
        WHERE id =?
    ''', [1, id]);
  }
}
