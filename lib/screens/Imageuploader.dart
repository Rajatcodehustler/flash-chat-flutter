import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:path/path.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

String message12;
final messagetxtedtr = TextEditingController();

class Imageloader extends StatefulWidget {
  static const id = 'image_uploader';
  @override
  _ImageloaderState createState() => _ImageloaderState();
}

class _ImageloaderState extends State<Imageloader> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('view image'),),
      body: Container(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: Material(
                elevation: 5.0,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
                  child: Image(image: NetworkImage(url12),),
                ),
              ),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                children:[ Expanded(
                  child: TextField(
                    controller: messagetxtedtr,
                    onChanged: (value) {
                      message12 = 'https://' + value;
                      //Do something with the user input.
                    },
                    decoration: kMessageTextFieldDecoration,
                  ),
                ),
                  TextButton(onPressed:(){
                    messagetxtedtr.clear();
                    setState(() {
                      url12 = message12;
                      print(url12);
                    });


                  }, child: Text('see image', style: kSendButtonTextStyle,),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


