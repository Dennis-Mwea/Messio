import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messio/config/Constants.dart';
import 'package:messio/utils/SharedObjects.dart';

import 'BaseProviders.dart';

class AuthenticationProvider extends BaseAuthenticationProvider {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthenticationProvider({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount account = await googleSignIn.signIn();
    final GoogleSignInAuthentication authentication =
        await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: authentication.idToken,
      accessToken: authentication.accessToken,
    );
    await firebaseAuth.signInWithCredential(credential);
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    SharedObjects.prefs.setString(Constants.sessionUid, firebaseUser.uid);

    return firebaseUser;
  }

  @override
  Future<void> signOutUser() async {
    return Future.wait([firebaseAuth.signOut(), googleSignIn.signOut()]);
  }

  @override
  Future<FirebaseUser> getCurrentUser() async {
    return await firebaseAuth.currentUser();
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = await firebaseAuth.currentUser();
    return user != null;
  }
}
