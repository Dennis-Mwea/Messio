import 'package:flutter/material.dart';
import 'package:messio/config/Palette.dart';

class ContactRowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.primaryColor,
      padding: EdgeInsets.only(left: 30.0, top: 15.0, bottom: 15.0),
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(text: 'Dennis'),
                TextSpan(
                  text: 'Mwea',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
