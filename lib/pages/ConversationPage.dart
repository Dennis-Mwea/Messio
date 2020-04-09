import 'package:flutter/material.dart';
import 'package:messio/widgets/ChatAppBar.dart';
import 'package:messio/widgets/ChatListWidget.dart';

class ConversationPage extends StatelessWidget {
  const ConversationPage();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: ChatAppBar(),
        ),
        Expanded(
          flex: 11,
          child: ChatListWidget(),
        ),
      ],
    );
  }
}
