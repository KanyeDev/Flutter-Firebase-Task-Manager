import 'dart:async';

import 'package:firebase/ui/auth/iris_recognition.dart';
import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/ui/firestore/firestore_list_screen.dart';
import 'package:firebase/ui/posts/post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class SplashServises{



  bool isLogin(BuildContext context){
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if(user != null){
      return false;

    }
    else{
      return true;

    }

  }

}