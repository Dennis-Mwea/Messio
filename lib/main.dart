import 'package:flutter/material.dart';
import 'package:messio/pages/ConversationPageList.dart';

void main() => runApp(Messio());

class Messio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mesio',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: ConversationPageList(),
    );
  }
}
