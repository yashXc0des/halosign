import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart';
import '../services/authentication.dart';


class AuthenticationNotifier extends StateNotifier<User?> {
  final AuthenticationService _authService;

  AuthenticationNotifier(this._authService) : super(null) {
    _initialize();
  }

  // Initialize the user on app start
  Future<void> _initialize() async {
    final user = _authService.currentUser;
    if (user != null) {
      state = user;
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      final userCredential = await _authService.signInWithGoogle();
      state = userCredential?.user;
    } catch (e) {
      print('Error d  uring Google Sign-In: $e');
    }
  }

  Future<UserModel> getUserById(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      return UserModel.fromJson(userDoc.data()!);
    } else {
      throw Exception('User not found');
    }
  }


  // Sign out
  Future<void> signOut() async {
    await _authService.signOut();
    state = null;
  }
  // Get user role from Firestore
  Future<UserRole> get currentUserRole async {
    final user = _authService.currentUser;
    if (user != null) {
      return await _authService.getUserRole(user.uid); // Fetch the role from Firestore
    }
    return UserRole.clientUser; // Default role
  }
}




final authenticationProvider = StateNotifierProvider<AuthenticationNotifier, User?>(
      (ref) => AuthenticationNotifier(AuthenticationService()),
);
