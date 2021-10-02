// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:expense_tracker/config/palette.dart';

showBar(String text, IconData iconData, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(
            iconData,
            color: Palette.text,
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(child: Text(text, style: const TextStyle(color: Palette.text))),
        ],
      )));
}
