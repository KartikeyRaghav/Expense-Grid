// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:expense_tracker/screens/auth/user_model.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return User(user.uid, user.email);
  }

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }
}
