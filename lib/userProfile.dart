import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/Widgets/my_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Pages/Modals/ChatsModel.dart';
import 'Services/Firebase/API.dart';


class userProfile extends StatefulWidget{

  const userProfile({super.key,required this.user });

  final ChatUser user;

  @override
  State<userProfile> createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {

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
            widget.user.fullName,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),

        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/1.12,

          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),
              color: Colors.white
          ),
          child: Form(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
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

                  SizedBox(height: MediaQuery.of(context).size.height*.03,),

                  Container(

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      border: Border.all(
                        color: Colors.black, // Set the color of the border
                        width: 1.0, // Set the width of the border
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: Color(0xff553370),
                          ),
                          SizedBox(width: 8),
                          Text("Email:",style: TextStyle(fontSize: 15,color: Colors.grey),),
                          SizedBox(width: 8),
                          Text(widget.user.email,style: TextStyle(fontSize: 16,color: Colors.black),)

                        ],
                      ),
                    ),
                  ),





                  SizedBox(height: MediaQuery.of(context).size.height*.05),

                  Container(

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      border: Border.all(
                        color: Colors.black, // Set the color of the border
                        width: 1.0, // Set the width of the border
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: Color(0xff553370),
                          ),
                          SizedBox(width: 8),
                          Text("About:",style: TextStyle(fontSize: 15,color: Colors.grey),),
                          SizedBox(width: 8),
                          Text(widget.user.about,style: TextStyle(fontSize: 16,color: Colors.black),)

                        ],
                      ),
                    ),
                  ),
                  IconButton(onPressed: (){
                    print("user: ${widget.user.created_at}");
                  }, icon:Icon(Icons.email_outlined) ),


                  Spacer(),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Joined on: ",style: TextStyle(fontSize: 15,)),
                      Text(Mydate.getlastMessagetime(context: context, time: widget.user.created_at),style: TextStyle(fontSize: 15,color: Colors.black38),)

                    ],
                  )

                ],
              ),
            ),
          ),
        ),



      ),
    );
  }

}