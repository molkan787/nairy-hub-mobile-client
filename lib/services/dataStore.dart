import 'dart:async';
import 'package:nairy_hub/entities/thingy.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataStoreService {
  static Database? _db;

  static Future<void> init() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'main4_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE thingies(id INTEGER PRIMARY KEY AUTOINCREMENT, type INTEGER, status INTEGER, summary TEXT, content TEXT, createdAt TEXT, updatedAt TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> addThingy(Thingy thingy) async {
    thingy.createdAt = DateTime.now();
    thingy.updatedAt = DateTime.now();
    var id = await _db?.insert(
      'thingies',
      thingy.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (id != null) {
      thingy.id = id;
    }
  }

  static Future<void> saveThingy(Thingy thingy) async {
    thingy.updatedAt = DateTime.now();
    await _db?.update('thingies', thingy.toMap(),
        where: 'id = ?', whereArgs: [thingy.id]);
  }

  static Future<List<Thingy>> getItems() async {
    final List<Map<String, dynamic>>? maps = await _db?.query('thingies');
    if (maps != null) {
      var items = maps.map((e) => Thingy.fromMap(e)).toList();
      items.sort((a, b) =>
          b.createdAt.millisecondsSinceEpoch -
          a.createdAt.millisecondsSinceEpoch);
      return items;
    } else {
      return List<Thingy>.empty();
    }
  }

  static Future<void> clearAllItems() async {
    await _db?.delete('thingies');
  }

  static Future<void> deleteItems(List<int> itemsIds) async {
    await _db?.delete('thingies',
        where: 'id in (${List.filled(itemsIds.length, '?').join(",")})',
        whereArgs: itemsIds);
  }

  static Future<void> deleteItem(int itemId) async {
    await _db?.delete('thingies', where: 'id == ?', whereArgs: [itemId]);
  }
}
