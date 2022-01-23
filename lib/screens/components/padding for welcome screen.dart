import 'package:flutter/material.dart';

class Buttonforwlcmscrn extends StatelessWidget {
  Color clr;
  String text;
  Function func;
  Buttonforwlcmscrn({this.clr,this.text, this.func});


  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: clr,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: func,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
          ),
        ),
      ),
    );
  }
}
