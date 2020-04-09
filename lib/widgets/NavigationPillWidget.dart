import 'package:flutter/material.dart';
import 'package:messio/config/Palette.dart';

class NavigationPillWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Center(
              child: Wrap(
                children: <Widget>[
                  Container(
                    width: 50.0,
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    height: 5.0,
                    decoration: BoxDecoration(
                      color: Palette.accentColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
