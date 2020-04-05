import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:messio/config/Styles.dart';
import 'package:messio/widgets/ContactRowWidget.dart';
import 'package:messio/widgets/GradientFab.dart';
import 'package:messio/widgets/QuickScrollBar.dart';

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();

  const ContactListPage();
}

class _ContactListPageState extends State<ContactListPage>
    with TickerProviderStateMixin {
  ScrollController scrollController;
  List nameList = [
    'Anya Ostrem',
    'Burt Hutchison',
    'Chana Sobolik',
    'Chasity Nutt',
    'Deana Tenenbaum',
    'Denae Cornelius',
    'Elisabeth Saner',
    'Eloise Rocca',
    'Eloy Kallas',
    'Esther Hobby',
    'Euna Sulser',
    'Florinda Convery',
    'Franklin Nottage',
    'Gale Nordeen',
    'Garth Vanderlinden',
    'Gracie Schulte',
    'Inocencia Eaglin',
    'Jillian Germano',
    'Jimmy Friddle',
    'Juliann Bigley',
    'Kia Gallaway',
    'Larhonda Ariza',
    'Larissa Reichel',
    'Lavone Beltz',
    'Lazaro Bauder',
    'Len Northup',
    'Leonora Castiglione',
    'Lynell Hanna',
    'Madonna Heisey',
    'Marcie Borel',
    'Margit Krupp',
    'Marvin Papineau',
    'Mckinley Yocom',
    'Melita Briones',
    'Moses Strassburg',
    'Nena Recalde',
    'Norbert Modlin',
    'Onita Sobotka',
    'Raven Ecklund',
    'Robert Waldow',
    'Roxy Lovelace',
    'Rufina Chamness',
    'Saturnina Hux',
    'Shelli Perine',
    'Sherryl Routt',
    'Soila Phegley',
    'Tamera Strelow',
    'Tammy Beringer',
    'Vesta Kidd',
    'Yan Welling'
  ];
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(scrollListener);
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    );
    animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            CustomScrollView(
              controller: scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: 120.0,
                  automaticallyImplyLeading: false,
                  floating: true,
                  pinned: true,
                  elevation: 0.0,
                  titleSpacing: 0.0,
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      return FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text(
                          'Contact',
                          style: Styles.appBarTitle,
                        ),
                      );
                    },
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ContactRowWidget(name: nameList[index]);
                    },
                    childCount: nameList.length,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 190.0),
                  child: QuickScrollBar(
                    nameList: nameList,
                    scrollController: scrollController,
                  ),
                )
              ],
            ),
          ],
        ),
        floatingActionButton: GradientFab(animation: animation, vsync: this),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }
}
