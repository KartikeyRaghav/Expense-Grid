import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/screens/auth/register.dart';
import 'package:expense_tracker/screens/auth/sign_in.dart';
import '../background_painter.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  ValueNotifier<bool> showSignInPage = ValueNotifier<bool>(true);

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 5),
        reverseDuration: const Duration(seconds: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SizedBox.expand(
          child: CustomPaint(
            painter: BackgroundPainter(
              animation: _controller.view,
            ),
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ValueListenableBuilder<bool>(
              valueListenable: showSignInPage,
              builder: (context, value, child) {
                return PageTransitionSwitcher(
                  reverse: !value,
                    duration: const Duration(seconds: 1),
                    transitionBuilder: (child, animation, secondaryAnimation) {
                      return SharedAxisTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.vertical,
                        fillColor: Colors.transparent,
                        child: child,
                      );
                    },
                    child: value
                        ? SignIn(
                            onRegisterClicked: () {
                              showSignInPage.value = false;
                              _controller.forward();
                            },
                          )
                        : Register(
                            onSignInPressed: () {
                              showSignInPage.value = true;
                              _controller.reverse();
                            },
                          ));
              },
            ),
          ),
        )
      ],
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
