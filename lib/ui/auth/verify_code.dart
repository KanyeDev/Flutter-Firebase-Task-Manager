import 'package:firebase/ui/posts/post_screen.dart';
import 'package:firebase/utility/utility.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class VerifyCode extends StatefulWidget {
  final String verificationId;

  const VerifyCode({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  @override
  bool isLoading = false;
  final verificationCodeController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 50),
            TextFormField(keyboardType: TextInputType.number,
              controller: verificationCodeController,
              decoration: const InputDecoration(hintText: "6 digit code"),
            ),
            const SizedBox(height: 80),

            RoundButton(loading: isLoading,title: "Verify", onTap: () async{
              setState(() {
                isLoading = true;
              });

              final credential = PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: verificationCodeController.text.toString());

              try{

                await auth.signInWithCredential(credential);
                Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen()));

              }
              catch(e){
                setState(() {
                  isLoading = false;
                });
                Utility().toastMessage(e.toString());

              }

            })
          ],
        ),
      ),
    );
  }
}

