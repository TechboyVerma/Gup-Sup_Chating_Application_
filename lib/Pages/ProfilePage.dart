import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/Pages/Modals/ChatsModel.dart';
import 'package:chatapp/Services/Firebase/API.dart';
import 'package:chatapp/Services/Firebase/firebase_auth.dart';
import 'package:chatapp/Widgets/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../Widgets/button.dart';
import 'MainView.dart';


 class ProfilePage extends StatefulWidget {
   const ProfilePage({super.key,required this.user });

   final ChatUser user;



   @override
  State<ProfilePage> createState() => _ProfilePageState();
 }

class _ProfilePageState extends State<ProfilePage> {
  final _formkey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Color(0xFF553370),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Color(0xFF553370),
            title: Text(
              "Profile",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            elevation: 7,
            backgroundColor: Color(0xFF553370),
            mouseCursor: MouseCursor.uncontrolled,
            enableFeedback: true,
            splashColor:Color(0xFFBF8CEA) ,
            icon: Icon(Icons.logout,color: Colors.white),
            label: Text("Logout",style: TextStyle(color: Colors.white)),
            onPressed: (){
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Logout?'),
                    content: Text('Are you syre want to logout?'),
                    actions: [
                      CustomIconButton(icon: Icons.cancel_outlined,iconcolor: Colors.red,onTap:(){
                        Navigator.pop(context);
                      } ,),
                      CustomIconButton(icon: Icons.done,iconcolor: Colors.green,onTap:() async {
                        Dialogs.showProgressBar(context);
                        
                        await API.updateActiveStatus(false);


                        
                        await FirebaseAuthService().signout();


                        Navigator.pop(context);
                        API.auth = FirebaseAuth.instance;

                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainView(),), (route) => false);

                      } ,)
                    ],
                  );
                },);
            },
          ),
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1.12,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                color: Colors.white
              ),
              child: Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          //profile picture
                           _image != null ?
                      ClipRRect(
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*.1),
                       child: Image.file(
                         File(_image!,),
                          width: MediaQuery.of(context).size.height * .2,
                           height: MediaQuery.of(context).size.height * .2,
                         fit: BoxFit.cover,

                        ),
                      )
                          :                       
                          ClipRRect(
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*.1),
                            child: CachedNetworkImage(
                              width: MediaQuery.of(context).size.height * .2,
                              height: MediaQuery.of(context).size.height * .2,
                              imageUrl: widget.user.profilePic,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => CircleAvatar(
                                  backgroundColor: Color(0xFF553370),
                                  child: Icon(CupertinoIcons.person,color: Colors.white,size:90,)),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: MaterialButton(
                              elevation: 1,
                              color: Colors.white,
                              shape: CircleBorder(),
                              child: Icon(Icons.edit,color: Color(0xff553370)),
                                onPressed: (){
                                _showBottomSheet();
                              }),
                           )
                        ],
                      ),
                
                      SizedBox(height: MediaQuery.of(context).size.height*.03,),
                      Text(widget.user.email,style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20
                      ),),
                
                      SizedBox(height: MediaQuery.of(context).size.height*.05,),
                
                      TextFormField(
                        onSaved: (val)=> API.me.fullName = val ?? '',
                        validator: (val)=> val != null && val.isNotEmpty ? null: 'Required Field',
                        initialValue: widget.user.fullName,
                        decoration: InputDecoration(
                          prefixIcon: Icon(CupertinoIcons.person,color: Color(0xff553370)),
                          label: Text("Name"),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black, // Set the color of the border
                              width: 1.0, // Set the width of the border
                            ),
                            borderRadius: BorderRadius.circular(21),
                          )
                        ),
                      ),
                
                
                      SizedBox(height: MediaQuery.of(context).size.height*.04,),
                
                      TextFormField(
                        onSaved: (val)=> API.me.about = val ?? '',
                        validator: (val)=> val != null && val.isNotEmpty ? null: 'Required Field',
                        initialValue:widget.user.about,
                        decoration: InputDecoration(
                            prefixIcon: Icon(CupertinoIcons.info,color: Color(0xff553370)),
                            label: Text("About"),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black, // Set the color of the border
                                width: 1.0, // Set the width of the border
                              ),
                              borderRadius: BorderRadius.circular(21),
                            )
                        ),
                      ),
                
                      SizedBox(height: 50,),
                
                      ElevatedButton.icon(
                         icon: FaIcon(Icons.edit,color: Colors.white),
                      label: Text("UPDATE",style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0XFF553370),elevation: 4),
                      onPressed: (){
                           if(_formkey.currentState!.validate()){
                             _formkey.currentState!.save();
                             API.updateUserInfo().then((value) {
                               Dialogs.showSnackbar(context, "Your Information Upadted!!");
                             }) ;
                           }
                         }
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),



      ),
    );
  }
  // bottom  sheet for picking a profile picture for user
  void _showBottomSheet(){
   showModalBottomSheet(
       context: context,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(21),topRight: Radius.circular(21) )),
       builder: (_){
         return ListView(
           padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*.03,bottom: MediaQuery.of(context).size.height*.05),
           shrinkWrap: true,
           children: [
             Text("Pick Profile Picture!!",
               textAlign: TextAlign.center,
               style: TextStyle(fontSize: 20),),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [

                 ElevatedButton(
                   style: ElevatedButton.styleFrom(
                     shape: CircleBorder(),
                     backgroundColor: Colors.white,
                     fixedSize: Size(MediaQuery.of(context).size.width*.3, MediaQuery.of(context).size.height*.15)),
                     onPressed: () async {
                       final ImagePicker picker = ImagePicker();

                       final XFile? image = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
                       if(image!=null){
                         print("image path ${image.path}");

                         setState(() {
                           _image= image.path;
                         });
                         
                         API.updateProfilePicture(File(_image!));

                         //for hiding bottom sheet
                         Navigator.pop(context);
                       }
                     }, child: Image.asset("assets/images/photo.png")),
                 ElevatedButton(
                     style: ElevatedButton.styleFrom(
                         shape: CircleBorder(),
                         backgroundColor: Colors.white,
                         fixedSize: Size(MediaQuery.of(context).size.width*.3, MediaQuery.of(context).size.height*.15)),
                     onPressed: () async {
                       final ImagePicker picker = ImagePicker();

                       final XFile? image = await picker.pickImage(source: ImageSource.camera);
                       if(image!=null){
                         print("image path ${image.path}");

                         setState(() {
                           _image= image.path;
                         });
                         API.updateProfilePicture(File(_image!));

                         //for hiding bottom sheet
                         Navigator.pop(context);
                       }
                     }, child: Image.asset("assets/images/camera.png"))
               ],
             )
           ],
         );
       });
  }
}
