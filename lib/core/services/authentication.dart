import 'package:esign/core/views/admin_view/admin_dashboard.dart';
import 'package:esign/core/views/client_view/client_dashbaord.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esign/core/models/user.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get the current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google sign-in aborted: User canceled the sign-in process');
        return null; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      await _syncUserData(userCredential.user);
      return userCredential;
    } catch (e) {
      print('Error during Google sign-in: $e');
      return null;
    }
  }


  // Sign out the user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  // Sync user data (after sign-in or registration)
  Future<void> _syncUserData(User? user) async {
    if (user == null) return; // If user is null, exit the function

    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Check if user data exists
    final userDoc = await userRef.get();
    if (!userDoc.exists) {
      // If the user document does not exist, create it
      await userRef.set({
        'id': user.uid,
        'name': user.displayName ?? 'Unnamed',
        'email': user.email ?? '',
        'isAdmin': false, // Set isAdmin to false (0)
        'permissions': [],
      });
    }
  }

  //
  Future<void> handleGoogleSignIn(BuildContext context) async {
    try {
      UserCredential? userCredential = await signInWithGoogle();
      User? user = userCredential?.user;

      if (user == null) {
        print("User is null after sign-in");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign-in aborted.")),
        );
        return; // Exit if user is null
      }

      await _syncUserData(user);
      // Fetch user data to determine if they are an admin or client
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userDoc = await userRef.get();

      if (userDoc.exists) {
        bool isAdmin = userDoc.data()?['isAdmin'] ?? false; // Assuming isAdmin is a boolean
        if (isAdmin) {
          // Navigate to admin page
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDashboard()));
        } else {
          // Navigate to client page
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientDashboard()));
        }
      } else {
        print("User document does not exist.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User document does not exist.")),
        );
      }
    } catch (e) {
      print("Sign-in failed: $e");
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-in failed: $e")),
      );
    }
  }



}
