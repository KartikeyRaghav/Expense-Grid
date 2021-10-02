import 'package:flutter/material.dart';
import 'package:expense_tracker/config/palette.dart';

InputDecoration registerInputDecoration(
    {String? hintText, required IconData icon}) {
  return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
      hintStyle: const TextStyle(color: Colors.white, fontSize: 18),
      hintText: hintText,
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.lightBlue, width: 2),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Palette.orange),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(width: 2.0, color: Palette.orange),
      ),
      errorStyle: const TextStyle(color: Colors.white),
      icon: Icon(
        icon,
        color: Colors.white,
      ));
}

InputDecoration signInInputDecoration(
    {String? hintText, required IconData icon}) {
  return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
      hintStyle: const TextStyle(fontSize: 18, color: Colors.white),
      hintText: hintText,
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(width: 2, color: Palette.lightBlue),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Palette.darkOrange),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(width: 2.0, color: Palette.darkOrange),
      ),
      errorStyle: const TextStyle(color: Palette.darkOrange),
      icon: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Icon(
            icon,
            color: Colors.white,
          )));
}

InputDecoration infoInputDecoration(
    {String? hintText, required IconData icon}) {
  return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
      hintStyle: const TextStyle(fontSize: 18, color: Palette.text),
      hintText: hintText,
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(width: 2, color: Palette.lightBlue),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Palette.text),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Palette.darkOrange),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(width: 2.0, color: Palette.darkOrange),
      ),
      errorStyle: const TextStyle(color: Palette.darkOrange),
      icon: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Icon(
            icon,
            color: Palette.text,
          )));
}
