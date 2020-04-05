import 'package:flutter/material.dart';
import 'package:messio/config/Palette.dart';

class ContactRowWidget extends StatelessWidget {
  final String name;

  const ContactRowWidget({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.primaryColor,
      child: Padding(
        padding: EdgeInsets.only(left: 30.0, top: 15.0, bottom: 15.0),
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(text: "${name.toString().split(' ')[0]} "),
              TextSpan(
                text: name.toString().split(' ')[1],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
