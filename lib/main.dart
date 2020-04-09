import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/authentication/Bloc.dart';
import 'package:messio/blocs/contacts/bloc.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/pages/ContactListPage.dart';
import 'package:messio/pages/RegisterPage.dart';
import 'package:messio/repositories/AuthenticationRepository.dart';
import 'package:messio/repositories/StorageRepository.dart';
import 'package:messio/repositories/UserDataRepository.dart';
import 'package:messio/utils/SharedObjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository();
  final UserDataRepository userDataRepository = UserDataRepository();
  final StorageRepository storageRepository = StorageRepository();
  SharedObjects.prefs = await SharedPreferences.getInstance();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          builder: (context) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
              userDataRepository: userDataRepository,
              storageRepository: storageRepository)
            ..dispatch(AppLaunched()),
        ),
        BlocProvider<ContactsBloc>(
          builder: (context) => ContactsBloc(
            userDataRepository: userDataRepository,
          ),
        ),
      ],
      child: Messio(),
    ),
  );
}

class Messio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Palette.primaryColor,
        fontFamily: 'Manrope',
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is UnAuthenticated) {
            return RegisterPage();
          } else if (state is ProfileUpdated) {
            return ContactListPage();
          } else {
            return RegisterPage();
          }
        },
      ),
    );
  }
}
