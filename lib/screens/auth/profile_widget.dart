import 'dart:io';

import 'package:flutter/material.dart';
import 'package:expense_tracker/config/palette.dart';

class ProfileWidget extends StatelessWidget {
  final File image;
  final VoidCallback onPressed;

  const ProfileWidget({Key? key, required this.onPressed, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        buildImage(context),
        Positioned(bottom: 0, right: 30, child: buildEditIcon(Palette.text))
      ]),
    );
  }

  Widget buildImage(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final imagePath = this.image.path;
    final image = imagePath.contains('https://')
        ? NetworkImage(imagePath)
        : FileImage(File(imagePath));

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image as ImageProvider,
          fit: BoxFit.cover,
          width: size.width - 160,
          height: size.width - 160,
          child: InkWell(
            onTap: onPressed,
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => ClipOval(
        child: Container(
          padding: const EdgeInsets.all(3),
          color: Palette.back,
          child: ClipOval(
            child: Container(
              color: color,
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.edit,
                size: 30,
                color: Palette.back,
              ),
            ),
          ),
        ),
      );
}
