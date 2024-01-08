import 'dart:async';
import 'package:chatapp/Services/Auth/LoginPage.dart';
import 'package:chatapp/Pages/Modals/ChatsModel.dart';
import 'package:chatapp/Services/Auth/RegisterPage.dart';
import 'package:chatapp/Pages/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SplashPage.dart';

class MainView extends StatefulWidget {
  @override
  State<MainView> createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  late PageController controller;
  late ChatUser user;


  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage:0);

  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 4,
      controller: controller,
      itemBuilder: (context, index) {
        if (index == 0) {
          return SplashScreen(controller: controller);
        } else if (index == 1) {
          return LoginPage(controller: controller);
        } else if (index == 2) {
          return RegisterPage(controller: controller);
        } else {
          return HomePage(controller: controller,);
        }
      },
    );
  }


}
