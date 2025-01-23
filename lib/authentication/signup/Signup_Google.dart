import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

import '../../admin/Admin_Dashboard.dart';
import '../../client/Client_Dashboard.dart';
// Replace with your actual file path

Future<void> googleSignIn(BuildContext context) async {
  try {
    // Sign in with Google
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      // User canceled the sign-in
      return;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in with Firebase
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = userCredential.user;

    if (user != null) {
      // Extract user details
      final String uid = user.uid;
      final String? name = user.displayName;
      final String? email = user.email;
      final String? photoUrl = user.photoURL;
      final String? phoneNumber = user.phoneNumber;

      // Check if user document exists in Firestore
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        // If new user, create a document in Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'name': name ?? '',
          'email': email ?? '',
          'photoUrl': photoUrl ?? '',
          'phoneNumber': phoneNumber ?? '',
          'isAdmin': 0, // Default to client
          'createdAt': FieldValue.serverTimestamp(), // Store creation timestamp
          'lastSignIn': FieldValue.serverTimestamp(), // Track the last sign-in time
        });
      } else {
        // Update the last sign-in time for existing user
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'lastSignIn': FieldValue.serverTimestamp(),
        });
      }

      // Fetch the user's role
      final isAdmin = (await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get())
          .data()?['isAdmin'] == 1;

      // Navigate based on the role, clearing the back stack
      if (isAdmin) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Admin_Dashboard_Screen()),
              (route) => false, // This clears all previous routes
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Client_Dashboard_Screen()),
              (route) => false, // This clears all previous routes
        );
      }
    }
  } catch (e) {
    // Handle errors
    print('Google Sign-In Error: $e');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Something went wrong. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
