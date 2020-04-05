import 'package:flutter/material.dart';
import 'package:messio/config/Assets.dart';
import 'package:messio/config/Palette.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height = 100;

  const ChatAppBar();

  @override
  Widget build(BuildContext context) {
    var textHeading = TextStyle(
        color: Palette.primaryTextColor,
        fontSize: 20); // Text style for the name
    var textStyle = TextStyle(
        color: Palette.secondaryTextColor); // Text style for everything else
    double width =
        MediaQuery.of(context).size.width; // calculate the screen width

    return Material(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          color: Palette.primaryBackgroundColor,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 7,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.attach_file,
                                      color: Palette.secondaryColor,
                                    ),
                                    onPressed: () => {},
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Dennis Mwea',
                                        style: textHeading,
                                      ),
                                      Text(
                                        '@dennismwea',
                                        style: textStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Photos',
                                style: textStyle,
                              ),
                              VerticalDivider(
                                width: 30.0,
                                color: Palette.primaryTextColor,
                              ),
                              Text(
                                'Videos',
                                style: textStyle,
                              ),
                              VerticalDivider(
                                width: 30.0,
                                color: Palette.primaryTextColor,
                              ),
                              Text(
                                'Files',
                                style: textStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  child: Center(
                    child: CircleAvatar(
                      radius: (80 - (width * .06)) / 2,
                      backgroundImage: Image.asset(Assets.user).image,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
