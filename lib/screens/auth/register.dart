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

class Register extends StatelessWidget {
  const Register({Key? key, required this.onSignInPressed}) : super(key: key);
  final VoidCallback onSignInPressed;

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return StreamBuilder(
        stream: auth.FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: const [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
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
                padding: const EdgeInsets.all(32),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: LoginTitle(title: 'Create\nAccount'),
                          )),
                      Expanded(
                          flex: 4,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, top: 20.0),
                            child: ListView(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: TextField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: emailController,
                                    decoration: registerInputDecoration(
                                        icon: Icons.email,
                                        hintText: 'Enter Email...'),
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: TextField(
                                    controller: passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: registerInputDecoration(
                                        icon: Icons.password,
                                        hintText: 'Enter Password...'),
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                SignUpBar(
                                    label: 'Sign Up',
                                    onPressed: () async {
                                      await createUserWithEmailAndPassword(
                                          emailController.text,
                                          passwordController.text,
                                          context);
                                    }),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: InkWell(
                                        splashColor: Colors.white,
                                        onTap: () {
                                          onSignInPressed.call();
                                        },
                                        child: const Text(
                                          'Sign In',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      )),
                                )
                              ],
                            ),
                          )),
                    ]));
          }
        });
  }

  Future createUserWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
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
      } else {
        showBar(error.message, Icons.error_outline, context);
      }
    }
  }
}
