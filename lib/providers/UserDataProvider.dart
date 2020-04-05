import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messio/config/Paths.dart';
import 'package:messio/models/User.dart';
import 'package:messio/providers/BaseProviders.dart';

class UserDataProvider extends BaseUserDataProvider {
  final Firestore firestoreDb;

  UserDataProvider({Firestore firestoreDb})
      : firestoreDb = firestoreDb ?? Firestore.instance;

  @override
  Future<bool> isProfileComplete(String uid) async {
    DocumentReference ref =
        firestoreDb.collection(Paths.userPaths).document(uid);
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
      String uid, String profileImageUrl, int age, String username) async {
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
}
