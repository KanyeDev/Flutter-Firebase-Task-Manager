import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/utility/utility.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool isLoading = false;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref("Post");
  final postController = TextEditingController();
  final auth = FirebaseAuth.instance;
  double topLeft = 0;
  double topRight = 20.0;
  double bottomLeft = 20.0;
  double bottomRight = 0;
  Color color = Colors.purple;
  Icon icon = const Icon(
    Icons.add,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 30.0),
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: const InputDecoration(
                  hintText: "What is on your mind?",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30.0),
            RoundButton(
                loading: isLoading,
                title: "Add",
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });

                  String postId = DateTime.now().microsecondsSinceEpoch.toString();
                  String id = auth.currentUser!.uid;
                  databaseRef.child(postId).set({
                    "title": postController.text.toString(),
                    'id': id,
                    'time' : DateTime.now().toString()
                  }).then((value) {
                    Utility().toastMessage("Post Added");
                    setState(() {
                      isLoading = false;
                    });
                    print("Post Added");
                  }).onError((error, stackTrace) {
                    Utility().toastMessage(error.toString());
                    setState(() {
                      isLoading = false;
                    });
                    print(error.toString());
                  });
                }),
            SizedBox(
              height: 50,
            ),


            ///the moving button
            // InkWell(
            //   onTap: () {
            //     if (topLeft == 0) {
            //       setState(() {
            //         color = Colors.deepPurpleAccent;
            //         topLeft = 20;
            //         topRight = 0;
            //         bottomLeft = 0;
            //         bottomRight = 20;
            //         icon = const Icon(Icons.remove);
            //       });
            //     } else {
            //       setState(() {
            //         color = Colors.purple;
            //         topLeft = 0;
            //         topRight = 20;
            //         bottomLeft = 20;
            //         bottomRight = 0;
            //         icon = const Icon(Icons.add);
            //       });
            //     }
            //   },
            //   child: AnimatedContainer(
            //     height: 60.0,
            //     width: 300.0,
            //     decoration: BoxDecoration(
            //       color: color,
            //       borderRadius: BorderRadius.only(
            //           topRight: Radius.circular(topRight),
            //           bottomLeft: Radius.circular(bottomLeft),
            //           bottomRight: Radius.circular(bottomRight),
            //           topLeft: Radius.circular(topLeft)),
            //     ),
            //     duration: Duration(seconds: 1),
            //     child: icon,
            //   ),
            // ),
            SizedBox(
              height: 50,
            ),



          ],
        ),
      ),
    );
  }
}
