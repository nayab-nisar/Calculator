import 'dart:async';
import 'dart:io' as io;
import 'package:calculator/database/Photo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationCacheDirectory();
    String path = join(documentDirectory.path, 'hide.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE hide (id INTEGER PRIMARY KEY AUTOINCREMENT, image BLOB)"
    );
  }
 

  Future<DataModel> insert(DataModel dbmodel) async {
    var dbClient = await db;
    await dbClient!.insert('hide', dbmodel.toMap());
    return dbmodel;
  }

   Future<List<DataModel>> getNOteList() async{
    var dbClient = await db;
    final List<Map<String, Object?>> querryResult = await dbClient!.query("hide");
    return querryResult.map((e) => DataModel.fromMap(e)).toList();
  }

  
}
