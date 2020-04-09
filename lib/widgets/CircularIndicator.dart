import 'package:flutter/material.dart';
import 'package:messio/config/Palette.dart';

// ignore: must_be_immutable
class CircularIndicator extends StatefulWidget {
  bool isActive;
  CircularIndicator(this.isActive);

  @override
  _CircularIndicatorState createState() => _CircularIndicatorState();
}

class _CircularIndicatorState extends State<CircularIndicator> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: widget.isActive ? 12.0 : 8.0,
      width: widget.isActive ? 12.0 : 8.0,
      decoration: BoxDecoration(
        color: widget.isActive
            ? Palette.primaryColor
            : Palette.secondaryTextColorLight,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    );
  }
}
