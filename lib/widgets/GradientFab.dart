import 'package:flutter/material.dart';
import 'package:messio/config/Palette.dart';

class GradientFab extends StatelessWidget {
  final Animation<double> animation;
  final TickerProvider vsync;

  const GradientFab({Key key, this.animation, this.vsync}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: Duration(milliseconds: 1000),
      vsync: vsync,
      curve: Curves.linear,
      child: ScaleTransition(
        scale: animation,
        child: FloatingActionButton(
          child: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomRight,
                colors: [
                  Palette.gradientStartColor,
                  Palette.gradientEndColor,
                ],
              ),
            ),
            child: Icon(Icons.add),
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
