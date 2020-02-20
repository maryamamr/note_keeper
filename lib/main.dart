import 'package:flutter/material.dart';
import 'package:note_keeper/screens/HomePage.dart';

void main() => runApp(MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColorDark: Colors.pink[900],
          primaryColor: Colors.pink[900],
          accentColor: Colors.yellow[300]),
    ));
