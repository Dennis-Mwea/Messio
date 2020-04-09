import 'package:flutter/material.dart';
import 'package:messio/config/Assets.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/config/Styles.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height = 100.0;
  const ChatAppBar();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              spreadRadius: 0.1,
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
                                    icon: Icon(Icons.attach_file),
                                    onPressed: () => {},
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Dennis Mwea',
                                        style: Styles.textHeading,
                                      ),
                                      Text(
                                        '@mweadennis',
                                        style: Styles.text,
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
                                style: Styles.text,
                              ),
                              VerticalDivider(
                                width: 30,
                                color: Palette.primaryTextColor,
                              ),
                              Text(
                                'Videos',
                                style: Styles.text,
                              ),
                              VerticalDivider(
                                width: 30,
                                color: Palette.primaryTextColor,
                              ),
                              Text('Files', style: Styles.text),
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
                      radius: 30,
                      backgroundImage: Image.asset(
                        Assets.user,
                      ).image,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
