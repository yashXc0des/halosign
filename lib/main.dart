// import 'package:esign/admin/Admin_Dashboard.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'authentication/login/Loginscreen.dart';
// import 'client/Client_Dashboard.dart';
//
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'My App',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: StartupScreen(),
//     );
//   }
// }
//
// class StartupScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _checkUserStatus(context),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // Show a loading indicator while checking user status
//           return Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         } else {
//           // Prevent build errors if no future is being awaited
//           return Container(
//             color: Colors.red,
//           );
//         }
//       },
//     );
//   }
//
//   Future<void> _checkUserStatus(BuildContext context) async {
//     final user = FirebaseAuth.instance.currentUser;
//
//     if (user != null && user.emailVerified) {
//       // Check user role
//       final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//       if (userDoc.exists) {
//         final isAdmin = userDoc.data()?['isAdmin'] == 1;
//
//         // Navigate to the appropriate dashboard
//         if (isAdmin) {
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => Admin_Dashboard_Screen()),
//                 (route) => false,
//           );
//         } else {
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => Client_Dashboard_Screen()),
//                 (route) => false,
//           );
//         }
//       } else {
//         // If user data is missing, log out and redirect to login screen
//         await FirebaseAuth.instance.signOut();
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => LoginScreen()),
//               (route) => false,
//         );
//       }
//     } else {
//       // User is not logged in or email is not verified, redirect to login screen
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//             (route) => false,
//       );
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'authentication/login/Loginscreen.dart';
import 'newapp/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Role-Based App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen1(),
    );
  }
}

