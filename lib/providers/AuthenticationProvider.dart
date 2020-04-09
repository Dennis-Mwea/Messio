import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messio/config/Constants.dart';
import 'package:messio/providers/BaseProviders.dart';
import 'package:messio/utils/SharedObjects.dart';

class AuthenticationProvider extends BaseAuthenticationProvider {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  AuthenticationProvider({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount account =
        await googleSignIn.signIn(); // Show the google login prompt
    final GoogleSignInAuthentication authentication =
        await account.authentication; // Get the authentication object
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      // retrieve the authentication credentials
      idToken: authentication.idToken,
      accessToken: authentication.accessToken,
    );
    await firebaseAuth.signInWithCredential(
        credential); // sign in to firebase using the generated credentials
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    SharedObjects.prefs.setString(Constants.sessionUid, firebaseUser.uid);

    return firebaseUser; // return the firebase user created;
  }

  @override
  Future<void> signOutUser() async {
    return Future.wait([
      firebaseAuth.signOut(),
      googleSignIn.signOut()
    ]); // terminate the session
  }

  @override
  Future<FirebaseUser> getCurrentUser() async {
    return await firebaseAuth.currentUser(); // retrieve the current user
  }

  @override
  Future<bool> isLoggedIn() async {
    final user =
        await firebaseAuth.currentUser(); // check if user is logged in or not

    return user != null;
  }
}
