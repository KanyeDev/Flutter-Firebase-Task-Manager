import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/ui/posts/add_post.dart';
import 'package:firebase/utility/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editFilter = TextEditingController();
  final editController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ref.onValue.listen((event) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Diary"),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }).onError((error, stackTrace) {
                  Utility().toastMessage(error.toString());
                });
              },
              icon: Icon(Icons.logout_outlined))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPostScreen()));
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextFormField(
              controller: searchFilter,
              decoration: InputDecoration(
                  hintText: 'Search', border: OutlineInputBorder()),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: FirebaseAnimatedList(
              duration: Duration(milliseconds: 1000),
              physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                defaultChild: Text('Hello'),
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();

                  if ((searchFilter.text.isEmpty) &&
                      (snapshot.child('id').value.toString() ==
                          auth.currentUser!.uid.toString())) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.deepPurple)),
                        child: ListTile(
                          title: Text(snapshot.child('title').value.toString()),
                          subtitle: Text(snapshot.child('time').value.toString()),
                          trailing: PopupMenuButton(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                  value: 1,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      showMyDialog(title,
                                          snapshot.child('postId').value.toString());
                                    },
                                    leading: Icon(Icons.edit),
                                    title: Text('Edit'),
                                  )),
                              PopupMenuItem(
                                  value: 1,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      ref
                                          .child(
                                              snapshot.child('postId').value.toString())
                                          .remove();
                                      Utility().toastMessage('Deleted');
                                    },
                                    leading: Icon(Icons.delete),
                                    title: Text('Delete'),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if ((snapshot.child('id').value.toString() ==
                          auth.currentUser!.uid.toString()) &&
                      (title.toLowerCase().contains(
                          searchFilter.text.toLowerCase().toLowerCase()))) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('time').value.toString()),
                    );
                  } else {
                    return Container();
                  }
                }),
          )
        ],
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update'),
          content: Container(
            child: TextField(
              controller: editController,
              decoration: InputDecoration(hintText: 'Edit'),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancle')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.child(id).update({
                    'title': editController.text.toLowerCase()
                  }).then((value) {
                    Utility().toastMessage('Updated Successfully');
                  }).onError((error, stackTrace) {
                    Utility().toastMessage(error.toString());
                  });
                },
                child: Text('Update')),
          ],
        );
      },
    );
  }
}

// Expanded(
// child: StreamBuilder(
// stream: ref.onValue,
// builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//
// if (snapshot.hasData) {
// Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
// List<dynamic> list = [];
// list.clear();
// list = map.values.toList();
//
// return ListView.builder(
// itemCount: snapshot.data!.snapshot.children.length,
// itemBuilder: (context, index) {
// return ListTile(
// title: Text(list[index]['title']),
// subtitle: Text(list[index]['id']),
// );
// });
// } else {
//
// return Padding(
// padding: const EdgeInsets.symmetric( vertical: 50.0),
// child: Center(child: CircularProgressIndicator()),
// );
// }
//
// },
// )),
