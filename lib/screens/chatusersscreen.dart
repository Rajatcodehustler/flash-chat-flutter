import 'package:flash_chat/screens/login_screen.dart';
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
final _auth = FirebaseAuth.instance;
User loggedinuser;


class Chatscreenusr extends StatefulWidget {
  static String id = 'chatusersscreen';

  @override
  _chatscreenusrState createState() => _chatscreenusrState();
}

class _chatscreenusrState extends State<Chatscreenusr> {
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
        appBar: AppBar(title: Text('Current users'),actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async{
                Navigator.pushNamed(context, LoginScreen.id);
                await _auth.signOut();
                //Implement logout functionality
              }),
        ],),

    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Messagesstream(),
      ],
    ),);
  }
}

class Messagesstream extends StatelessWidget {

  Messagesstream();


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _chat.collection('database1').snapshots(),
        builder:
            (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(),);
          }
          final messages = snapshot.data.docs;
          List<Widget> usrname= [];
          Widget chtusr;
          for (var message in messages) {
            Map<String, dynamic> message1 = message.data();
            final usrlist = message1['email'];
            final sender12 = message1['sender'];
            final crntuser = loggedinuser.email;
              chtusr = Usrbloc(usrname1: usrlist,);
            usrname.add(chtusr);
            if(sender12==crntuser){
              usrname.removeLast();
            }



          }



          return Expanded(
            child: ListView(
              children: usrname,
            ),
          );
        }
    );
  }
}

class Usrbloc extends StatelessWidget {
 final String usrname1;
 Usrbloc({this.usrname1});



  @override
  Widget build(BuildContext context) {
    return ListTile( leading: Icon(Icons.chat),
    title: Text(usrname1),);
  }
}
