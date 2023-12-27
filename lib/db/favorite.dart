import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../const/db.dart';
import '../models/favorite.dart';

class FavoritesDb {
  //staticでインスタンス生成せずにメソッドを呼び出す
  static Future<Database> openDb() async {
    return await openDatabase(
      join(await getDatabasesPath(), favFileName),
      // dbが無ければcreate
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $favTableName(id INTEGER PRIMARY KEY)',
        );
      },
      version: 1, // dbのversion(更新時に利用)
    );
  }

  // Create
  static Future<void> create(Favorite fav) async {
    var db = await openDb();
    await db.insert(favTableName, fav.toMap(), // toMapで'id'をkeyとして保存
        conflictAlgorithm:
            ConflictAlgorithm.replace // sqlでconflictを起こした際にrecordをreplace
        );
  }

  // Read
  static Future<List<Favorite>> read() async {
    var db = await openDb();
    final List<Map<String, dynamic>> favList = await db.query(favTableName);
    return List.generate(
        // idだけのListを返す
        favList.length,
        (index) => Favorite(
              pokeId: favList[index]['id'],
            ));
  }

  // Delete
  static Future<void> delete(int pokeId) async {
    var db = await openDb();
    await db.delete(
      favTableName,
      where: 'id = ?',
      whereArgs: [pokeId],
    );
  }
}
