import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:test/test.dart';

void main() {
  // test('Returns no user if not signed in', () async {
  //   final auth = MockFirebaseAuth();
  //   final user = auth.currentUser;
  //   expect(user, isNull);
  // });

  // group('Emits an initial User? on startup.', () {
  //   test('null if signed out', () async {
  //     final auth = MockFirebaseAuth();
  //     expect(auth.authStateChanges(), emits(null));
  //     // expect(auth.userChanges(), emitsInOrder([isA<User>()]));
  //   });
  //   test('a user if signed in', () async {
  //     final auth = MockFirebaseAuth(signedIn: true);
  //     expect(auth.authStateChanges(), emitsInOrder([isA<User>()]));
  //     expect(auth.userChanges(), emitsInOrder([isA<User>()]));
  //   });
  // });

  // Creating an account
  test('sign up with email and password', () async {
    final email = 'some@email.com';
    final password = 'some!password';
    final auth = MockFirebaseAuth();
    final result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final user = result.user!;
    expect(user.email, email);
    // expect(auth.authStateChanges(), emitsInOrder([null, isA<User>()]));
    // expect(auth.userChanges(), emitsInOrder([null, isA<User>()]));
    // expect(user.isAnonymous, isFalse);
  });

  final tUser = MockUser(
    uid: 'T3STU1D',
    email: 'bob@thebuilder.com',
  );

  //Logout
  test('Returns null after sign out', () async {
    final auth = MockFirebaseAuth(signedIn: true, mockUser: tUser);
    final user = auth.currentUser;

    await auth.signOut();

    expect(auth.currentUser, null);
    expect(auth.authStateChanges(), emitsInOrder([user, null]));
    expect(auth.userChanges(), emitsInOrder([user, null]));
  });

  // Login
  // test('Login with email and password', () async {
  //   final auth = MockFirebaseAuth(mockUser: tUser);
  //   final result = await auth.signInWithEmailAndPassword(
  //       email: 'bob@thebuilder.com', password: '123456');
  //   final user = result.user;
  //   expect(user, tUser);
  //   // print('user --> $user.uid');
  //   // print('tUser -->$tUser.uid');

  //   expect(auth.authStateChanges(), emitsInOrder([null, isA<User>()]));
  //   expect(auth.userChanges(), emitsInOrder([null, isA<User>()]));
  // });

  //   test('with token', () async {
  //     final auth = MockFirebaseAuth(mockUser: tUser);
  //     final result = await auth.signInWithCustomToken('some token');
  //     final user = result.user;
  //     expect(user, tUser);
  //     expect(auth.authStateChanges(), emitsInOrder([null, isA<User>()]));
  //     expect(auth.userChanges(), emitsInOrder([null, isA<User>()]));
  //   });

  //   test('with phone number', () async {
  //     final auth = MockFirebaseAuth(mockUser: tUser);
  //     final confirmationResult =
  //         await auth.signInWithPhoneNumber('832 234 5678');
  //     final credentials = await confirmationResult.confirm('12345');
  //     final user = credentials.user;
  //     expect(user, tUser);
  //     expect(auth.authStateChanges(), emitsInOrder([null, isA<User>()]));
  //     expect(auth.userChanges(), emitsInOrder([null, isA<User>()]));
  //   });

  //   test('anonymously', () async {
  //     final auth = MockFirebaseAuth();
  //     final result = await auth.signInAnonymously();
  //     final user = result.user!;
  //     expect(user.uid, isNotEmpty);
  //     expect(auth.authStateChanges(), emitsInOrder([null, isA<User>()]));
  //     expect(auth.userChanges(), emitsInOrder([null, isA<User>()]));
  //     expect(user.isAnonymous, isTrue);
  //   });

  //   test('should send sms code to user', () async {
  //     final auth = MockFirebaseAuth();
  //     final codeSent = Completer<bool>();
  //     // currently does not auto retrieve the sms code like it does on Android
  //     // it is left to the user to use the code to sign in, so we encompass
  //     // every platform
  //     await auth.verifyPhoneNumber(
  //       phoneNumber: '+1 832 234 5678',
  //       verificationCompleted: (_) {},
  //       verificationFailed: (_) {},
  //       codeSent: (_, __) => codeSent.complete(true),
  //       codeAutoRetrievalTimeout: (_) {},
  //     );
  //     final wasCodeSent = await codeSent.future;
  //     expect(wasCodeSent, isTrue);
  //   });
  // });

  // test('Returns a mocked user if already signed in', () async {
  //   final auth = MockFirebaseAuth(signedIn: true, mockUser: tUser);
  //   final user = auth.currentUser;
  //   expect(user, tUser);
  // });

  // test('Returns a hardcoded user token', () async {
  //   final auth = MockFirebaseAuth(signedIn: true, mockUser: tUser);
  //   final user = auth.currentUser!;
  //   final idToken = await user.getIdToken();
  //   expect(idToken, isNotEmpty);
  // });

  // group('exceptions', () {
  //   test('signInWithCredential', () async {
  //     final auth = MockFirebaseAuth(
  //       authExceptions: AuthExceptions(
  //         signInWithCredential: FirebaseAuthException(code: 'bla'),
  //       ),
  //     );
  //     expect(
  //       () async => await auth.signInWithCredential(FakeAuthCredential()),
  //       throwsA(isA<FirebaseAuthException>()),
  //     );
  //   });

  // test('signInWithEmailAndPassword', () async {
  //   final auth = MockFirebaseAuth(
  //     authExceptions: AuthExceptions(
  //       signInWithEmailAndPassword: FirebaseAuthException(code: 'bla'),
  //     ),
  //   );
  //   expect(
  //     () async => await auth.signInWithEmailAndPassword(
  //         email: 'bob@thebuilder.com', password: 'some!password'),
  //     throwsA(isA<FirebaseAuthException>()),
  //   );
  // });

  //   test('createUserWithEmailAndPassword', () async {
  //     final auth = MockFirebaseAuth(
  //       authExceptions: AuthExceptions(
  //         createUserWithEmailAndPassword: FirebaseAuthException(code: 'bla'),
  //       ),
  //     );
  //     expect(
  //       () async =>
  //           await auth.createUserWithEmailAndPassword(email: '', password: ''),
  //       throwsA(isA<FirebaseAuthException>()),
  //     );
  //   });

  //   test('signInWithCustomToken', () async {
  //     final auth = MockFirebaseAuth(
  //       authExceptions: AuthExceptions(
  //         signInWithCustomToken: FirebaseAuthException(code: 'bla'),
  //       ),
  //     );
  //     expect(
  //       () async => await auth.signInWithCustomToken(''),
  //       throwsA(isA<FirebaseAuthException>()),
  //     );
  //   });

  //   test('signInAnonymously', () async {
  //     final auth = MockFirebaseAuth(
  //       authExceptions: AuthExceptions(
  //         signInAnonymously: FirebaseAuthException(code: 'bla'),
  //       ),
  //     );
  //     expect(
  //       () async => await auth.signInAnonymously(),
  //       throwsA(isA<FirebaseAuthException>()),
  //     );
  //   });

  //   test('fetchSignInMethodsForEmail', () async {
  //     final auth = MockFirebaseAuth(
  //       authExceptions: AuthExceptions(
  //           fetchSignInMethodsForEmail: FirebaseAuthException(code: 'bla')),
  //     );
  //     expect(
  //       () async => await auth.fetchSignInMethodsForEmail(''),
  //       throwsA(isA<FirebaseAuthException>()),
  //     );
  //   });
  // });

  // test('User.reload returns', () async {
  //   final auth = MockFirebaseAuth(signedIn: true);
  //   final user = auth.currentUser;
  //   expect(user, isNotNull);
  //   // Does not throw an exception.
  //   await user!.reload();
  // });

  // test('User.updateDisplayName changes displayName', () async {
  //   final auth = MockFirebaseAuth(signedIn: true, mockUser: tUser);
  //   final user = auth.currentUser;
  //   await user!.updateDisplayName('New Bob');
  //   expect(user.displayName, 'New Bob');
  // });

  // test('User.reauthenticateWithCredential works', () async {
  //   final auth = MockFirebaseAuth(signedIn: true, mockUser: tUser);
  //   final user = auth.currentUser;
  //   expect(
  //     () async => await user!.reauthenticateWithCredential(
  //         AuthCredential(signInMethod: '', providerId: '')),
  //     returnsNormally,
  //   );
  // });

  // test('User.reauthenticateWithCredential can throw exception', () async {
  //   final auth = MockFirebaseAuth(signedIn: true, mockUser: tUser);
  //   tUser.exception = FirebaseAuthException(code: 'wrong-password');
  //   final user = auth.currentUser;
  //   expect(
  //     () async => await user!.reauthenticateWithCredential(
  //         AuthCredential(signInMethod: '', providerId: '')),
  //     throwsA(isA<FirebaseAuthException>()),
  //   );
  // });

  // test('User.updatePassword works', () async {
  //   final auth = MockFirebaseAuth(signedIn: true, mockUser: tUser);
  //   final user = auth.currentUser;
  //   expect(
  //     () async => await user!.updatePassword('newPassword'),
  //     returnsNormally,
  //   );
  // });

  // test('User.updatePassword can throw exception', () async {
  //   final auth = MockFirebaseAuth(signedIn: true, mockUser: tUser);
  //   tUser.exception = FirebaseAuthException(code: 'weak-password');
  //   final user = auth.currentUser;
  //   expect(
  //     () async => await user!.updatePassword('newPassword'),
  //     throwsA(isA<FirebaseAuthException>()),
  //   );
  // });

  // test('User.delete works', () async {
  //   final auth = MockFirebaseAuth(signedIn: true, mockUser: tUser);
  //   final user = auth.currentUser;
  //   expect(
  //     () async => await user!.delete(),
  //     returnsNormally,
  //   );
  // });

  // test('User.delete can throw exception', () async {
  //   final auth = MockFirebaseAuth(signedIn: true, mockUser: tUser);
  //   tUser.exception = FirebaseAuthException(code: 'wrong-password');
  //   final user = auth.currentUser;
  //   expect(
  //     () async => await user!.delete(),
  //     throwsA(isA<FirebaseAuthException>()),
  //   );
  // });

  // test('Listening twice works', () async {
  //   final auth = MockFirebaseAuth();
  //   expect(await auth.userChanges().first, isNull);
  //   // Fire a second event.
  //   await auth.signOut();
  //   expect(await auth.userChanges().first, isNull);
  // });

  // test('$AuthExceptions ensure equality', () {
  //   final authExceptions1 = AuthExceptions();
  //   final authExceptions2 = AuthExceptions();
  //   expect(authExceptions1, authExceptions2);
  // });
}

class FakeAuthCredential implements AuthCredential {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
