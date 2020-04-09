import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:messio/repositories/UserDataRepository.dart';
import 'package:messio/utils/Exceptions.dart';

import './bloc.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  UserDataRepository userDataRepository;
  StreamSubscription subscription;
  ContactsBloc({this.userDataRepository}) : assert(userDataRepository != null);

  @override
  ContactsState get initialState => InitialContactsState();

  @override
  Stream<ContactsState> mapEventToState(
    ContactsEvent event,
  ) async* {
    print(event);

    if (event is FetchContactsEvent) {
      try {
        yield FetchingContactsState();

        subscription?.cancel();
        subscription = userDataRepository.getContacts().listen((contacts) => {
              print('dispatching $contacts'),
              dispatch(ReceivedContactsEvent(contacts))
            });
      } on MessioException catch (exception) {
        print(exception.errorMessage());
        yield ErrorState(exception);
      }
    }

    if (event is ReceivedContactsEvent) {
      print('Received');
      //  yield FetchingContactsState();
      yield FetchedContactsState(event.contacts);
    }

    if (event is AddContactEvent) {
      yield* mapAddContactEventToState(event.username);
    }

    if (event is ClickedContactEvent) {
      yield* mapClickedContactEventToState();
    }
  }

  Stream<ContactsState> mapFetchContactsEventToState() async* {
    try {
      yield FetchingContactsState();
      subscription?.cancel();
      subscription = userDataRepository.getContacts().listen((contacts) => {
            print('dispatching $contacts'),
            dispatch(ReceivedContactsEvent(contacts))
          });
    } on MessioException catch (exception) {
      print(exception.errorMessage());
      yield ErrorState(exception);
    }
  }

  Stream<ContactsState> mapAddContactEventToState(String username) async* {
    try {
      yield AddContactProgressState();
      await userDataRepository.addContact(username);
      yield AddContactSuccessState();
    } on MessioException catch (exception) {
      print(exception.errorMessage());
      yield AddContactFailedState(exception);
    }
  }

  Stream<ContactsState> mapClickedContactEventToState() async* {
    // ToDo: Redirect to chat screen
  }

  @override
  void dispose() {
    subscription.cancel();

    super.dispose();
  }
}
