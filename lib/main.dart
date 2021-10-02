// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:introduction_screen/introduction_screen.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:splashscreen/splashscreen.dart';

import 'config/palette.dart';
import 'screens/auth/auth.dart';
import 'screens/auth/auth_service.dart';
import 'screens/auth/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: "Nunito"),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(
          seconds: 4,
          title: const Text(
            'Welcome to Expense Grid.\n\nThis app is developed as a part of 18 under 18 Fellowship program of Whitehat Junior.',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white),
            textAlign: TextAlign.center,
          ),
          image: Image.asset('assets/images/app_icon.png'),
          navigateAfterSeconds: const Wrapper(),
          gradientBackground: const LinearGradient(
              colors: [Color(0xff0c0036), Color(0xff3f229c)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _backColor = Palette.back;
  final _textColor = Palette.text;

  double windowWidth = 0;
  double windowHeight = 0;
  bool darkTheme = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        AnimatedContainer(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(seconds: 1),
          child: IntroductionScreen(
            globalBackgroundColor: _backColor,
            pages: [
              PageViewModel(
                  bodyWidget: introScreen(
                      context,
                      1,
                      'All in one mobile finance application',
                      'Easily manage your daily expense in one click from your hand',
                      'assets/images/onbording1.jpg',
                      darkTheme),
                  title: ''),
              PageViewModel(
                  bodyWidget: introScreen(
                      context,
                      2,
                      'Track your expenses everywhere',
                      'You can easily track your expense literally from everywhere',
                      'assets/images/onbording2.jpg',
                      darkTheme),
                  title: ''),
              PageViewModel(
                  bodyWidget: introScreen(
                      context,
                      3,
                      'Give you a maximum security for your account',
                      "Don't worry about your account, we will provide you our most secure protection",
                      'assets/images/onbording3.jpg',
                      darkTheme),
                  title: '')
            ],
            nextFlex: 0,
            next: Container(
              width: 100,
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.arrow_forward,
                color: Palette.text,
              ),
            ),
            done: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AuthScreen()));
              },
              child: Container(
                width: 100,
                alignment: Alignment.centerRight,
                child: Text(
                  'Get Started',
                  style:
                      TextStyle(fontWeight: FontWeight.w600, color: _textColor),
                ),
              ),
            ),
            curve: Curves.fastLinearToSlowEaseIn,
            onDone: () {},
            dotsFlex: 1,
            dotsDecorator: const DotsDecorator(
                size: Size(10.0, 15.0),
                color: Color(0xffb23a8b3),
                activeSize: Size(22.0, 10.0),
                activeColor: Palette.text,
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
          ),
        ),
      ],
    );
  }
}

Widget introScreen(BuildContext context, int? pageId, String? pageTitle,
    String? bodyText, String? imagePath, bool? darkTheme) {
  var size = MediaQuery.of(context).size;
  return Container(
    child: (Column(
      children: [
        AnimatedContainer(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(seconds: 1),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: Text(
                  pageTitle!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Palette.text),
                  textAlign: TextAlign.center,
                ),
              ),
              Image.asset(
                imagePath!,
                height: 250,
              )
            ],
          ),
        ),
        Container(
            margin: const EdgeInsets.only(top: 20),
            width: size.width,
            height: size.height * 0.25,
            child: Text(
              bodyText!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Palette.text, fontSize: 17),
            ))
      ],
    )),
  );
}
