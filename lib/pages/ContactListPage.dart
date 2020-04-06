import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/contacts/Bloc.dart';
import 'package:messio/config/Assets.dart';
import 'package:messio/config/Decorations.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/config/Styles.dart';
import 'package:messio/repositories/UserDataRepository.dart';
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
  ContactsBloc contactsBloc;
  UserDataRepository userDataRepository;
  ScrollController scrollController;
  final TextEditingController usernameController = TextEditingController();
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
    userDataRepository = UserDataRepository();
    contactsBloc = ContactsBloc(userDataRepository: userDataRepository);
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
    contactsBloc.dispatch(FetchContactsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider<ContactsBloc>(
          builder: (context) => contactsBloc,
          child: Stack(
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
                  BlocBuilder(
                    builder: (context, state) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return ContactRowWidget(name: nameList[index]);
                          },
                          childCount: nameList.length,
                        ),
                      );
                    },
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
        ),
        floatingActionButton: GradientFab(
          animation: animation,
          vsync: this,
          child: Icon(Icons.add),
          onPressed: showAddContactsBottomSheet,
        ),
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

  void showAddContactsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext buildContext) {
        return BlocProvider<ContactsBloc>(
          builder: (context) => contactsBloc,
          child: StatefulBuilder(
            builder: (context, stateSetter) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Image.asset(Assets.social),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40.0),
                        child: Text(
                          'Add by Username',
                          style: Styles.textHeading,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
                        child: TextField(
                          controller: usernameController,
                          textAlign: TextAlign.center,
                          style: Styles.subHeading,
                          decoration: Decorations.getInputDecoration(
                            hint: '@username',
                            isPrimary: true,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            child: BlocBuilder<ContactsBloc, ContactsState>(
                              builder: (context, state) {
                                return GradientFab(
                                  elevation: 0.0,
                                  child: getButtonChild(state),
                                  onPressed: () {
                                    contactsBloc.dispatch(AddContactEvent(
                                        username: usernameController.text));
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget getButtonChild(ContactsState state) {
    if (state is AddContactSuccessState) {
      return Icon(
        Icons.check,
        color: Palette.primaryColor,
      );
    } else if (state is AddContactProgressState) {
      return SizedBox(
        height: 9.0,
        width: 9.0,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Icon(
        Icons.done,
        color: Palette.primaryColor,
      );
    }
  }
}
