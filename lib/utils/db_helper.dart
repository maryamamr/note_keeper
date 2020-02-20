import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:note_keeper/Model/notes.dart';

class DbHelper {
//only one instance of class
  static DbHelper _dbHelper;
  static Database _database;
  String notesTable = 'notes_table';
  String titleCol = 'title',
      descriptionCol = 'description',
      dateCol = 'date',
      idCol = 'id',
      priorityCol = 'priority';

  DbHelper._createInstance();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createInstance();
    }

    return _dbHelper;
  }

  Future<Database> get databse async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    var notesDB = await openDatabase(path, version: 1, onCreate: _creatDb);
    return notesDB;
  }

  void _creatDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $notesTable($idCol INTEGER PRIMARY KEY AUTOINCREMENT, $titleCol TEXT, $descriptionCol TEXT, $priorityCol INTEGER, $dateCol TEXT)');
  }

  //Fetch op

  Future<List<Map<String, dynamic>>> getNotesMapList() async {
    Database db = await this.databse;
    var result = await db.query(notesTable, orderBy: '$priorityCol ASC');
    return result;
  }

  //insert
  Future<int> insertNote(Notes note) async {
    Database db = await this.databse;
    var result = await db.insert(notesTable, note.toMap());
    return result;
  }

  //update
  Future<int> updateNote(Notes note) async {
    Database db = await this.databse;
    var result = await db.update(notesTable, note.toMap(),
        where: '$idCol=?', whereArgs: [note.id]);
    return result;
  }

  //delete
  Future<int> deleteNote(int id) async {
    var db = await this.databse;
    int result = await db.rawDelete('DELETE FROM $notesTable WHERE $idCol=$id');
    return result;
  }

  //get #of records
  Future<int> getCount() async {
    var db = await this.databse;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $notesTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Notes>> getNoteList() async {
    var noteMap = await getNotesMapList();
    List<Notes> noteList = List<Notes>();
    for (int i = 0; i < noteMap.length; i++) {
      noteList.add(Notes.fromMapObject(noteMap[i]));
    }
    return noteList;
  }
}
