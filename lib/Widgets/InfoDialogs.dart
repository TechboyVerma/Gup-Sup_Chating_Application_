import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/Pages/Modals/ChatsModel.dart';
import 'package:chatapp/userProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoDialogs extends StatelessWidget{
  const InfoDialogs({super.key, required this.user});

  final ChatUser user;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xff553370).withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width*.6,
        height: MediaQuery.of(context).size.height* .35,
        child: Stack(
          children: [

            Align(
              alignment: Alignment.bottomCenter,
              child: Text(user.fullName,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: CupertinoColors.white)),
            ),

            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*.25),
                child: CachedNetworkImage(
                  width: MediaQuery.of(context).size.height * .2,
                  imageUrl: user.profilePic,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => CircleAvatar(
                      backgroundColor: Color(0xFF553370),
                      child: Icon(CupertinoIcons.person,color: Colors.white,size:90,)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton( icon: Icon(CupertinoIcons.info,color: CupertinoColors.white,),
              splashColor: Color(0xff80639a),
                onPressed: () {
                Navigator.pop(context);
               Navigator.push(
                   context,
                   MaterialPageRoute
                     (builder: (context) => userProfile(user: user),));

                },
              ),
            )


            
          ],
        ),
      ),
    );
  }
  
}