import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/Pages/Modals/ChatsModel.dart';
import 'package:chatapp/Widgets/massages_card.dart';
import 'package:chatapp/Widgets/my_date.dart';
import 'package:chatapp/userProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/Widgets/button.dart';
import 'package:image_picker/image_picker.dart';

import '../Services/Firebase/API.dart';
import 'Modals/Messages_modal.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';



class Massages extends StatefulWidget {
  const Massages({super.key, required this.user });

  final ChatUser user;







  @override
  State<Massages> createState() => _MassagesState();
}

class _MassagesState extends State<Massages> {

  // to store massages
  List<Messages> list = [];

  // for handling messages text changes
  final _textControoler = TextEditingController();

  // fo storing value of showing or hiding emoji
  bool _showEmoji = false;

  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () {
            if(_showEmoji){
              setState(() {
                _showEmoji = !_showEmoji;

              });
              return Future.value(false);
            }else{
              return Future.value(true);

            }
          },
          child: Container(
            color: Color(0xFF553370),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40,left: 12, right: 12),
                  child: StreamBuilder(
                    stream: API.getUserInfo(widget.user),
                    builder: (context, snapshot) {
                      final data = snapshot.data?.docs;
                      final list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                     //  log(  'Data: ${jsonEncode(data![0].data())}');

                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () =>Navigator.pop(context) ,
                              child: Icon(Icons.arrow_back_ios,color: Colors.white,),),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*.3),
                            child: CachedNetworkImage(
                              width: MediaQuery.of(context).size.height * .0555,
                              height: MediaQuery.of(context).size.height * .0555,
                              imageUrl:list.isNotEmpty ? list[0].profilePic : widget.user.profilePic,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => CircleAvatar(
                                  backgroundColor: Color(0xFF553370),
                                  child: Icon(CupertinoIcons.person,color: Colors.white,size:90,)),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(list.isNotEmpty ? list[0].fullName : widget.user.fullName,style: TextStyle(color: Colors.white,fontSize: 20,),),
                              Text(
                                  list.isNotEmpty
                                      ? list[0].isOnline
                                      ? 'Online'
                                      : Mydate.getLastActiveTime(
                                      context: context,
                                      lastActive: list[0].last_active)
                                      : Mydate.getLastActiveTime(
                                      context: context,
                                      lastActive: widget.user.last_active),
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.white)),
                            ],
                          ),
                          Spacer(),
                          IconButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => userProfile(user: widget.user,),));
                          }, icon: Icon(CupertinoIcons.info,color: CupertinoColors.white,))
                        ],
                      );
                    },
                  )
                ),
                Expanded(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft:Radius.circular(21),topRight:Radius.circular(21)),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: StreamBuilder(
                           stream: API.getAllMessages(widget.user),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                case ConnectionState.none:
                                  //return
                                   // Center(child: CircularProgressIndicator(color: Color(0xFF553370)),);

                                case ConnectionState.active:
                                case ConnectionState.done:

                                 final data = snapshot.data?.docs;
                                 //log('Data: ${jsonEncode(data![0].data())}');

                                 list = data?.map((e) =>  Messages.fromJson(e.data())).toList() ?? [];

                                 if(list.isNotEmpty){
                                    return ListView.builder(
                                      reverse: true,
                                        itemCount:   list.length,
                                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .01),
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Massagescard(
                                            messages: list[index],
                                          );
                                        });
                                  }else{
                                    return Center(child: Text("Say Hi!! 👋",style: TextStyle(fontSize: 20),));
                                  }
                              }
                            },
                          ),
                        ),



                          _chatinput(),

                        if(_showEmoji)SizedBox(
                          height: MediaQuery.of(context).size.height*.35,
                          child: EmojiPicker(

                            onBackspacePressed: () {
                              // Do something when the user taps the backspace button (optional)
                              // Set it to null to hide the Backspace-Button
                            },
                            textEditingController:_textControoler,
                            config: Config(
                              columns: 7,
                              emojiSizeMax: 32 * (Platform.isIOS ?1.30: 1.0),

                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              ],

            ),
          ),
        ),
      ),
    );
  }

  //chats input
  _chatinput(){
    return Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * .01,horizontal: MediaQuery.of(context).size.height * .01 ),
        child: Row(
          children: [
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Row(

                  children: [
                    IconButton(onPressed: (){
                      //for emoji

                      setState(() {
                        FocusScope.of(context).unfocus();
                        _showEmoji = !_showEmoji;
                      });


                    }, icon: Icon(Icons.emoji_emotions,color: Color(0xff553370),size: 25)),
                    Expanded(
                      child: TextField(
                        controller: _textControoler,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onTap: (){

                         if(_showEmoji){
                           setState(() {
                             _showEmoji = !_showEmoji;
                           });
                         }

                        },
                        decoration: InputDecoration(
                          hintText: 'Type Message....',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    // image button
                    IconButton(onPressed: () async {

                      final ImagePicker picker = ImagePicker();

                      final List<XFile> images= await picker.pickMultiImage( imageQuality: 80);

                      for( var i in images){
                        await API.sendChatImage(widget.user, File(i.path));
                      }

                    }, icon: Icon(Icons.image,color: Color(0xff553370),size: 25)),
                    IconButton(onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      final XFile? image = await picker.pickImage(source: ImageSource.camera);
                      if(image!=null){
                        print("image path ${image.path}");

                        API.sendChatImage(widget.user, File(image.path));
                      }
                    }, icon: Icon(Icons.camera_alt,color: Color(0xff553370),size: 25,)),

                  ],
                ),
              ),
            ),
            MaterialButton(
              minWidth: 0,
              padding: EdgeInsets.only(top: 10,bottom: 10,right: 5,left: 10),
              shape:CircleBorder(),
              color: Color(0xff553370),
              child: Icon(Icons.send_rounded,color: Colors.white,size: 28,),
              onPressed: () {
                if (_textControoler.text.isNotEmpty) {
                  if (list.isNotEmpty) {
                    //on first message (add user to my_user collection of chat user)
                    API.sendFirstMessage(
                        widget.user, _textControoler.text, Type.text);
                  } else {
                    //simply send message
                    API.sendMessage(
                        widget.user, _textControoler.text, Type.text);
                  }
                  _textControoler.text = '';
                }
              },)
          ],
        ),
      ),
    );
  }




}
