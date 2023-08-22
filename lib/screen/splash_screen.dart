import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auth_with_provider/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: Get.width * 0.8,
          child: Center(
            child: DefaultTextStyle(
              style: GoogleFonts.inter(
                fontSize: 50,
                color: Colors.black,
                shadows: [
                  const Shadow(
                    blurRadius: 7.0,
                    color: Colors.grey,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: AnimatedTextKit(
                repeatForever: false,
                totalRepeatCount: 1,
                onFinished: () => context.go(App.routeName),
                animatedTexts: [
                  TyperAnimatedText('Hello', textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
