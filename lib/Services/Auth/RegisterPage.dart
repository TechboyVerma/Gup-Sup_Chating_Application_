import 'package:chatapp/Pages/HomePage.dart';
import 'package:chatapp/Services/Firebase/API.dart';

import 'package:chatapp/Services/Shred/HelperFuncation.dart';
import 'package:chatapp/Widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Firebase/firebase_auth.dart';
import '../../Pages/SplashPage.dart';


class RegisterPage extends StatefulWidget{
  const RegisterPage({super.key, required this.controller});

  final PageController controller;



  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey  = GlobalKey<FormState>();
  final FirebaseAuthService _auth = FirebaseAuthService();
  bool showtext = true;
  bool showtext1 = true;
  bool _isLoading = false;
  String errorMessage = '';
  var style = TextStyle(color:Color(0xFF553370) );
  String passcheck = 'Check Password!';
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confrompassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? Center(child: CircularProgressIndicator(color:Color(0xFF553370) ),) : Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height/4.0,
                width: MediaQuery.of(context).size.width,

                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFF553370),
                      Color(0xffc199cd),
                    ], begin: Alignment.topLeft, end: Alignment.topRight
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xFF553370).withOpacity(0.5),
                          blurRadius: 10,
                          offset: Offset(0, 5)
                      ),
                    ],
                    borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(MediaQuery.of(context).size.width, 105.0))
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Column(
                  children: [
                    Center(
                      child:
                      Text("Signup", style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight:  FontWeight.bold),),
                    ),
                    Center(
                        child: Text("Create a new account", style: TextStyle(color: Color(0xFFbbb0ff), fontSize: 18.0, fontWeight:  FontWeight.w500),)),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
                      child: Material(
                        borderRadius:BorderRadius.circular(10) ,
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,

                            decoration: BoxDecoration(
                              color:  Colors.white,
                              borderRadius: BorderRadius.circular(10),),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text('Name',style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500)),
                                  SizedBox(height: 10.0,),

                                   TextFormField(
                                        controller: nameController,
                                        decoration: InputDecoration(
                                            hintText: 'Name' ,
                                            border: OutlineInputBorder( // Add this line to include a border
                                              borderRadius: BorderRadius.circular(21.0), // Adjust the border radius as needed
                                              borderSide: BorderSide(
                                                color: Colors.black, // Set the color of the border
                                                width: 1.0, // Set the width of the border
                                              ),
                                            ),prefixIcon: Icon(Icons.person_2_outlined,color:  Color(0xFF553370),)),
                                             validator: (value) {
                                               nameController.text=value!;
                                               if(value.isEmpty){
                                                 return "Please fill this Field!";
                                               }

                                             },
                                      ),

                                  SizedBox(height: 10.0,),

                                  //email Text
                                  Text('Email',style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500)),
                                  SizedBox(height: 10.0,),

                                  //email Textfield
                                  TextFormField(
                                        controller: emailController,
                                        decoration: InputDecoration(
                                            hintText: 'Email',
                                            border: OutlineInputBorder( // Add this line to include a border
                                              borderRadius: BorderRadius.circular(21.0), // Adjust the border radius as needed
                                              borderSide: BorderSide(
                                                color: Colors.black, // Set the color of the border
                                                width: 1.0, // Set the width of the border
                                              ),
                                            ),prefixIcon: Icon(Icons.mail_outlined,color:  Color(0xFF553370),)),
                                           validator:  (value){
                                             print('Validating email: $value');
                                             var isValid = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value!);
                                             print('Is email valid? $isValid');
                                             return isValid ? null : 'Please enter a valid email!';
                                    },
                                      ),
                                  SizedBox(height: 10.0,),

                                  //Password Text
                                  Text('Password',style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500)),
                                  SizedBox(height: 10.0,),

                                  //Password Textfiled
                                  TextFormField(
                                        controller: passwordController,
                                        obscureText: showtext,
                                        decoration: InputDecoration(
                                            hintText:'Password' ,
                                            border: OutlineInputBorder( // Add this line to include a border
                                              borderRadius: BorderRadius.circular(21.0), // Adjust the border radius as needed
                                              borderSide: BorderSide(
                                                color: Colors.black, // Set the color of the border
                                                width: 1.0, // Set the width of the border
                                              ),
                                            ),prefixIcon: Icon(Icons.password,color: Color(0xFF553370)),
                                        suffixIcon: CustomIconButton(icon: CupertinoIcons.eye_fill,onTap: (){
                                          if(showtext==true){
                                            setState(() {
                                              showtext =false;

                                            });
                                          }else{
                                            setState(() {
                                              showtext = true;
                                            });
                                          }
                                        },)  ),
                                    validator: (value) {
                                      passwordController.text = value!;
                                      if(value.length < 6){
                                        return "Password must be atleast 6 Characters!";
                                      }else{
                                        return null;
                                      }
                                    },
                                      ),


                                  //Conform password
                                  SizedBox(height: 10.0,),

                                  //Password Text
                                  Text('Confirm Password',style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500)),
                                  SizedBox(height: 10.0,),

                                  //Confrom ki Password Textfiled
                                   TextFormField(
                                        controller: confrompassController,
                                        obscureText: showtext1,
                                        decoration: InputDecoration(
                                            hintText:'Confirm Password' ,
                                            border: OutlineInputBorder( // Add this line to include a border
                                              borderRadius: BorderRadius.circular(21.0), // Adjust the border radius as needed
                                              borderSide: BorderSide(
                                                color: Colors.black, // Set the color of the border
                                                width: 1.0, // Set the width of the border
                                              ),
                                            ),prefixIcon: Icon(Icons.password,color:Color(0xFF553370)),
                                          suffixIcon: CustomIconButton(icon: CupertinoIcons.eye_fill,onTap: (){
                                            if(showtext1==true){
                                              setState(() {
                                                showtext1 =false;

                                              });
                                            }else{
                                              setState(() {
                                                showtext1 = true;
                                              });
                                            }
                                          },)

                                        ),
                                     validator: (value) {
                                          passwordController.text = value!;
                                       if(value.length < 6){
                                         return "Password must be atleast 6 Characters!";
                                       }else{
                                         return null;
                                       }
                                     },
                                      ),
                                  SizedBox(height: 4,),
                                  InkWell(onTap: (){passwordcheck();},child:Text(passcheck,style: style,)),
                                  SizedBox(height: 30),
                                  InkWell(
                                    onTap: (){
                                      widget.controller.animateToPage(1,
                                          duration: const Duration(milliseconds: 500),
                                          curve: Curves.ease);},
                                    child: RichText(text: const TextSpan(
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(text: "Already have an account?",
                                          ),
                                          TextSpan(text: " Sign In Now!",
                                              style: TextStyle(
                                                  color: Color(0xFF553370),
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w500
                                              )
                                          )]
                                    )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2,),
                    //Button
                    Center(
                      child: InkWell(
                          onTap:register,
                          child: Container(
                              width: 300,
                              decoration: BoxDecoration(
                                gradient:LinearGradient(colors: [
                                  Color(0xFF553370),
                                  Color(0xffc199cd),
                                ], begin: Alignment.topLeft, end: Alignment.topRight
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFF553370).withOpacity(0.5),
                                      blurRadius: 10,
                                      offset: Offset(0, 5)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child:
                                Center(child: Text('Signup',style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w500))),
                              ))
                      ),
                    ),
                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }





  void passwordcheck() {
    String password = passwordController.text;
    String confirmPassword = confrompassController.text;

    if (password == confirmPassword) {
      setState(() {
        passcheck = "Password matched!";
        style = TextStyle(color: Colors.green);
      });
    } else if(password== null && confirmPassword==null){
      setState(() {
        passcheck = "Check password";
        style= TextStyle(color:Color(0xFF553370));
      });

    }
    else {
      setState(() {
        passcheck = "Password Doesn't match!";
        style = TextStyle(color: Colors.red);
      });
    }
    Future.delayed(Duration(seconds: 1), () {
      passwordcheck();
    });
  }
  // sign up user
  register() async {
    String email = emailController.text.toString();
    String password = confrompassController.text.toString();
    String fullname = nameController.text.toString();

    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _auth.singup(fullname, email, password).then((value) async {
        if (value == true) {
          // Saving shared preference
          var sharedPrefs = await SharedPreferences.getInstance();
          sharedPrefs.setBool(SplashScreenState.KEYLOGIN,true);

          await HelperFuncation.saveUserNameSF(fullname);
          await HelperFuncation.saveUserEmailSF(email);
          await HelperFuncation.saveUserPicSF("https://firebasestorage.googleapis.com/v0/b/barberapp-ebcc1.appspot.com/o/icon1.png?alt=media&token=0fad24a5-a01b-4d67-b4a0-676fbc75b34a");

          showErrorMessage("Registration successful");

          // Adding debug statements for navigation
          print("Navigating to page 3");
          widget.controller.animateToPage(
            3,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );

        } else {
          print("Registration failed");
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }void showErrorMessage(String message) {

    setState(() {

      errorMessage = message;

    });
  }
  // password showing
  void password() {
    if(showtext==true){
      setState(() {
        showtext =false;

      });
    }else{
      setState(() {
        showtext = true;
      });
    }
  }


}