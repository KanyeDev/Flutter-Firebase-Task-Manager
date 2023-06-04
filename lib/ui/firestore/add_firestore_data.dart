import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



import 'package:firebase/utility/utility.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddFirestoreDataScreen extends StatefulWidget {
  const AddFirestoreDataScreen({Key? key}) : super(key: key);

  @override
  State<AddFirestoreDataScreen> createState() => _AddFirestoreDataScreenState();
}

class _AddFirestoreDataScreenState extends State<AddFirestoreDataScreen> {
  bool isLoading = false;
  final postController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Firestore Data"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 30.0),
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: InputDecoration(
                  hintText: "What is on your mind?",
                  border: OutlineInputBorder()),
            ),
            SizedBox(height: 30.0),
            RoundButton(
                loading: isLoading,
                title: "Add",
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });

                  String id = DateTime.now().microsecondsSinceEpoch.toString();
                 fireStore.doc(id).set({
                   'title': postController.text.toString(),
                   'id' : id
                   
                 }).then((value) {
                   Utility().toastMessage("Post Added");
                   setState(() {
                     isLoading = false;
                   });

                 }).onError((error, stackTrace) {
                   Utility().toastMessage(error.toString());
                   setState(() {
                     isLoading = false;
                   });
                 });


                }),
          ],
        ),
      ),
    );
  }


}
