import 'package:firebase_auth/firebase_auth.dart';

/// Provide authentication stream
class Auth {
  final FirebaseAuth auth;

  Auth({required this.auth});

  // User is a type returned from Firebase.
  // Any time the state changes, we will get User type.
  Stream<User?> get user => auth.authStateChanges();

  Future<String> createAccount(
      {required String email, required String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      return "Success";
    } on FirebaseAuthException catch (error) {
      return '${error.message}';
    } catch (error) {
      rethrow;
    }
  }

  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      return "Success";
    } on FirebaseAuthException catch (error) {
      return '${error.message}';
    } catch (error) {
      rethrow;
    }
  }

  Future<String> signOut() async {
    try {
      await auth.signOut();
      return "Success";
    } on FirebaseAuthException catch (error) {
      return '${error.message}';
    } catch (error) {
      rethrow;
    }
  }
}
