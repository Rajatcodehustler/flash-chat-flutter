import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flash_chat/screens/Imageuploader.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

final _chat = FirebaseFirestore.instance;
final _img = firebase_storage.FirebaseStorage.instance;
User loggedinuser;
bool lgc1;
bool lgc2 = false;

mixin Usrbsdclr {
  Color usrbsdclr(bool boolchk){
    if(boolchk==true){
      return Colors.lightBlueAccent;
    }
    else{
      return Colors.white;
    }

  }
}
class ChatScreen extends StatefulWidget with Usrbsdclr{
  static const id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messagetxtedtr = TextEditingController();
  String message;
  final _auth = FirebaseAuth.instance;
  Future uploadImageToFirebase(BuildContext context) async {
    String token = await FirebaseAppCheck.instance.getToken();
     fileName = basename(imageFile.path);
     await _img.ref("uploads/$fileName").putFile(imageFile);
     print(urlforimg1);

    }
  Future<void> downloadURLExample() async {
    urlforimg2 = await firebase_storage.FirebaseStorage.instance
        .ref('uploads/$fileName')
        .getDownloadURL();
    setState(() {
      urlforimg1 = urlforimg2;
    });
  }

  Future _getFromGallery() async {
    XFile pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        print('done');
        String fileName = basename(imageFile.path);
        print(fileName);

      }
    });

  }



  void initState(){
    super.initState();
    getuser();
  }
  void getuser(){
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedinuser = user;
      }
    }
    catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.image),
              onPressed: () {
               Navigator.pushNamed(context, Imageloader.id);
               Alert(context: context, title: "info", desc: "copy the image link and paste in the image viewer").show();
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat   to view img select img button ➪ ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ModalProgressHUD(
        inAsyncCall: lgc2,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
                   Messagesstream(),

              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messagetxtedtr,
                        onChanged: (value) {
                          message = value;
                          //Do something with the user input.
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children:[ TextButton(
                        onPressed: () {
                          _chat.collection('messages6').add({'text': message, 'sender': loggedinuser.email, 'date': DateTime.now().toIso8601String().toString()});
                          messagetxtedtr.clear();
                          //Implement send functionality.
                        },
                        child: Text(
                          'Send',
                          style: kSendButtonTextStyle,
                        ),
                      ),
                        TextButton(
                          onPressed: () async{
                            setState(() {
                              lgc2 = true;
                              imgmode = true;
                            });
                            await _getFromGallery();
                            await uploadImageToFirebase(context);
                            await downloadURLExample();
                            print(urlforimg1);
                            _chat.collection('messages6').add({'text': urlforimg1, 'sender': loggedinuser.email, 'date': DateTime.now().toIso8601String().toString()});
                            setState(() {
                              lgc2=false;
                            });



                            //Implement send functionality.
                          },
                          child: Text(
                            'Send image or gif link',
                            style: kSendButtonTextStyle,
                          ),
                        ),
        ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class Chatbubble extends StatelessWidget with Usrbsdclr {
  final String Text1;
  final String Sender;
  final bool isME;
  Chatbubble({this.Text1,this.Sender, this.isME});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isME?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(Sender, style: TextStyle(fontSize: 12.0,color: Colors.white60),),
          Material(
            borderRadius: BorderRadius.only(topLeft: isME?Radius.circular(30.0):Radius.circular(0),bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0), topRight: isME?Radius.circular(0):Radius.circular(30.0),),
            elevation: 5.0,
            color: Chatbubble().usrbsdclr(isME),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
              child: SelectableLinkify(text: Text1, style: TextStyle(color: isME?Colors.white:Colors.black, fontSize: 15.0),onOpen: (link) async {
                if (await canLaunch(link.url)) {
                  await launch(link.url);
                } else {
                  throw 'Could not launch $link';
                }
              },),
            ),
          ),
        ],
      ),
    );
  }
}
class Messagesstream extends StatelessWidget {
 static String sender;

  Messagesstream();


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _chat.collection('messages6').orderBy('date').snapshots(),
      builder:
          (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(),);
        }
        final messages = snapshot.data.docs.reversed;
        List<Widget> messageswidgets = [];
        Widget messageWidget;
        for (var message in messages) {
          Map<String, dynamic> message1 = message.data();
          final message2 = message1['text'];
          final sender12 = message1['sender'];
          final link = message1['link'];
          final crntuser = loggedinuser.email;
          messageWidget = Chatbubble(
              Text1: message2, Sender: sender12 ,isME: (crntuser == sender12),);
          messageswidgets.add(messageWidget);



        }
        return Expanded(child: ListView(
          reverse: true,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          children: messageswidgets,
        ));
      },
    );
  }
}


