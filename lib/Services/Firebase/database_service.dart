import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});

  //Updating refernce
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("user");
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection("group");
  //updating the UserData
  Future updateUserData(String fullname,String email) async {
    return await userCollection.doc(uid).set({
      'fullName': fullname,
      'about': 'Hey ! I am using Gup-Sup chat app ?',
      "created_at":DateTime.now().millisecondsSinceEpoch.toString(),
      "is_online":false,
      'last_active': "",
      'email': email,
      'profilePic': "https://firebasestorage.googleapis.com/v0/b/gupsup-app-be815.appspot.com/o/chat.png?alt=media&token=23f1da21-fd24-4e32-baf9-f8e520a0e6c6",
      'id': uid,
      "push_token":""
    });
  }

  


}