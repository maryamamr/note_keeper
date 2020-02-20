class Notes {
  String _title, _description, _date;
  int id, _priority;

  Notes(this._title, this._date,this._priority, [this._description]);

  Notes.withId(this.id, this._title, this._date, this._priority,
      [this._description]);

  get priority => _priority;

  set priority(value) {
    if (value >= 1 && value <= 2) _priority = value;
  }

  get date => _date;

  set date(value) {
    _date = value;
  }

  get description => _description;

  set description(value) {
    _description = value;
  }

  String get title => _title;

  set title(String value) {
    if (value.length <= 255) _title = value;
  }

  //convert Note to Map objects
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;
    return map;
  }

  Notes.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this._title = map['title'];
    this.description = map['description'];
    this.priority = map['priority'];
    this.date = map['date'];
  }
}
