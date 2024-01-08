import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key , required this.controller});
  final PageController controller;
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  static const String KEYLOGIN = 'login';

  @override
  void initState() {
    super.initState();



    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        wheretogo();

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Container(
            width: 200,
              height: 200,
              child: Image.asset("assets/images/chat.png")),
        ),
      ),
    );
  }

  @override
  void dispose() {
   _controller.dispose();
    super.dispose();
  }
  Future<void> wheretogo() async {
    var sharedPer = await SharedPreferences.getInstance();
    var loggedIn = sharedPer.getBool(KEYLOGIN);

    Timer(Duration(seconds: 2), () {
      if (loggedIn != null) {
        if (loggedIn) {
          widget.controller.animateToPage(3,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease);
        } else {
          widget.controller.animateToPage(1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease);
        }
      } else {
        widget.controller.animateToPage(1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease);
      }
    });
  }
}