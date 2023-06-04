import 'package:firebase/ui/auth/verify_code.dart';
import 'package:firebase/utility/utility.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {

  bool isLoading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 50),
            TextFormField(keyboardType: TextInputType.number,
              controller: phoneNumberController,
              decoration: InputDecoration(hintText: "+234 905 433 4521"),
            ),
            SizedBox(height: 80),

            RoundButton(loading: isLoading,title: "Login", onTap: (){

              setState(() {
                isLoading = true;
              });

              auth.verifyPhoneNumber(
                  phoneNumber: phoneNumberController.text,
                  verificationCompleted: (_) {
                    setState(() {
                      isLoading = false;
                    });
                    
                  },
                  verificationFailed: (e){
                    Utility().toastMessage(e.toString());
                    print(e.toString());
                    setState(() {
                      isLoading = false;
                    });
              },
                  codeSent: (String verification, int? token){

                    Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyCode(verificationId: verification,)));
                    setState(() {
                      isLoading = false;
                    });
                    },

                  codeAutoRetrievalTimeout: (e){
                    setState(() {
                      isLoading = false;
                    });
                    Utility().toastMessage(e.toString());
                    print(e.toString());
                  });

            })
          ],
        ),
      ),
    );
  }
}
