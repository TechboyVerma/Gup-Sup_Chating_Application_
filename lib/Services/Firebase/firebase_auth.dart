import 'package:chatapp/Services/Shred/HelperFuncation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Pages/SplashPage.dart';
import 'database_service.dart';

enum AuthError {
  generalError,
  emailAlreadyInUse,
  invalidEmail,
  weakPassword,
  // Add more error types as needed
}

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<dynamic> singup(String fullname,String email, String password) async {
    try {
      User user = (await _auth.createUserWithEmailAndPassword(email: email, password: password)).user!;
      if(user!=null){
        await DatabaseService(uid: user.uid).updateUserData(fullname, email);
        return true;
      }
    } catch (e) {
      print('Signup Error: $e');
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            return AuthError.emailAlreadyInUse;
          case 'invalid-email':
            return AuthError.invalidEmail;
          case 'weak-password':
            return AuthError.weakPassword;
        // Add more cases as needed
        }
      }
      return AuthError.generalError;
    }
  }

  Future<dynamic> singin(String email, String password) async {
    try {
      User user =
      ( await _auth.signInWithEmailAndPassword(email: email, password: password)).user!;

      if(user != null){
        return true;
      }
    } catch (e) {
      print('Signin Error: $e');
      return AuthError.generalError;
    }
  }


  Future signout() async{
    try{
      var sharedPrefs = await SharedPreferences.getInstance();
      sharedPrefs.setBool(SplashScreenState.KEYLOGIN, false);
      await HelperFuncation.saveUserEmailSF('');
      await HelperFuncation.saveUserNameSF('');
      await _auth.signOut();
    }catch(e){
      return null;
    }
  }

}