// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:expense_tracker/config/showBar.dart';
import 'package:expense_tracker/pages/root_app.dart';
import 'package:expense_tracker/screens/auth/information.dart';
import 'package:expense_tracker/screens/auth/sign_in_up_bar.dart';
import 'package:expense_tracker/screens/auth/title.dart';
import 'decoration_functions.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart' as auth;

class SignIn extends StatelessWidget {
  const SignIn({Key? key, required this.onRegisterClicked}) : super(key: key);
  final VoidCallback onRegisterClicked;

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something Went Wrong!!!'),
            );
          } else if (snapshot.hasData) {
            var useruid = FirebaseAuth.instance.currentUser.uid;
            bool info = false;
            CollectionReference collectionReference =
                FirebaseFirestore.instance.collection('users');
            collectionReference
                .doc(useruid)
                .get()
                .then((DocumentSnapshot documentSnapshot) => {
                      if (documentSnapshot.exists)
                        {info = true}
                      else
                        {info = false}
                    });
            return info == true
                ? RootApp(
                    pageIndex: 0,
                  )
                : const Information();
          } else {
            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  const Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: LoginTitle(title: 'Welcome\nBack'),
                      )),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0, top: 20.0),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: TextField(
                              controller: emailController,
                              style: const TextStyle(color: Colors.white),
                              decoration: signInInputDecoration(
                                  icon: Icons.email,
                                  hintText: 'Enter Email...'),
                              keyboardType: TextInputType.emailAddress,
                              enableSuggestions: false,
                              autocorrect: false,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: TextField(
                              controller: passwordController,
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.visiblePassword,
                              decoration: signInInputDecoration(
                                  icon: Icons.password,
                                  hintText: 'Enter Password...'),
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                            ),
                          ),
                          SignInBar(
                              label: 'Sign In',
                              onPressed: () async {
                                await signInWithEmailAndPassword(
                                    emailController.text,
                                    passwordController.text,
                                    context);
                              }),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              splashColor: Colors.white,
                              onTap: () {
                                onRegisterClicked.call();
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      fontSize: 16,
                                      decoration: TextDecoration.underline,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        });
  }

  Future signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
      await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        User user = FirebaseAuth.instance.currentUser;
        showBar('Signed in as ${user.email}',
            Icons.assignment_turned_in_outlined, context);
      });
      return true;
    } on auth.FirebaseAuthException catch (error) {
      if (error.message.toLowerCase() == 'given string is empty or null') {
        showBar('Please fill the email and password field', Icons.error_outline,
            context);
      } else if (error.message.toLowerCase() ==
          'the email address is badly formatted.') {
        showBar(
            'Please enter the email correctly', Icons.error_outline, context);
      } else if (error.message.toLowerCase() ==
          'there is no user record corresponding to this identifier.the user may have been deleted.') {
        showBar(
            'No user present with this email id. Please register to move ahead.',
            Icons.error_outline,
            context);
      } else if (error.message.toLowerCase() ==
          'the password is invalid or the user does not have a password.') {
        showBar('Invalid Password.', Icons.error_outline, context);
      } else {
        showBar(error.message, Icons.error_outline, context);
      }
    }
  }
}
