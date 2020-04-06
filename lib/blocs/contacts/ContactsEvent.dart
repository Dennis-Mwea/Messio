import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:messio/models/Contact.dart';

@immutable
abstract class ContactsEvent extends Equatable {
  ContactsEvent([List props = const <dynamic>[]]) : super(props);
}

class FetchContactsEvent extends ContactsEvent {
  @override
  String toString() => 'FetchContactsEvent';
}

// Dispatch received contacts from stream
class ReceivedContactsEvent extends ContactsEvent {
  final List<Contact> contacts;
  ReceivedContactsEvent(this.contacts) : super([contacts]);
  @override
  String toString() => 'ReceivedContactsEvent';
}

class AddContactEvent extends ContactsEvent {
  final String username;
  AddContactEvent({@required this.username}) : super([username]);

  @override
  String toString() => 'AddContactEvent';
}

class ClickedContactEvent extends ContactsEvent {
  @override
  String toString() => 'ClickedContactEvent';
}
