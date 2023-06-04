import 'dart:async';

import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/ui/firestore/firestore_list_screen.dart';
import 'package:firebase/ui/posts/post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class SplashServises{



  void isLogin(BuildContext context){
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if(user != null){
      Timer(const Duration(seconds: 3), () =>Navigator.push(context, MaterialPageRoute(builder: (context) => FirestoreScreen())));

    }
    else{
      Timer(const Duration(seconds: 3), () =>Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())));

    }

  }

}