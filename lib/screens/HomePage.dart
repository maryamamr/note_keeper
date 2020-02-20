import 'package:flutter/material.dart';
import 'package:note_keeper/screens/noteDetails.dart';
import 'dart:async';
import 'package:note_keeper/Model/notes.dart';
import 'package:note_keeper/utils/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbHelper dbHelper = new DbHelper();
  List<Notes> notesList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (notesList == null) {
      notesList = List<Notes>();
      updateListView();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Notes"),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.pink[600],
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              navigateToDetail(Notes('', '', 2), 'Add note');
            }),
        body: Padding(
          child: ListView.builder(
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        getPriorityCOlor(this.notesList[index].priority),
                  ),
                  title: Text(this.notesList[index].title),
                  subtitle: Text(this.notesList[index].date),
                  trailing: GestureDetector(
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onTap: () {
                      _delete(context, this.notesList[index]);
                    },
                  ),
                  onTap: () {
                    navigateToDetail(this.notesList[index], 'Edit note');
                  },
                ),
              );
            },
          ),
          padding: EdgeInsets.all(5.0),
        ));
  }

  //return priorty color
  Color getPriorityCOlor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.green[300];
        break;
      default:
        return Colors.yellow;
    }
  }

  void _delete(BuildContext context, Notes note) async {
    int result = await dbHelper.deleteNote(note.id);
    if (result != null) {
      _showSnackBar(context, 'Note deleted');
    }
  }

  void _showSnackBar(BuildContext context, String msg) {
    final snackbar = SnackBar(content: Text(msg));
    Scaffold.of(context).showSnackBar(snackbar);
    updateListView();
  }

  void navigateToDetail(Notes note, String title) async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NoteDetails(note, title)));
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Notes>> noteListFuture = dbHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.notesList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
