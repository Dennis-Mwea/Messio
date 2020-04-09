import 'package:flutter/material.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/models/Contact.dart';

class ContactRowWidget extends StatelessWidget {
  final Contact contact;
  const ContactRowWidget({Key key, this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.primaryColor,
    );
  }
}
