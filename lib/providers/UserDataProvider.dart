import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messio/config/Constants.dart';
import 'package:messio/config/Paths.dart';
import 'package:messio/models/Contact.dart';
import 'package:messio/models/User.dart';
import 'package:messio/providers/BaseProviders.dart';
import 'package:messio/utils/Exceptions.dart';
import 'package:messio/utils/SharedObjects.dart';

class UserDataProvider extends BaseUserDataProvider {
  final Firestore firestoreDb;

  UserDataProvider({Firestore firestoreDb})
      : firestoreDb = firestoreDb ?? Firestore.instance;

  @override
  Future<bool> isProfileComplete() async {
    DocumentReference ref = firestoreDb
        .collection(Paths.userPaths)
        .document(SharedObjects.prefs.getString(Constants.sessionUid));
    final DocumentSnapshot currentDocument = await ref.get();
    return (currentDocument != null &&
        currentDocument.exists &&
        currentDocument.data.containsKey('username') &&
        currentDocument.data.containsKey('age'));
  }

  @override
  Future<User> saveDetailsFromGoogleAuth(FirebaseUser user) async {
    DocumentReference ref =
        firestoreDb.collection(Paths.userPaths).document(user.uid);
    final bool userExists = !await ref.snapshots().isEmpty;
    var data = {
      'uid': user.uid,
      'email': user.email,
      'name': user.displayName,
    };

    if (!userExists) {
      data['photoUrl'] = user.photoUrl;
    }
    ref.setData(data, merge: true);
    final DocumentSnapshot currentDocument = await ref.get();

    return User.fromFirestore(currentDocument);
  }

  @override
  Future<User> saveProfileDetails(
      String profileImageUrl, int age, String username) async {
    String uid = SharedObjects.prefs.getString(Constants.sessionUid);
    DocumentReference mapReference =
        firestoreDb.collection(Paths.usernameUidMapPath).document(username);
    var mapData = {'uid': uid};
    mapReference.setData(mapData);

    DocumentReference ref =
        firestoreDb.collection(Paths.userPaths).document(uid);
    var data = {
      'photoUrl': profileImageUrl,
      'age': age,
      'username': username,
    };
    ref.setData(data, merge: true);
    final DocumentSnapshot currentDocument = await ref.get();

    return User.fromFirestore(currentDocument);
  }

  @override
  Stream<List<Contact>> getContacts() {
    CollectionReference userRef = firestoreDb.collection(Paths.userPaths);
    DocumentReference ref =
        userRef.document(SharedObjects.prefs.get(Constants.sessionUid));

    return ref.snapshots().transform(
        StreamTransformer<DocumentSnapshot, List<Contact>>.fromHandlers(
            handleData: (documentSnapshot, sink) async {
      List<String> contacts;
      if (documentSnapshot.data['contacts'] == null) {
        ref.updateData({'contacts': []});
        contacts = List();
      } else {
        contacts = List.from(documentSnapshot.data['contacts']);
      }
      List<Contact> contactList = List();
      for (String username in contacts) {
        print(username);
        String uid = await getUidByUsername(username);
        DocumentSnapshot contactSnapshot = await userRef.document(uid).get();
        contactList.add(Contact.fromFirestore(contactSnapshot));
      }
      sink.add(contactList);
    }));
  }

  @override
  Future<void> addContact(String username) async {
    DocumentReference ref = firestoreDb
        .collection(Paths.userPaths)
        .document(SharedObjects.prefs.getString(Constants.sessionUid))
        .collection(Paths.contactsPath)
        .document(username);

    var documentSnapshot = await ref.get();
    print(documentSnapshot.data);
    List<String> contacts = documentSnapshot.data['contacts'] != null
        ? List.from(documentSnapshot.data['contacts'])
        : List();
    if (contacts.contains(username)) {
      throw ContactAlreadyExistsException();
    }
    contacts.add(username);
    ref.updateData({'contacts': contacts});
  }

  @override
  Future<User> getUser(String username) async {
    String uid = await getUidByUsername(username);
    DocumentReference ref =
        firestoreDb.collection(Paths.userPaths).document(uid);
    DocumentSnapshot snapshot = await ref.get();
    if (snapshot.exists) {
      return User.fromFirestore(snapshot);
    } else {
      throw UserNotFoundException();
    }
  }

  @override
  Future<String> getUidByUsername(String username) async {
    //get reference to the mapping using username
    DocumentReference ref =
        firestoreDb.collection(Paths.usernameUidMapPath).document(username);

    DocumentSnapshot documentSnapshot = await ref.get();
    //check if uid mapping for supplied username exists
    if (documentSnapshot != null &&
        documentSnapshot.exists &&
        documentSnapshot.data['uid'] != null) {
      return documentSnapshot.data['uid'];
    } else {
      throw UsernameMappingUndefinedException();
    }
  }
}
