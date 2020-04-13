import 'package:flutter/material.dart';
import 'package:messio/config/Palette.dart';

class Themes {
  static final ThemeData light = ThemeData(
      accentColor: Palette.accentColor,
      primaryColor: Colors.white,
      primarySwatch: Colors.blue,
      disabledColor: Colors.grey,
      cardColor: Colors.white,
      canvasColor: Colors.grey[50],
      scaffoldBackgroundColor: Colors.white,
      brightness: Brightness.light,
      primaryColorBrightness: Brightness.light,
      backgroundColor: Colors.white,
      buttonColor: Palette.accentColor,
      appBarTheme: AppBarTheme(elevation: 0.0),
      fontFamily: 'Manrope',
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)));

  static final ThemeData dark = ThemeData(
      accentColor: Palette.accentColor,
      primaryColor: Colors.black,
      primarySwatch: Colors.blue,
      disabledColor: Colors.grey,
      cardColor: Color(0xFF191919),
      canvasColor: Colors.grey[50],
      backgroundColor: Color(0xFF191919),
      scaffoldBackgroundColor: Colors.black,
      brightness: Brightness.dark,
      primaryColorDark: Colors.white,
      primaryColorBrightness: Brightness.dark,
      appBarTheme: AppBarTheme(elevation: 0.0),
      fontFamily: 'Manrope',
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)));
}
