import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/authentication.dart';

class AuthProvider with ChangeNotifier {
  final AuthenticationService _authService = AuthenticationService();
  User? _user;

  User? get user => _user;

  Future<void> signInWithGoogle() async {
    final userCredential = await _authService.signInWithGoogle();
    if (userCredential != null) {
      _user = userCredential.user;
      notifyListeners(); // Notify listeners about the change
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
