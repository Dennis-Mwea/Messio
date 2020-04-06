import 'package:flutter_test/flutter_test.dart';
import 'package:messio/providers/AuthenticationProvider.dart';
import 'package:messio/utils/SharedObjects.dart';
import 'package:mockito/mockito.dart';

import '../mock/FirebaseMock.dart';
import '../mock/SharedObjectsMock.dart';

void main() {
  group('AuthenticationProvider', () {
    FirebaseAuthMock firebaseAuth = FirebaseAuthMock();
    GoogleSignInMock googleSignIn = GoogleSignInMock();
    AuthenticationProvider authenticationProvider = AuthenticationProvider(
        firebaseAuth: firebaseAuth, googleSignIn: googleSignIn);
    //Mock rest of the objects needed to replicate the AuthenticationProvider functions
    final GoogleSignInAccountMock googleSignInAccount =
        GoogleSignInAccountMock();
    final GoogleSignInAuthenticationMock googleSignInAuthentication =
        GoogleSignInAuthenticationMock();
    final FirebaseUserMock firebaseUser = FirebaseUserMock();
    SharedPreferencesMock sharedPreferencesMock = SharedPreferencesMock();
    SharedObjects.prefs = sharedPreferencesMock;

    test('signInWithGoogle returns a Firebase user', () async {
      //mock the method calls
      when(sharedPreferencesMock.get(any)).thenReturn('uid');
      when(googleSignIn.signIn()).thenAnswer(
          (_) => Future<GoogleSignInAccountMock>.value(googleSignInAccount));
      when(googleSignInAccount.authentication).thenAnswer((_) =>
          Future<GoogleSignInAuthenticationMock>.value(
              googleSignInAuthentication));
      when(firebaseAuth.currentUser())
          .thenAnswer((_) => Future<FirebaseUserMock>.value(firebaseUser));

      expect(await authenticationProvider.signInWithGoogle(), firebaseUser);
      verify(googleSignIn.signIn()).called(1);
      verify(googleSignInAccount.authentication).called(1);
    });

    test('getCurrentUser returns current user', () async {
      when(firebaseAuth.currentUser())
          .thenAnswer((_) => Future<FirebaseUserMock>.value(firebaseUser));
      expect(await authenticationProvider.getCurrentUser(), firebaseUser);
    });

    test('isLoggedIn return true only when FirebaseAuth has a user', () async {
      when(firebaseAuth.currentUser())
          .thenAnswer((_) => Future<FirebaseUserMock>.value(firebaseUser));
      expect(await authenticationProvider.isLoggedIn(), true);
      when(firebaseAuth.currentUser())
          .thenAnswer((_) => Future<FirebaseUserMock>.value(null));
      expect(await authenticationProvider.isLoggedIn(), false);
    });
  });
}
