import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:expense_tracker/config/palette.dart';

class SignUpBar extends StatelessWidget {
  const SignUpBar({Key? key, required this.label, required this.onPressed})
      : super(key: key);
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.w800, color: Colors.white, fontSize: 24),
          ),
          const SizedBox(
            width: 90,
          ),
          _RoundContinueButton(onPressed: onPressed)
        ],
      ),
    );
  }
}

class InfoBar extends StatelessWidget {
  const InfoBar({Key? key, required this.label, required this.onPressed})
      : super(key: key);
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.w800, color: Palette.text, fontSize: 24),
          ),
          const SizedBox(
            width: 90,
          ),
          _RoundContinueButton(onPressed: onPressed)
        ],
      ),
    );
  }
}

class SignInBar extends StatelessWidget {
  const SignInBar({Key? key, required this.label, required this.onPressed})
      : super(key: key);
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 24),
          ),
          const SizedBox(
            width: 100,
          ),
          _RoundContinueButton(onPressed: onPressed)
        ],
      ),
    );
  }
}

class _RoundContinueButton extends StatelessWidget {
  const _RoundContinueButton({Key? key, required this.onPressed})
      : super(key: key);
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 0.0,
      fillColor: Palette.lightBlue,
      splashColor: Palette.darkOrange,
      padding: const EdgeInsets.all(22.0),
      shape: const CircleBorder(),
      child: const Icon(
        FontAwesomeIcons.longArrowAltRight,
        color: Colors.white,
        size: 24.0,
      ),
    );
  }
}
