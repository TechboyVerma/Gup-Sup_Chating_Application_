import 'dart:developer';

import 'package:chatapp/Pages/Modals/ChatsModel.dart';
import 'package:chatapp/Pages/ProfilePage.dart';
import 'package:chatapp/Widgets/chats.dart';
import 'package:chatapp/Widgets/button.dart';
import 'package:chatapp/Widgets/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Services/Firebase/API.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key, required PageController controller}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  List<ChatUser> list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    API.getSelfInfo();



    //for updating user active status according to lifecycle events
    //resume -- active or online
    //pause  -- inactive or offline
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

      if (API.auth.currentUser != null) {
        if (message.toString().contains('resumed')) {
          API.updateActiveStatus(true);
        }
        if (message.toString().contains('paused')) {
          API.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF553370),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF553370),
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
            borderRadius: BorderRadius.circular(50),
            splashColor: Color(0xFFBF8CEA),
            child: CustomIconButton(
              icon: _isSearching ? CupertinoIcons.clear_circled_solid : Icons.search,
              iconbgcolor: Colors.white.withOpacity(0.1),
              iconSize: 20,
            ),
          ),
          InkWell(
            splashFactory: InkRipple.splashFactory,
            borderRadius: BorderRadius.circular(50),
            splashColor: Color(0xFFBF8CEA),
            onTap: () {

              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(user: API.me),));
            },
            child: CustomIconButton(
              icon: CupertinoIcons.person,
              iconbgcolor: Colors.white.withOpacity(0.1),
              iconSize: 20,
            ),
          ),
        ],
        title: _isSearching
            ? TextField(
          decoration: InputDecoration(
              prefixIcon: Icon(CupertinoIcons.search, color: Colors.white,),
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.white, fontSize: 20),
              border: InputBorder.none
          ),
          style: TextStyle(color: Colors.white, fontSize: 20),
          onChanged: (value) {
            // Clear the previous search list
            _searchList.clear();

            // Iterate over the original list and add matching items to the search list
            for (var i in list) {
              if (i.fullName.toLowerCase().contains(value.toLowerCase()) ||
                  i.email.toLowerCase().contains(value.toLowerCase())) {
                _searchList.add(i);
              }
            }
          },
        )
            : Text(
          "Gup Sup",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(21),
        ),
        child: StreamBuilder(
          stream: API.getMyUsersId(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
              //  return Center(child: CircularProgressIndicator(color: Color(0xFF553370)),);

              case ConnectionState.active:
              case ConnectionState.done:
             return StreamBuilder(
                stream: API.getAllUsers(
                  snapshot.data?.docs.map((e) => e.id).toList() ??[]
                ),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                   //   return Center(child: CircularProgressIndicator(color: Color(0xFF553370)),);

                    case ConnectionState.active:
                    case ConnectionState.done:

                      final data = snapshot.data?.docs;

                      list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

                      log("user${list}");

                      if(list.isNotEmpty){
                        return ListView.builder(
                            itemCount: _isSearching ? _searchList.length : list.length,
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .01),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ChatPage(user: _isSearching ? _searchList[index] : list[index]),
                              );
                            });
                      }else{
                        return Center(child: Text("No connection Found",style: TextStyle(fontSize: 20),));
                      }
                  }
                },
              );
            }


          },
        )
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50, right: 30),
        child: FloatingActionButton(
          onPressed: () {
            _adduserdialog();
          },
          backgroundColor: Color(0xFF553370),
          splashColor: Color(0xFFBF8CEA),
          child: Icon(CupertinoIcons.chat_bubble_text, color: Colors.white),
        ),
      ),
    );
  }
  // for adding chat user
  void _adduserdialog(){
    String email = '';
    showDialog(context: context, builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.only(left: 24,right: 24,top: 20,bottom: 10),
      content: TextFormField(
        initialValue: email,
        maxLines: null,
        onChanged: (value) => email = value ,
        decoration: InputDecoration(
          hintText: "Email Id",
            prefixIcon: Icon(Icons.email,color: Color(0xff553370)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15)
            )
        ),
      ),
      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
          children: [Icon(Icons.person_add,color: Color(0xff553370),size: 28),
            Text(" Add User")]),
      actions: [
        MaterialButton(onPressed: (){

          //Hide Alert dialog
          Navigator.pop(context);

        },
          child: Text(
            "Cancel",
            style: TextStyle(
                color: Color(0xff553370),
                fontSize: 16
            ),
          ),
        ),
        MaterialButton(onPressed: () async {
          //Hide Alert dialog
          Navigator.pop(context);

          if(email.isNotEmpty)
            await API.addChatUser(email).then((value){
              if(!value){
                Dialogs.showSnackbar(context, "User Doesn't not Exists");
              }
            });
        },
          child: Text(
            "Update",
            style: TextStyle(
                color: Color(0xff553370),
                fontSize: 16
            ),
          ),
        )
      ],
    ),);
  }
}