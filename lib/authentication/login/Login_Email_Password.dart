import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/Navigation/isadmin.dart';

Future<void> login(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      // Proceed with role-based navigation
      navigateBasedOnRole(BuildContext as BuildContext, user.uid);
    } else {
      // Sign out the user and ask them to verify their email
      await FirebaseAuth.instance.signOut();
      print('Please verify your email before logging in.');
    }
  } catch (e) {
    print(e);
  }
}
