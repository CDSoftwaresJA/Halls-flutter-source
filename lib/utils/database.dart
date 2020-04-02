import 'dart:async';
import 'package:sqlcool/sqlcool.dart';
import 'package:hallsmusic/objects/song.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  List<Song> list = [], recent = [];
  Db db;
  List<DbTable> schema;
  DB() {
    db = Db();
    DbTable song = DbTable("song")
      ..varchar("name")
      ..varchar("email")
      ..varchar("description")
      ..varchar("genre")
      ..varchar("picture")
      ..varchar("song", unique: true)
      ..index("name");

    DbTable recent = DbTable("recent")
      ..varchar("name")
      ..varchar("email")
      ..varchar("description")
      ..varchar("genre")
      ..varchar("picture")
      ..varchar("song", unique: true)
      ..index("name");

    schema = [song, recent];
  }

  initDB() async {
    String dbPath = "db.sqlite"; // relative to the documents directory
    try {
      await db.init(path: dbPath, schema: schema);
    } catch (e) {
      rethrow;
    }
  }

  addSong(Song song, String database) async {
    final Map<String, String> row = {
      "name": song.name,
      "email": song.email,
      "description": song.description,
      "genre": song.genre,
      "picture": song.picture,
      "song": song.song
    };
    try {
      await db.insert(table: database, row: row);
    } catch (e) {
      rethrow;
    }
  }

  getSongs() async {
    list = [];
    try {
      List<Map<String, dynamic>> rows = await db.select(
        table: 'song',
      );
      return List.generate(rows.length, (index) {
        list.add(Song(
            rows[index]['name'],
            rows[index]['email'],
            rows[index]['description'],
            rows[index]['genre'],
            rows[index]['picture'],
            rows[index]['song']));
      });
    } catch (e) {
      rethrow;
    }
  }

  getRecentSongs() async {
    recent = [];
    try {
      List<Map<String, dynamic>> rows = await db.select(
        table: 'recent',
      );
      return List.generate(rows.length, (index) {
        recent.add(Song(
            rows[index]['name'],
            rows[index]['email'],
            rows[index]['description'],
            rows[index]['genre'],
            rows[index]['picture'],
            rows[index]['song']));
      });
    } catch (e) {
      rethrow;
    }
  }

  getSongList(String database) {
    if (database == 'song') {
      getSongs();
      return list;
    }

    if (database == 'recent') {
      getRecentSongs();
      return recent;
    }
  }

  clearTable(String table) async {}

  deleteSong(Song song, String table) async {
    try {
      await db.delete(table: table, where: "name=" + song.name);
    } catch (e) {
      rethrow;
    }
  }
}
