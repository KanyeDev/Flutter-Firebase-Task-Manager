import 'dart:ui';

import 'package:firebase/firebase_services/splash_services.dart';
import 'package:firebase/ui/auth/iris_recognition.dart';
import 'package:firebase/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServises splashScreen = SplashServises();
  bool isLogin =false;


  void _postOrLogin(){
    if(isLogin == false){
      Navigator.push(context, MaterialPageRoute(builder: (context) => const IrisRecognition()));

    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLogin = splashScreen.isLogin(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        children: [
          RiveAnimation.asset('assets/rotate.riv'),
          Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: SizedBox(),
              )),
          Center(child: Column(
            children: [
              const SizedBox(height: 600, width: 750, child: RiveAnimation.asset('assets/helix.riv')),
              Text("Diary App", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
              const SizedBox(height: 10, ),
              const Text("Group 2", style: TextStyle(fontSize: 20, color: Colors.deepPurple, fontWeight: FontWeight.bold),),
            ],
          ),),

          Positioned(right: 10, bottom: 10,
            child: SizedBox(
              height: 35, width: 90,
              child: ElevatedButton(onPressed: _postOrLogin, child: Row(
                children: const [
                  Text('Next'),
                  Icon(Icons.arrow_forward_ios),

                ],
              )),
            ),
          )
        ],
      ),
    );
  }
}
