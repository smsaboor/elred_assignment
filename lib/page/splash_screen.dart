import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:elred_assignment/page/home_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // animated_text_kit package is used to give animation to text
  // after 5 second delay homePage is rendered
  bool loading = true;
  bool start = true;
  late bool loginStatus;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      setState(() {
        start = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return start == true
        ? Material(
      color: Colors.indigo,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const TextWidget(
            text: "Add ",
            size: 50,
            color: Colors.white,
            weight: FontWeight.w600,
            lineheight: 14.9),
        SizedBox(
          child: DefaultTextStyle(
            style: const TextStyle(
              fontSize: 45.0,
              fontFamily: 'Horizon',
              color: Colors.blue,
              fontWeight: FontWeight.w600,
              // height: 61.28
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                RotateAnimatedText('Task'),
                RotateAnimatedText('Task'),
              ],
              onTap: () {},
            ),
          ),
        )
      ]),
    )
        : HomePage();
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget(
      {super.key,
        required this.text,
        required this.size,
        required this.color,
        required this.weight,
        required this.lineheight});

  final String text;
  final double size;
  final Color color;
  final FontWeight weight;
  final double lineheight;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
        fontFamily: FontName.nunito),
  );
}

class FontName {
  static String nunito = 'NunitoSans';
}
