import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/Pages/Modals/Messages_modal.dart';
import 'package:chatapp/Widgets/dialogs.dart';
import 'package:chatapp/Widgets/my_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';

import '../Services/Firebase/API.dart';

class Massagescard extends StatefulWidget {

    const Massagescard({super.key,required this.messages});


      final Messages messages;


  @override
  State<Massagescard> createState() => _MassagescardState();
}

class _MassagescardState extends State<Massagescard> {


  @override
  Widget build(BuildContext context) {

    bool isMe = API.user.uid == widget.messages.fromID;

    return InkWell(
        onLongPress: () => _showBottomSheet(isMe),
        child:  isMe
        ? _greenMessage()
        : _blueMessage());
  }

  Widget _blueMessage() {
    if(widget.messages.read.isEmpty){
      API.updateMessageReadStatus(widget.messages);
    }




    return Row(
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(widget.messages.type == Type.image ? MediaQuery.of(context).size.width*.03:MediaQuery
                    .of(context)
                    .size
                    .width * .04),
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery
                        .of(context)
                        .size
                        .height * .01,
                    vertical: MediaQuery
                        .of(context)
                        .size
                        .height * .01),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Color(0xff483f50)),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    color: Color(0xff553370).withOpacity(0.5)),
                child: widget.messages.type == Type.text
                    ?
                //show text
                Text(
                  widget.messages.msg,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                )
                    :
                //show image
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: widget.messages.msg,
                    placeholder: (context, url) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          backgroundColor: Color(0xFF553370)),
                    ),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.image, size: 70),
                  ),
                )
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                    Mydate.getformattedTime(context: context, time: widget.messages.sent), style: TextStyle(fontSize: 8)),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(widget.messages.type == Type.image ? MediaQuery.of(context).size.width*.03:MediaQuery
                    .of(context)
                    .size
                    .width * .04),
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery
                        .of(context)
                        .size
                        .height * .01,
                    vertical: MediaQuery
                        .of(context)
                        .size
                        .height * .01),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Color(0xff483f50)),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30)),
                    color: Color(0xff553370)),
                child: Column(
                  children: [

                    widget.messages.type == Type.text
                        ?
                    //show text
                    Text(
                      widget.messages.msg,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    )
                        :
                    //show image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: widget.messages.msg,
                        placeholder: (context, url) => const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                              backgroundColor: Color(0xFF553370)),
                        ),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.image, size: 70),
                      ),
                    )



                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child:  Text(
                        Mydate.getformattedTime(context: context, time: widget.messages.sent), style: TextStyle(fontSize: 8)),
                  ),
                  if (widget.messages.read.isNotEmpty)
                     Icon(Icons.done_all_rounded, color: Colors.blue, size: 20) ,
                  SizedBox(width: 2,),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  // bottom  sheet for modifying massage details
  void _showBottomSheet( bool isMe ){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(21),topRight: Radius.circular(21) )),
        builder: (_){
          return ListView(
             shrinkWrap: true,

            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*.015,
                horizontal:MediaQuery.of(context).size.width*.4 ),
                height: 4,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(8),
                   color: Colors.grey
                 ),
              ),
              //copy Text and Save Image
              widget.messages.type == Type.text
                  ? InkWell(
                      onTap: () async {

                          await Clipboard.setData(
                              ClipboardData(text: widget.messages.msg))
                              .then((value) {
                            //for hiding bottom sheet
                            Navigator.pop(context);

                            Dialogs.showSnackbar(context, 'Text Copied!');
                          });
                          },
                  child: _optionItem(
                      icon: Icon(Icons.copy_all_rounded, color: Color(0xff553370), size: 26),
                      name: "Copy Text",
                     ),
                  )
                  : InkWell(
                   onTap: () async {
                     try {
                       log('Image Url: ${widget.messages.msg}');
                       await GallerySaver.saveImage(widget.messages.msg,
                           albumName: 'Gup-sup')
                           .then((success) {
                         //for hiding bottom sheet
                         Navigator.pop(context);
                         if (success != null && success) {
                           Dialogs.showSnackbar(
                               context, 'Image Successfully Saved!');
                         }
                       });
                     } catch (e) {
                       log('ErrorWhileSavingImg: $e');
                     }


                   },
                    child: _optionItem(
                      icon: Icon(Icons.download, color: Color(0xff553370), size: 26),
                      name: "Save Image",
                    ),
                  ),

                if(isMe)
              Divider(
                color: Colors.grey,
                  endIndent:MediaQuery.of(context).size.height*.04,
                indent: MediaQuery.of(context).size.height*.04,
              ),



              if(widget.messages.type == Type.text && isMe)
              //Edit Message
              InkWell(
                onTap: (){
                  //for hiding bottom sheet
                  Navigator.pop(context);
                  _showMessageUpdatEdialog();
                },
                child: _optionItem(
                    icon: Icon(Icons.edit,color: Color(0xff553370),size: 26),
                    name: "Edit Message",
                    ),
              ),

               if(isMe)  
              //Delete Message
              InkWell(
                onTap: () async {
                  await API.deleteMessage(widget.messages).then((value) {

                    //hiding bottom sheet
                    Navigator.pop(context);


                  });
                },
                child: _optionItem(
                    icon: Icon(Icons.delete_forever,color: Colors.redAccent),
                    name: "Delete Message",
                     ),
              ),

              Divider(
                color: Colors.grey,
                endIndent:MediaQuery.of(context).size.height*.04,
                indent: MediaQuery.of(context).size.height*.04,
              ),

              //Send Time
              _optionItem(
                  icon: Icon(Icons.remove_red_eye,color: Color(0xff553370),size: 26),
                  name: "Sent At: ${Mydate.getMessageTime(context: context, time: widget.messages.sent)}",
                   ),

              //Read Time
              _optionItem(
                  icon: Icon(Icons.remove_red_eye,color: Colors.green,size: 26),
                  name:widget.messages.read.isEmpty ? "Read At: Not seen yet" :
                  "Read At: ${Mydate.getMessageTime(context: context, time: widget.messages.read)}",
              ),

            ],
          );
        });
  }

  void _showMessageUpdatEdialog(){
    String UpdatingMsg = widget.messages.msg;
    showDialog(context: context, builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.only(left: 24,right: 24,top: 20,bottom: 10),
      content: TextFormField(
        initialValue: UpdatingMsg,
        maxLines: null,
        onChanged: (value) => UpdatingMsg = value ,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15)
          )
        ),
      ),
      shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(children: [Icon(Icons.message,color: Color(0xff553370),size: 28),Text(" Update Message")]),
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
        MaterialButton(onPressed: (){
          //Hide Alert dialog
          Navigator.pop(context);
          API.updateMessage(widget.messages, UpdatingMsg);
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

class _optionItem extends StatelessWidget{

  const _optionItem({ required this.icon, required this.name, });

  final Icon icon;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*.05,
          top: MediaQuery.of(context).size.height *.015,
        bottom: MediaQuery.of(context).size.height * .015

      ),
      child: Row(
        children: [
          icon,
          Flexible(child: Text("    $name",style: TextStyle(
              fontSize: 15,
              letterSpacing: 0.5,
              color: Colors.black54),))
        ],
      ),
    );
  }

}