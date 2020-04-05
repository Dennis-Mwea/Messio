import 'package:flutter/material.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/pages/ConversationPageSlide.dart';

void main() => runApp(Messio());

class Messio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mesio',
      theme: ThemeData(
        primarySwatch: Palette.primaryColor,
      ),
      home: ConversationPageSlide(),
    );
  }
}
