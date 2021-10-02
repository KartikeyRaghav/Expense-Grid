import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/pages/root_app.dart';
import 'package:expense_tracker/screens/auth/user_model.dart';

import 'auth_service.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return user == null ? const LoginPage() : RootApp(pageIndex: 0,);
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.green,),
            ),
          );
        }
      },
    );
  }
}
