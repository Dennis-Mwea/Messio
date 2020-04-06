import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/authentication/AuthenticationBloc.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/pages/ContactListPage.dart';
import 'package:messio/pages/ConversationPageSlide.dart';
import 'package:messio/pages/RegisterPage.dart';
import 'package:messio/repositories/AuthenticationRepository.dart';
import 'package:messio/repositories/StorageRepository.dart';
import 'package:messio/repositories/UserDataRepository.dart';
import 'package:messio/utils/SharedObjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/authentication/Bloc.dart';

void main() async {
  final AuthenticationRepository authRepository = AuthenticationRepository();
  final UserDataRepository userDataRepository = UserDataRepository();
  final StorageRepository storageRepository = StorageRepository();
  SharedObjects.prefs = await SharedPreferences.getInstance();

  runApp(
    BlocProvider(
      builder: (context) => AuthenticationBloc(
          authenticationRepository: authRepository,
          userDataRepository: userDataRepository,
          storageRepository: storageRepository)
        ..dispatch(AppLaunched()),
      child: Messio(
        authenticationRepository: authRepository,
        userDataRepository: userDataRepository,
        storageRepository: storageRepository,
      ),
    ),
  );
}

class Messio extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;
  final UserDataRepository userDataRepository;
  final StorageRepository storageRepository;

  Messio(
      {Key key,
      @required this.authenticationRepository,
      @required this.userDataRepository,
      @required this.storageRepository})
      : assert(authenticationRepository != null),
        assert(userDataRepository != null),
        assert(storageRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mesio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Palette.primaryColor,
        fontFamily: 'Manrope',
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return ContactListPage();
          if (state is UnAuthenticated) {
            return RegisterPage();
          } else if (state is ProfileUpdated) {
            return ConversationPageSlide();
          } else {
            return RegisterPage();
          }
        },
      ),
    );
  }
}
