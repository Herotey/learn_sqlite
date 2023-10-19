import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_learn/model.dart';


class DbManager {
  late Database _database;

   Future openDb()async{
    _database = await openDatabase(join(await getDatabasesPath(), 'ss.db'),
    version: 1, onCreate: (Database db,int version) async {
      await db.execute("CREATE TABLE model(id INTEGER PRIMARY KEY autoincrement, fruitName TEXT, quantity TEXT)");
    });
    return _database;
   }
   Future insterModel(Model model) async{
    await openDb();
    return await _database.insert('model', model.toJson());
   }
   Future<List<Model>> getModelList()async{
    await openDb();
    final List<Map<String, dynamic>> map = await _database.query('model');
    return List.generate(map.length, (i) {
      return Model(
      id: map[i]['id'],
      fruitName: map[i]['fruitNane'],
      quantity: map[i]['quantity']);
    });
   }
   Future<int> updateModel(Model model) async{
    await openDb();
    return await _database.update('model', model.toJson(),
    where: "id = ?", whereArgs: [model.id]);
   }
   Future<int> deleteModel (Model model) async{
    await openDb();
    return await _database.delete('model', where: "id = ?", whereArgs: [model.id]);
   }
}
