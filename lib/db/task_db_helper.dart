class DBHelper {
  static Database? db;

  static final int version = 1;
  static final String _tableName = "tasks";

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    }
    try {
      String path = await getDatabasePath() + 'tasks.db';
      _db =
          await openDatabase(_path, version: version, onCreate: (db, version) {
        print("Creatimg a new one");
        return db
          ..execute(
            "CREATE DATABASE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, date STRING, "
            "startTime STRING, endTime STRING, "
            "reminder INTEGER, repeat STRING, "
            "color INTEGER,"
            "isComplete INTEGER)",
          );
      });
    } catch (e) {
      print(e);
    }
  }
}
