import 'package:flutter/material.dart';

class LoginTitle extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const LoginTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 34
      ),
    );
  }
}
