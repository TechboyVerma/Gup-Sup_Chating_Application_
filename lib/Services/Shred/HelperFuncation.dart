import 'package:shared_preferences/shared_preferences.dart';

class HelperFuncation {
  static String UserNameKey = "USERNAMEKEY";
  static String UserEmailKey = "USEREMAILKEY";
  static String userPicKey="USERPICKEY";


  static Future<bool> saveUserNameSF(String userName) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString((UserNameKey),userName);
  }
  static Future<bool> saveUserEmailSF(String userEmail) async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(UserEmailKey, userEmail);
  }
  static Future<bool> saveUserPicSF(String getUserPic) async{
    SharedPreferences sf= await SharedPreferences.getInstance();
    return sf.setString(userPicKey, getUserPic);
  }



  static Future<String?>  getUserEmailFromSf()  async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(UserEmailKey);
  }

  static Future<String?>  getUserNameFromSf()  async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(UserNameKey);
  }
  static Future<String?> getUserPicSF() async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userPicKey);
  }

}
