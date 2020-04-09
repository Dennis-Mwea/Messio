import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/config/Styles.dart';

class ChatItemWidget extends StatelessWidget {
  final int index;
  const ChatItemWidget(this.index);

  @override
  Widget build(BuildContext context) {
    if (index % 2 == 0) {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Palette.selfMessageBackgroundColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: EdgeInsets.only(right: 10.0),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  child: Text(
                    'This is a sent message.',
                    style: TextStyle(color: Palette.selfMessageColor),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: Text(
                    DateFormat('dd MMM kk:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(1565888474278)),
                    style: Styles.date,
                  ),
                  margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
                ),
              ],
            )
          ],
        ),
      );
    } else {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Text(
                    'This is a received message',
                    style: TextStyle(color: Palette.otherMessageColor),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: Palette.otherMessageBackgroundColor,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                ),
              ],
            ),
            Container(
              child: Text(
                DateFormat('dd MMM kk:mm')
                    .format(DateTime.fromMillisecondsSinceEpoch(1565888474278)),
                style: Styles.date,
              ),
              margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
            ),
          ],
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }
}
