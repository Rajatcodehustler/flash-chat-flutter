import 'package:flutter/material.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/screens/components/padding%20for%20welcome%20screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation animation;

  void initState(){
    super.initState();
    controller = AnimationController(duration: Duration(seconds: 1),vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller);

    controller.forward();
    controller.addListener(() {
      setState(() {

      });
    },);



        }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey,
                    ),
                    child: AnimatedTextKit(
                     animatedTexts:  [TypewriterAnimatedText('Test chat app',speed: Duration(milliseconds:300 ),),],

                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Buttonforwlcmscrn(clr: Colors.lightBlueAccent, text: 'Log in',func: (){
              Navigator.pushNamed(context, LoginScreen.id);
            },),
            Buttonforwlcmscrn(clr: Colors.blueAccent, text: 'Register',func: (){
              Navigator.pushNamed(context, RegistrationScreen.id);
            },),


          ],
        ),
      ),
    );
  }
}
