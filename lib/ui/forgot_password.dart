import 'package:firebase/utility/utility.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(hintText: "Email"),
            ),

            SizedBox(height: 40,),

            RoundButton(title: "Forgot",loading: isLoading, onTap: (){

              setState(() {
                isLoading = true;
              });

              auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value){

                setState(() {
                  isLoading = false;
                });
                Utility().toastMessage("Reset link sent to your mail for password recovery");
              }).onError((error, stackTrace) {
                Utility().toastMessage(error.toString());
                setState(() {
                  isLoading = false;
                });
              });

            })
          ],
        ),
      ),
    );
  }
}
