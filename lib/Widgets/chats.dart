import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/Pages/Messagespage.dart';
import 'package:chatapp/Pages/Modals/ChatsModel.dart';
import 'package:chatapp/Pages/Modals/Messages_modal.dart';
import 'package:chatapp/Widgets/InfoDialogs.dart';
import 'package:chatapp/Widgets/my_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Services/Firebase/API.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.user});

  final ChatUser user;



  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  Messages? messages;



  @override
  Widget build(BuildContext context) {
    return Material(
            color: Colors.white,
            elevation: 4,
            borderRadius: BorderRadius.circular(21),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              splashColor: Colors.grey,
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Massages(user: widget.user),));
              },
              child: StreamBuilder(

                  stream: API.getLastMessage(widget.user),
                builder: (context, snapshot) {


                  final data = snapshot.data?.docs;
                  final list = data?.map((e) => Messages.fromJson(e.data())).toList()?? [];
                  if(list.isNotEmpty) messages = list[0];

                  return ListTile(
                    splashColor:Color(0xFFBF8CEA),
                    hoverColor:Color(0xFFBF8CEA) ,

                    // for name
                    title: Text(widget.user.fullName ),
                    leading: InkWell(
                      onTap: (){
                        showDialog(context: context, builder:  (context) =>InfoDialogs(user: widget.user),);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*.3),
                        child: CachedNetworkImage(
                          width: MediaQuery.of(context).size.height * 0.055,
                          height: MediaQuery.of(context).size.height * 0.055,
                      
                          //for profile pic
                          imageUrl: widget.user.profilePic,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => CircleAvatar(
                              backgroundColor: Color(0xFF553370),
                              child: Icon(CupertinoIcons.person,color: Colors.white,)),
                        ),
                      ),
                    ),
                    //for last seen

                    subtitle: Text(messages != null ?

                        messages!.type == Type.image ?
                            'Image':
                        messages!.msg
                        : widget.user.about,maxLines: 1,),
                    // trailing: Text("12:00 AM"),
                    trailing: messages == null? null  :
                    messages!.read.isEmpty && messages!.fromID != API.user.uid ?
                    Container(
                      width: 10,
                      height:10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CupertinoColors.systemGreen,
                      ),

                    ): Text(Mydate.getlastMessagetime(context: context, time: messages!.sent),style: TextStyle(color: Colors.grey),)
                  );
                },
              )
            ),
    );
  }
}
