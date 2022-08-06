import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'pages/home.dart';
import 'pages/login.dart';
import 'services/auth.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // We used a StreamBuilder because anytime anything changes in the
    // authentication state, it will be updated.
    return StreamBuilder(
      // We have created instances of FirebaseAuth and FirebaseFirestore instead
      // of creating them in the auth file otherwise everytime Auth is used
      // instances of type FirebaseAuth and FirebaseFirestore would be created.
      stream: Auth(auth: _auth).user,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasError) {
            return const Center(
                child: Text('Error receinving authentication stream'));
          } else {
            // The following condition is the same as snapshot.data?.uid == null
            // where uid = User's unique id
            // True when the user is not signed in.
            if (snapshot.data == null) {
              return Login(auth: _auth, firestore: _firestore);
            } else {
              return Home(auth: _auth, firestore: _firestore);
            }
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Center(child: Text('State: ${snapshot.connectionState}'));
        }
      },
    );
  }
}
