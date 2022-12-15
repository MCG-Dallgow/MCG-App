import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? getFirebaseUser() {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<dynamic> handleSignUpWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      final User user = credential.user!;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Das angebene Passwort ist zu schwach';
      } else if (e.code == 'email-already-in-use') {
        return 'Das Konto mit dieser E-Mail-Adresse existiert schon';
      } else if (e.code == 'invalid-email') {
        return 'Die angegebene E-Mail-Adresse ist ungültig';
      }
      if (kDebugMode) print(e.code);
    } catch (e) {
      if (kDebugMode) print(e);
    }
    return 'Unbekannter Fehler';
  }

  Future<dynamic> handleSignInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      final User user = credential.user!;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Es gibt kein Konto mit dieser E-Mail-Adresse';
      } else if (e.code == 'wrong-password') {
        return 'Das angegebene Passwort ist falsch';
      }
      if (kDebugMode) print(e.code);
    } catch (e) {
      if (kDebugMode) print(e);
    }
    return 'Unbekannter Fehler';
  }
}