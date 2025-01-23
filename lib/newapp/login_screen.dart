import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'admin_dashboard_screen.dart';
import 'client_dashboard_screen.dart';

class LoginScreen1 extends StatelessWidget {
  // Function to handle Google Sign-In
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Start Google Sign-In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the login
        print('Google Sign-In canceled.');
        return;
      }

      // Authenticate the Google user
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a credential for Firebase authentication
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        print('User signed in: ${user.email}');

        // Check if the user exists in Firestore
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          // New user: create a Firestore document
          print('New user, creating Firestore document.');
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'name': user.displayName ?? '',
            'email': user.email ?? '',
            'photoUrl': user.photoURL ?? '',
            'isAdmin': 0, // Default to client
          });
        }

        // Fetch user data from Firestore
        final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userData.exists) {
          final data = userData.data();

          if (data != null) {
            final isAdmin = data['isAdmin'] == 1;

            print('User is ${isAdmin ? "an admin" : "a client"}');

            // Navigate to the appropriate dashboard
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => isAdmin ? AdminDashboardScreen() : ClientDashboardScreen(),
              ),
            );
          } else {
            print('Error: User data not found in Firestore.');
          }
        }
      }
    } catch (e) {
      // Catch and print any errors during sign-in
      print('Error during Google Sign-In: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => signInWithGoogle(context),
          child: Text('Login with Google'),
        ),
      ),
    );
  }
}
