// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// Future<void> signUp(String email, String password, bool isAdmin) async {
//   try {
//     UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//
//     // Add user data to Firestore
//     await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
//       'email': email,
//       'isAdmin': isAdmin ? 1 : 0,
//     });
//   } catch (e) {
//     print(e);
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> signUp(String email, String password, bool isAdmin) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Send email verification
    await userCredential.user?.sendEmailVerification();

    // Save user info to Firestore with a placeholder
    await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
      'email': email,
      'isAdmin': isAdmin ? 1 : 0,
      'isEmailVerified': false, // You can use this field optionally to track email verification
    });

    print('Verification email sent. Please verify your email.');
  } catch (e) {
    print(e);
  }
}
Future<void> resendVerificationEmail() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      print('Verification email resent.');
    } else {
      print('User is already verified or not logged in.');
    }
  } catch (e) {
    print(e);
  }
}
Future<void> checkAndUpdateVerificationStatus() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null && user.emailVerified) {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'isEmailVerified': true,
    });
  }
}

