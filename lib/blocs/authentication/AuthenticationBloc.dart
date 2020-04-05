import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:messio/blocs/authentication/AuthenticationEvent.dart';
import 'package:messio/blocs/authentication/AuthenticationState.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {}
}