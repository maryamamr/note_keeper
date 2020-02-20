import 'package:flutter/material.dart';
import 'package:note_keeper/Model/notes.dart';
import 'package:note_keeper/utils/db_helper.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NoteDetails extends StatefulWidget {
  final String appbarTitle;
  final Notes note;

  NoteDetails(this.note, this.appbarTitle);

  @override
  _NoteDetailsState createState() => _NoteDetailsState(note, appbarTitle);
}

class _NoteDetailsState extends State<NoteDetails> {
  String appbarTitle;
  Notes note;
  DbHelper dbHelper = DbHelper();

  _NoteDetailsState(this.note, this.appbarTitle);

  static var _priority = ['high', 'low'];
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _titleController.text = note.title;
    _descController.text = note.description;
    return Scaffold(
      appBar: AppBar(
        title: Text(appbarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: TextField(
                controller: _titleController,
                onChanged: (vlaue) {
                  updateTitle();
                },
                decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15.0),
              child: TextField(
                controller: _descController,
                onChanged: (vlaue) {
                  updateDesc();
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            ListTile(
              title: Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Priority ',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: DropdownButton(
                          items: _priority.map((String dropDownItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownItem,
                              child: Text(dropDownItem),
                            );
                          }).toList(),
                          value: convertoString(note.priority),
                          onChanged: (valueSelected) {
                            setState(() {
                              convertoInt(valueSelected);
                            });
                          }),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.all(20.0),
                height: 50,
                width: 200,
                child: RaisedButton(
                  color: Colors.pink[600],
                  shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  onPressed: () {
                    saveData();
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String convertoString(int value) {
    String pri;
    switch (value) {
      case 1:
        pri = _priority[0];
        break;
      case 2:
        pri = _priority[1];
        break;
    }
    return pri;
  }

  void convertoInt(String value) {
    switch (value) {
      case 'high':
        note.priority = 1;
        break;
      case 'low':
        note.priority = 2;
        break;
    }
  }

  void updateTitle() {
    note.title = _titleController.text;
  }

  void updateDesc() {
    note.description = _descController.text;
  }

  void saveData() async {
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      result = await dbHelper.updateNote(note);
    } else {
      result = await dbHelper.insertNote(note);
    }
    if (result != null) //success
    {
      _showSuccessAlertDialog('Note saved succefully');
    } else {
      _showErrorAlertDialog('Problem saving note');
    }
  }

  void _showErrorAlertDialog(String msg) {
    Alert(
      context: context,
      type: AlertType.error,
      title: '',
      desc: msg,
      buttons: [],
    ).show();
  }

  void _showSuccessAlertDialog(String msg) {
    Alert(
      context: context,
      type: AlertType.success,
      title: '',
      desc: msg,
      buttons: [],
    ).show();
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
