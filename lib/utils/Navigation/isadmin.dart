import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esign/admin/Admin_Dashboard.dart';
import 'package:esign/client/Client_Dashboard.dart';
import "package:flutter/material.dart";

void navigateBasedOnRole(BuildContext context,String uid) async {
  final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

  if (userDoc.exists) {
    if (userDoc['isAdmin'] == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Admin_Dashboard_Screen()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Client_Dashboard_Screen()));
    }
  }
}
