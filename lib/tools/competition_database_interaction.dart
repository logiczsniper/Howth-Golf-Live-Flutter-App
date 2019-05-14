import 'dart:async';

import 'package:howth_golf_live/tools/competition_data_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseInteraction {
  final String tableName = 'competitions';

  Future<Database> getDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'competitions_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE IF NOT EXISTS $tableName(id INTEGER PRIMARY KEY, title TEXT, location TEXT, opposition TEXT, time TEXT, date TEXT, holes TEXT, score TEXT)",
        );
      },
      version: 1,
    );
    return database;
  }

  Future<void> insertCompetition(Competition competition) async {
    final Database db = await getDatabase();

    await db.insert(
      tableName,
      competition.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCompetition(Competition competition) async {
    final Database db = await getDatabase();

    await db.update(
      tableName,
      competition.toMap(),
      where: "id = ?",
      whereArgs: [competition.id],
    );
  }

  Future<void> deleteCompetition(int id) async {
    final Database db = await getDatabase();

    await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<List<Competition>> competitions() async {
    final Database db = await getDatabase();

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return Competition(
          id: maps[i]['id'],
          title: maps[i]['title'],
          date: maps[i]['date'],
          location: maps[i]['location'],
          opposition: maps[i]['opposition'],
          time: maps[i]['time'],
          holes: maps[i]['holes'],
          score: maps[i]['score']);
    });
  }
}
