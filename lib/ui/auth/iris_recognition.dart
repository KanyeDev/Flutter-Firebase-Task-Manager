import 'dart:ui';

import 'package:firebase/ui/posts/post_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase/utility/pageRoutes.dart';

class IrisRecognition extends StatefulWidget {
  const IrisRecognition({Key? key}) : super(key: key);

  @override
  State<IrisRecognition> createState() => _IrisRecognitionState();
}

class _IrisRecognitionState extends State<IrisRecognition> {
  ///new codes
  late final LocalAuthentication auth;
  bool _support_state = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => setState(() {
          _support_state = isSupported;
        }));
  }

  //
  // Future<void> _getAvalilableBiometric() async {
  //   List<BiometricType> availableBiometric = await auth
  //       .getAvailableBiometrics();
  //
  //   print('List of availableBiometrics : $availableBiometric');
  //
  //   if (!mounted) {
  //     return;
  //   }
  // }

  Future<void> _authenticate() async {
    try {

      bool authenticated = await auth.authenticate(
          localizedReason: 'Scan Iris To Authenticate',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
            biometricOnly: true,

          ));
      Navigator.of(context).push(FadeRoute(500, page: const PostScreen()));

      print('Authenticated : $authenticated');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  final _auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text('Diary'),
      ),
      body: Stack(
        children: [
          TextFormField(
            decoration: InputDecoration(
                hintText: 'Search', border: OutlineInputBorder()),
            onChanged: (String value) {
              setState(() {});
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: FirebaseAnimatedList(
                defaultChild: Text('Hello'),
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();

                  if ((snapshot.child('id').value.toString() ==
                      _auth.currentUser!.uid.toString())) {
                    return ListTile(
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
                                          snapshot.child('id').value.toString())
                                      .remove();
                                },
                                leading: Icon(Icons.delete),
                                title: Text('Delete'),
                              )),
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: SizedBox(),
          )),
          Center(
              child: ElevatedButton(
            onPressed: _authenticate,
            child: Text('Scan Iris To Access Data'),
          )),
        ],
      ),
    );
  }
}
