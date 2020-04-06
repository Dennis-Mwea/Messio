import 'package:flutter/material.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/config/Styles.dart';

class Decorations {
  static InputDecoration getInputDecoration(
      {@required String hint, @required bool isPrimary}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: isPrimary ? Styles.hintText : Styles.hintTextLight,
      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: isPrimary ? Palette.secondaryColor : Palette.primaryColor,
          width: 0.1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: isPrimary ? Palette.secondaryColor : Palette.primaryColor,
          width: 0.1,
        ),
      ),
    );
  }
}
