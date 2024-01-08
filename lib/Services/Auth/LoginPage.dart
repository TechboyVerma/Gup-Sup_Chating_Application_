import 'package:chatapp/Services/Firebase/API.dart';
import 'package:chatapp/Services/Firebase/database_service.dart';
import 'package:chatapp/Pages/SplashPage.dart';
import 'package:chatapp/Widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Firebase/firebase_auth.dart';
import '../Shred/HelperFuncation.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key , required this.controller});
  final PageController controller;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final fromkey = GlobalKey<FormState>();
  final FirebaseAuthService _auth = FirebaseAuthService();
  bool _isLoading = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  String errorMessage = '';
  bool showtext = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? Center(
        child: CircularProgressIndicator(color: Color(0xFF553370)),) : Form(
        key: fromkey,
        child: SingleChildScrollView(
          child: Container(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 4.0,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF553370),
                        Color(0xffc199cd),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF553370).withOpacity(0.5),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(
                          MediaQuery
                              .of(context)
                              .size
                              .width, 105.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          "Signin",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Center(
                          child: Text(
                            "Login to your Account",
                            style: TextStyle(
                                color: Color(0xFFbbb0ff),
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500),
                          )),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 20.0),
                            child: Container(

                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Email',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    TextFormField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        hintText: 'Email',
                                        border: OutlineInputBorder( // Add this line to include a border
                                          borderRadius: BorderRadius.circular(
                                              21.0),
                                          // Adjust the border radius as needed
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            // Set the color of the border
                                            width: 1.0, // Set the width of the border
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.mail_outlined,
                                          color: Color(0xFF553370),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          emailController.text = value;
                                          print(value);
                                        });
                                      },
                                      validator: (value) {
                                        print('Validating email: $value');
                                        var isValid = RegExp(
                                            r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                            .hasMatch(value!);
                                        print('Is email valid? $isValid');
                                        return isValid
                                            ? null
                                            : 'Please enter a valid email';
                                      },

                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Text('Password',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    TextFormField(
                                      controller: passwordController,
                                      obscureText: showtext,
                                      decoration: InputDecoration(
                                          hintText: 'Password',
                                          border: OutlineInputBorder( // Add this line to include a border
                                            borderRadius: BorderRadius.circular(
                                                21.0),
                                            // Adjust the border radius as needed
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                              // Set the color of the border
                                              width: 1.0, // Set the width of the border
                                            ),
                                          ),
                                          suffixIcon: CustomIconButton(
                                            icon: CupertinoIcons.eye_fill,
                                            onTap: () {
                                              password();
                                            },),
                                          prefixIcon: Icon(
                                            Icons.password,
                                            color: Color(0xFF553370),
                                          )),
                                      validator: (value) {
                                        print('Validating password: $value');
                                        passwordController.text = value!;
                                        if (value.length < 6) {
                                          print('Password is too short');
                                          return 'Password must be at least 6 characters';
                                        } else {
                                          print('Password is valid');
                                          return null;
                                        }
                                      },


                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                        alignment: Alignment.centerRight,
                                        child: Text('Forget Password?',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w500))),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Center(
                                      child: InkWell(
                                        onTap: () => Login(),
                                        child: Container(
                                            width: 130,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xFF553370),
                                                    Color(0xffc199cd),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.topRight),
                                              borderRadius: BorderRadius
                                                  .circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xFF553370)
                                                      .withOpacity(0.5),
                                                  blurRadius: 10,
                                                  offset: Offset(0, 5),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Center(
                                                  child: Text(
                                                    'Signin',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight
                                                            .w500),
                                                  )),
                                            )),
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Center(
                                      child: Text(
                                        errorMessage ?? '',
                                        // Display error message here
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: () {
                          widget.controller.animateToPage(2,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        child: RichText(
                            text: const TextSpan(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "Don't have any account?",
                                      style: TextStyle(color: Colors.black)),
                                  TextSpan(
                                    text: " Sign Up Now!",
                                    style: TextStyle(
                                        color: Color(0xFF553370),
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w500),
                                  )
                                ])),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Login() async {
    String email = emailController.text.toString();
    String password = passwordController.text.toString();

    if (fromkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _auth.singin(email, password).then((value) async {
        if (value == true) {
          await API.userExists();


          // Saving shared preference
          var sharedPrefs = await SharedPreferences.getInstance();
          sharedPrefs.setBool(SplashScreenState.KEYLOGIN, true);
          await HelperFuncation.saveUserEmailSF(email);

          showErrorMessage("Signin successful");

          // Adding debug statements for navigation
          print("Navigating to page 3");
          widget.controller.animateToPage(3,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
        } else  {
          showErrorMessage("No user data found for this email");
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  void showErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });
  }

  // password showing
  void password() {
    if (showtext == true) {
      setState(() {
        showtext = false;
      });
    } else {
      setState(() {
        showtext = true;
      });
    }
  }

}